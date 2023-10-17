import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:base32/base32.dart';
import 'package:collection/collection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:pi_authenticator_legacy/pi_authenticator_legacy.dart';
import 'package:pointycastle/asymmetric/api.dart';
import '../interfaces/repo/token_repository.dart';
import '../utils/firebase_utils.dart';
import '../utils/network_utils.dart';
import '../utils/qr_parser.dart';
import '../utils/riverpod_providers.dart';
import '../utils/rsa_utils.dart';
import '../model/enums/schemes.dart';

import '../model/push_request.dart';
import '../model/states/token_state.dart';
import '../model/tokens/hotp_token.dart';
import '../model/tokens/push_token.dart';
import '../model/tokens/token.dart';
import '../utils/customizations.dart';
import '../utils/identifiers.dart';
import '../utils/logger.dart';
import '../repo/secure_token_repository.dart';
import '../utils/utils.dart';
import '../utils/view_utils.dart';
import '../widgets/two_step_dialog.dart';

class TokenNotifier extends StateNotifier<TokenState> {
  Future<void>? isLoading;
  final TokenRepository _repo;
  final QrParser _qrParser;
  final RsaUtils _rsaUtils;
  final LegacyUtils _legacy;
  final PrivacyIdeaIOClient _ioClient;
  final FirebaseUtils _firebaseUtils;

  TokenNotifier({
    TokenState? initialState,
    TokenRepository? repository,
    QrParser? qrParser,
    RsaUtils? rsaUtils,
    LegacyUtils? legacy,
    PrivacyIdeaIOClient? ioClient,
    FirebaseUtils? firebaseUtils,
  })  : _rsaUtils = rsaUtils ?? const RsaUtils(),
        _qrParser = qrParser ?? const QrParser(),
        _repo = repository ?? const SecureTokenRepository(),
        _legacy = legacy ?? const LegacyUtils(),
        _ioClient = ioClient ?? const PrivacyIdeaIOClient(),
        _firebaseUtils = firebaseUtils ?? FirebaseUtils(),
        super(
          initialState ?? TokenState(),
        ) {
    loadFromRepo();
  }

  void _saveOrReplaceTokens(List<Token> tokens) async {
    isLoading = Future(() async {
      final failedTokens = await _repo.saveOrReplaceTokens(tokens);
      if (failedTokens.isNotEmpty) {
        Logger.warning(
          'Saving tokens failed. Failed Tokens: ${failedTokens.length}',
          name: 'token_notifier.dart#_saveOrReplaceTokens',
        );
        state = state.addOrReplaceTokens(failedTokens);
      }
      for (var newToken in tokens) {
        if (newToken is PushToken && !newToken.isRolledOut && !failedTokens.contains(newToken)) rolloutPushToken(newToken);
      }
    });
  }

  void _deleteTokens(List<Token> tokens) async {
    isLoading = Future(() async {
      final failedTokens = await _repo.deleteTokens(tokens);
      state = state.addOrReplaceTokens(failedTokens);
      if (state.hasPushTokens == false) {
        globalRef?.read(settingsProvider.notifier).setHidePushTokens(isHidden: false);
      }
    });
  }

  Future<bool> loadFromRepo() async {
    List<Token> tokens;
    try {
      isLoading = Future(() async {
        tokens = await _repo.loadTokens();
        final pushTokens = tokens.whereType<PushToken>();
        if (pushTokens.isNotEmpty) {
          checkNotificationPermission();
        }

        final pushTokensNotRolledOut = pushTokens.where((element) => !element.isRolledOut).toList();
        state = TokenState(tokens: tokens);
        for (final pushToken in pushTokensNotRolledOut) {
          rolloutPushToken(pushToken);
        }
      });
    } catch (_) {
      return false;
    }
    return true;
  }

  Future<bool> refreshRolledOutPushTokens() async {
    await isLoading;
    List<Token> tokens;
    try {
      tokens = await _repo.loadTokens();
    } catch (_) {
      return false;
    }
    final rolledOutPushToken = tokens.whereType<PushToken>().where((element) => element.isRolledOut).toList();
    Logger.info('Refreshed ${rolledOutPushToken.length} Pushtokens from storage.', name: 'token_notifier.dart#refreshTokens');
    state = state.addOrReplaceTokens(rolledOutPushToken);
    return true;
  }

  Token? getTokenFromId(String id) {
    return state.tokens.firstWhereOrNull((element) => element.id == id);
  }

  void incrementCounter(HOTPToken token) {
    token = token.copyWith(counter: token.counter + 1);
    state = state.addOrReplaceToken(token);
    _saveOrReplaceTokens([token]);
  }

  void removeToken(Token token) {
    state = state.withoutToken(token);
    _deleteTokens([token]);
  }

  void addOrReplaceToken(Token token) {
    state = state.addOrReplaceToken(token);
    _saveOrReplaceTokens([token]);
  }

  void updateToken(Token token) {
    state = state.updateToken(token);
    _saveOrReplaceTokens([token]);
  }

  /// Returns all tokens that could not be saved.
  void addOrReplaceTokens(List<Token> updatedTokens) {
    state = state.addOrReplaceTokens(updatedTokens);
    _saveOrReplaceTokens(updatedTokens);
  }

  void handleLink(Uri uri) {
    if (uri.scheme == enumAsString(UriSchemes.otpauth)) {
      addTokenFromOtpAuth(otpAuth: uri.toString());
      return;
    }
    if (uri.scheme == enumAsString(UriSchemes.pia)) {
      addTokenFromPia(pia: uri.toString());
      return;
    }
    showMessage(message: 'Scheme "${uri.scheme}" is not supported', duration: const Duration(seconds: 3));
  }

  void addTokenFromPia({required String pia}) async {
    // TODO: Implement pia:// scheme
    showMessage(message: 'Scheme "pia" is not implemented yet', duration: const Duration(seconds: 3));
  }

  void addTokenFromOtpAuth({
    required String otpAuth,
  }) async {
    Logger.info(
      'Try to handle otpAuth:',
      name: 'token_notifier.dart#addTokenFromOtpAuth',
      error: otpAuth,
    );

    try {
      Map<String, dynamic> uriMap = _qrParser.parseQRCodeToMap(otpAuth);

      if (_qrParser.is2StepURI(Uri.parse(otpAuth))) {
        // Calculate the whole secret.
        uriMap[URI_SECRET] = (await showDialog<Uint8List>(
          context: globalNavigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (BuildContext context) => TwoStepDialog(
            iterations: uriMap[URI_ITERATIONS],
            keyLength: uriMap[URI_OUTPUT_LENGTH_IN_BYTES],
            saltLength: uriMap[URI_SALT_LENGTH],
            password: uriMap[URI_SECRET],
          ),
        ))!;
      }
      Token newToken;
      try {
        newToken = Token.fromUriMap(uriMap);
      } on FormatException catch (e) {
        Logger.warning('Error while parsing otpAuth.', name: 'token_notifier.dart#addTokenFromOtpAuth', error: e);
        showMessage(message: e.message, duration: const Duration(seconds: 3));
        return;
      }

      if (newToken is PushToken && state.tokens.contains(newToken)) {
        showMessage(message: 'A token with the serial ${newToken.serial} already exists!', duration: const Duration(seconds: 2));
        return;
      }
      addOrReplaceToken(newToken);

      return;
    } on ArgumentError catch (e, s) {
      // Error while parsing qr code.
      Logger.warning('Malformed QR code:', name: 'token_notifier.dart#_handleOtpAuth', error: e, stackTrace: s);
      showMessage(message: '${e.message}\n Please inform the creator of this qr code about the problem.', duration: const Duration(seconds: 8));
      return;
    }
  }

  Future<bool> addPushRequestToToken(PushRequest pr) async {
    await isLoading;
    PushToken? token = state.tokens.whereType<PushToken>().firstWhereOrNull((t) => t.serial == pr.serial && t.isRolledOut);
    Logger.info('Adding push request to token', name: 'token_notifier.dart#addPushRequestToToken');
    if (token == null) {
      Logger.warning('The requested token does not exist or is not rolled out.', name: 'token_notifier.dart#addPushRequestToToken');
      return false;
    }
    String signature = pr.signature;
    String signedData = '${pr.nonce}|'
        '${pr.uri}|'
        '${pr.serial}|'
        '${pr.question}|'
        '${pr.title}|'
        '${pr.sslVerify ? '1' : '0'}';

    // Re-add url and sslverify to android legacy tokens:
    if (token.url == null) {
      token = token.copyWith(url: pr.uri, sslVerify: pr.sslVerify);
    }
    bool isVerified = token.privateTokenKey == null
        ? await _legacy.verify(token.serial, signedData, signature)
        : _rsaUtils.verifyRSASignature(token.rsaPublicServerKey!, utf8.encode(signedData) as Uint8List, base32.decode(signature));

    if (!isVerified) {
      Logger.warning(
        'Validating incoming message failed.',
        name: 'token_notifier.dart#addPushRequestToToken',
        error: 'Signature does not match signed data.',
      );
      return false;
    }
    Logger.info('Validating incoming message was successful.', name: 'token_notifier.dart#addPushRequestToToken');

    if (token.knowsRequestWithId(pr.id)) {
      Logger.info(
        'The push request already exists.',
        name: 'token_notifier.dart#addPushRequestToToken',
      );
      return false;
    }
    // Save the pending request.
    token = token.withPushRequest(pr);
    updateToken(token);

    // Remove the request after it expires.
    int time = pr.expirationDate.difference(DateTime.now()).inMilliseconds;
    Future.delayed(Duration(milliseconds: time < 1 ? 1 : time), () async => globalRef?.read(tokenProvider.notifier).removePushRequest(pr));

    Logger.info('Added push request ${pr.id} to token ${token.id}', name: 'token_notifier.dart#addPushRequestToToken');
    return true;
  }

  bool removePushRequest(PushRequest pushRequest) {
    Logger.info('Removing push request ${pushRequest.id}');
    PushToken? token = state.tokens.whereType<PushToken>().firstWhereOrNull((t) => t.serial == pushRequest.serial);

    if (token == null) {
      Logger.warning('The requested token with serial "${pushRequest.serial}" does not exist.', name: 'token_notifier.dart#removePushRequest');
      return false;
    }
    token = token.withoutPushRequest(pushRequest);
    updateToken(token);

    Logger.info('Removed push request from token ${token.id}', name: 'token_notifier.dart#removePushRequest');
    return true;
  }

  Future<bool> rolloutPushToken(PushToken token) async {
    token = (getTokenFromId(token.id)) as PushToken? ?? token;
    assert(token.url != null, 'Token url is null. Cannot rollout token without url.');
    Logger.info('Rolling out token "${token.id}"', name: 'token_widgets.dart#rolloutPushToken');
    if (token.isRolledOut) return true;
    if (token.rolloutState != PushTokenRollOutState.rolloutNotStarted &&
        token.rolloutState != PushTokenRollOutState.generatingRSAKeyPairFailed &&
        token.rolloutState != PushTokenRollOutState.sendRSAPublicKeyFailed &&
        token.rolloutState != PushTokenRollOutState.parsingResponseFailed) {
      Logger.info('Ignoring rollout request: Rollout of token "${token.id}" already started. Tokenstate: ${token.rolloutState} ',
          name: 'token_widgets.dart#rolloutPushToken');
      return false;
    }
    if (token.expirationDate?.isBefore(DateTime.now()) == true) {
      Logger.info('Ignoring rollout request: Token "${token.id}" is expired. ', name: 'token_widgets.dart#rolloutPushToken');
      if (globalNavigatorKey.currentContext != null) {
        showMessage(
          message: AppLocalizations.of(globalNavigatorKey.currentContext!)!.errorRollOutTokenExpired(token.label),
          duration: const Duration(seconds: 3),
        );
      }
      removeToken(token);
      return false;
    }
    if (!kIsWeb && Platform.isIOS) {
      await _ioClient.triggerNetworkAccessPermission(url: token.url!, sslVerify: token.sslVerify);
    }

    if (token.privateTokenKey == null) {
      updateToken(token.copyWith(rolloutState: PushTokenRollOutState.generatingRSAKeyPair));
      try {
        final keyPair = await _rsaUtils.generateRSAKeyPair();
        token = token.withPrivateTokenKey(keyPair.privateKey);
        token = token.withPublicTokenKey(keyPair.publicKey);
        updateToken(token);
        Logger.info('Updated token "${token.id}"', name: 'token_widgets.dart#rolloutPushToken');
        checkNotificationPermission();
      } catch (e, s) {
        Logger.error('Error while generating RSA key pair.', name: 'token_widgets.dart#rolloutPushToken', error: e, stackTrace: s);
        updateToken(token.copyWith(rolloutState: PushTokenRollOutState.generatingRSAKeyPairFailed));
        return false;
      }
    }

    updateToken(token.copyWith(rolloutState: PushTokenRollOutState.sendRSAPublicKey));
    try {
      // TODO What to do with poll only tokens if google-services is used?
      Response response = await _ioClient.doPost(
        sslVerify: token.sslVerify,
        url: token.url!,
        body: {
          'enrollment_credential': token.enrollmentCredentials,
          'serial': token.serial,
          'fbtoken': await _firebaseUtils.getFBToken(),
          'pubkey': _rsaUtils.serializeRSAPublicKeyPKCS8(token.rsaPublicTokenKey!),
        },
      );

      if (response.statusCode == 200) {
        updateToken(token.copyWith(rolloutState: PushTokenRollOutState.parsingResponse));
        try {
          RSAPublicKey publicServerKey = await _parseRollOutResponse(response);
          token = token.withPublicServerKey(publicServerKey);
        } on FormatException catch (e, s) {
          showMessage(message: "Couldn't parsing RSA public key: ${e.message}", duration: const Duration(seconds: 3));
          Logger.warning('Error while parsing RSA public key.', name: 'token_widgets.dart#rolloutPushToken', error: e, stackTrace: s);
          updateToken(token.copyWith(rolloutState: PushTokenRollOutState.parsingResponseFailed));
          return false;
        } finally {
          Logger.info('Roll out successful', name: 'token_widgets.dart#rolloutPushToken');
          token = token.copyWith(isRolledOut: true, rolloutState: PushTokenRollOutState.rolloutComplete);
          updateToken(token);
        }
        return true;
      } else {
        Logger.warning('Post request on roll out failed.',
            name: 'token_widgets.dart#rolloutPushToken',
            error: 'Token: ${token.serial}\nStatus code: ${response.statusCode},\nURL:${response.request?.url}\nBody: ${response.body}');

        String? message;
        try {
          message = response.body.isNotEmpty ? (json.decode(response.body)['result']?['error']?['message']) : null;
        } on FormatException catch (_) {
          message = AppLocalizations.of(globalNavigatorKey.currentContext!)!.errorRollOutNoConnectionToServer(token.label);
        }
        message = message != null ? '\n$message' : '';
        showMessage(
          message: AppLocalizations.of(globalNavigatorKey.currentContext!)!.errorRollOutFailed(token.label, response.statusCode) + message,
          duration: const Duration(seconds: 3),
        );
        updateToken(token.copyWith(rolloutState: PushTokenRollOutState.sendRSAPublicKeyFailed));
        return false;
      }
    } catch (e, s) {
      if (e is PlatformException && e.code == FIREBASE_TOKEN_ERROR_CODE || e is SocketException || e is TimeoutException || e is FirebaseException) {
        Logger.warning('Connection error: Roll out push token failed.', name: 'token_widgets.dart#rolloutPushToken', error: e, stackTrace: s);
        showMessage(
          message: AppLocalizations.of(globalNavigatorKey.currentContext!)!.errorRollOutNoConnectionToServer(token.label),
          duration: const Duration(seconds: 3),
        );
        updateToken(token.copyWith(rolloutState: PushTokenRollOutState.sendRSAPublicKeyFailed));
      } else if (e is HandshakeException) {
        Logger.warning('SSL error: Roll out push token failed.', name: 'token_widgets.dart#rolloutPushToken', error: e, stackTrace: s);
        showMessage(
          message: AppLocalizations.of(globalNavigatorKey.currentContext!)!.errorRollOutSSLHandshakeFailed,
          duration: const Duration(seconds: 3),
        );
        updateToken(token.copyWith(rolloutState: PushTokenRollOutState.sendRSAPublicKeyFailed));
      } else {
        if (globalNavigatorKey.currentContext != null) {
          showMessage(
            message: AppLocalizations.of(globalNavigatorKey.currentContext!)!.errorRollOutUnknownError(e),
            duration: const Duration(seconds: 3),
          );
        }
        Logger.error('Roll out push token failed.', name: 'token_widgets.dart#rolloutPushToken', error: e, stackTrace: s);
        updateToken(token.copyWith(rolloutState: PushTokenRollOutState.sendRSAPublicKeyFailed));
      }
      return false;
    }
  }

  Future<RSAPublicKey> _parseRollOutResponse(Response response) async {
    Logger.info('Parsing rollout response, try to extract public_key.', name: 'token_widgets.dart#_parseRollOutResponse');
    try {
      String key = json.decode(response.body)['detail']['public_key'];
      key = key.replaceAll('\n', '');

      Logger.info('Extracting public key was successful.', name: 'token_widgets.dart#_parseRollOutResponse', error: key);

      return _rsaUtils.deserializeRSAPublicKeyPKCS1(key);
    } on FormatException catch (e) {
      throw FormatException('Response body does not contain RSA public key.', e);
    }
  }
}
