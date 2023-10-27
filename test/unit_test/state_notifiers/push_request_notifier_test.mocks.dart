// Mocks generated by Mockito 5.4.2 from annotations
// in privacyidea_authenticator/test/unit_test/state_notifiers/push_request_notifier_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;
import 'dart:typed_data' as _i5;

import 'package:firebase_messaging/firebase_messaging.dart' as _i10;
import 'package:http/http.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:pointycastle/export.dart' as _i2;
import 'package:privacyidea_authenticator/model/tokens/push_token.dart' as _i7;
import 'package:privacyidea_authenticator/utils/firebase_utils.dart' as _i9;
import 'package:privacyidea_authenticator/utils/network_utils.dart' as _i8;
import 'package:privacyidea_authenticator/utils/rsa_utils.dart' as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeRSAPublicKey_0 extends _i1.SmartFake implements _i2.RSAPublicKey {
  _FakeRSAPublicKey_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeRSAPrivateKey_1 extends _i1.SmartFake implements _i2.RSAPrivateKey {
  _FakeRSAPrivateKey_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAsymmetricKeyPair_2<B extends _i2.PublicKey,
        V extends _i2.PrivateKey> extends _i1.SmartFake
    implements _i2.AsymmetricKeyPair<B, V> {
  _FakeAsymmetricKeyPair_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeResponse_3 extends _i1.SmartFake implements _i3.Response {
  _FakeResponse_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [RsaUtils].
///
/// See the documentation for Mockito's code generation for more information.
class MockRsaUtils extends _i1.Mock implements _i4.RsaUtils {
  MockRsaUtils() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.RSAPublicKey deserializeRSAPublicKeyPKCS1(String? keyStr) =>
      (super.noSuchMethod(
        Invocation.method(
          #deserializeRSAPublicKeyPKCS1,
          [keyStr],
        ),
        returnValue: _FakeRSAPublicKey_0(
          this,
          Invocation.method(
            #deserializeRSAPublicKeyPKCS1,
            [keyStr],
          ),
        ),
      ) as _i2.RSAPublicKey);

  @override
  String serializeRSAPublicKeyPKCS1(_i2.RSAPublicKey? publicKey) =>
      (super.noSuchMethod(
        Invocation.method(
          #serializeRSAPublicKeyPKCS1,
          [publicKey],
        ),
        returnValue: '',
      ) as String);

  @override
  _i2.RSAPublicKey deserializeRSAPublicKeyPKCS8(String? keyStr) =>
      (super.noSuchMethod(
        Invocation.method(
          #deserializeRSAPublicKeyPKCS8,
          [keyStr],
        ),
        returnValue: _FakeRSAPublicKey_0(
          this,
          Invocation.method(
            #deserializeRSAPublicKeyPKCS8,
            [keyStr],
          ),
        ),
      ) as _i2.RSAPublicKey);

  @override
  String serializeRSAPublicKeyPKCS8(_i2.RSAPublicKey? key) =>
      (super.noSuchMethod(
        Invocation.method(
          #serializeRSAPublicKeyPKCS8,
          [key],
        ),
        returnValue: '',
      ) as String);

  @override
  String serializeRSAPrivateKeyPKCS1(_i2.RSAPrivateKey? key) =>
      (super.noSuchMethod(
        Invocation.method(
          #serializeRSAPrivateKeyPKCS1,
          [key],
        ),
        returnValue: '',
      ) as String);

  @override
  _i2.RSAPrivateKey deserializeRSAPrivateKeyPKCS1(String? keyStr) =>
      (super.noSuchMethod(
        Invocation.method(
          #deserializeRSAPrivateKeyPKCS1,
          [keyStr],
        ),
        returnValue: _FakeRSAPrivateKey_1(
          this,
          Invocation.method(
            #deserializeRSAPrivateKeyPKCS1,
            [keyStr],
          ),
        ),
      ) as _i2.RSAPrivateKey);

  @override
  bool verifyRSASignature(
    _i2.RSAPublicKey? publicKey,
    _i5.Uint8List? signedMessage,
    _i5.Uint8List? signature,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #verifyRSASignature,
          [
            publicKey,
            signedMessage,
            signature,
          ],
        ),
        returnValue: false,
      ) as bool);

  @override
  _i6.Future<String?> trySignWithToken(
    _i7.PushToken? token,
    String? message,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #trySignWithToken,
          [
            token,
            message,
          ],
        ),
        returnValue: _i6.Future<String?>.value(),
      ) as _i6.Future<String?>);

  @override
  _i6.Future<_i2.AsymmetricKeyPair<_i2.RSAPublicKey, _i2.RSAPrivateKey>>
      generateRSAKeyPair() => (super.noSuchMethod(
            Invocation.method(
              #generateRSAKeyPair,
              [],
            ),
            returnValue: _i6.Future<
                    _i2.AsymmetricKeyPair<_i2.RSAPublicKey,
                        _i2.RSAPrivateKey>>.value(
                _FakeAsymmetricKeyPair_2<_i2.RSAPublicKey, _i2.RSAPrivateKey>(
              this,
              Invocation.method(
                #generateRSAKeyPair,
                [],
              ),
            )),
          ) as _i6.Future<
              _i2.AsymmetricKeyPair<_i2.RSAPublicKey, _i2.RSAPrivateKey>>);

  @override
  String createBase32Signature(
    _i2.RSAPrivateKey? privateKey,
    _i5.Uint8List? dataToSign,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #createBase32Signature,
          [
            privateKey,
            dataToSign,
          ],
        ),
        returnValue: '',
      ) as String);

  @override
  _i5.Uint8List createRSASignature(
    _i2.RSAPrivateKey? privateKey,
    _i5.Uint8List? dataToSign,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #createRSASignature,
          [
            privateKey,
            dataToSign,
          ],
        ),
        returnValue: _i5.Uint8List(0),
      ) as _i5.Uint8List);
}

/// A class which mocks [PrivacyIdeaIOClient].
///
/// See the documentation for Mockito's code generation for more information.
class MockPrivacyIdeaIOClient extends _i1.Mock
    implements _i8.PrivacyIdeaIOClient {
  MockPrivacyIdeaIOClient() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<void> triggerNetworkAccessPermission({
    required Uri? url,
    bool? sslVerify = true,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #triggerNetworkAccessPermission,
          [],
          {
            #url: url,
            #sslVerify: sslVerify,
          },
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<_i3.Response> doPost({
    required Uri? url,
    required Map<String, String?>? body,
    bool? sslVerify = true,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #doPost,
          [],
          {
            #url: url,
            #body: body,
            #sslVerify: sslVerify,
          },
        ),
        returnValue: _i6.Future<_i3.Response>.value(_FakeResponse_3(
          this,
          Invocation.method(
            #doPost,
            [],
            {
              #url: url,
              #body: body,
              #sslVerify: sslVerify,
            },
          ),
        )),
      ) as _i6.Future<_i3.Response>);

  @override
  _i6.Future<_i3.Response> doGet({
    required Uri? url,
    required Map<String, String?>? parameters,
    bool? sslVerify = true,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #doGet,
          [],
          {
            #url: url,
            #parameters: parameters,
            #sslVerify: sslVerify,
          },
        ),
        returnValue: _i6.Future<_i3.Response>.value(_FakeResponse_3(
          this,
          Invocation.method(
            #doGet,
            [],
            {
              #url: url,
              #parameters: parameters,
              #sslVerify: sslVerify,
            },
          ),
        )),
      ) as _i6.Future<_i3.Response>);
}

/// A class which mocks [FirebaseUtils].
///
/// See the documentation for Mockito's code generation for more information.
class MockFirebaseUtils extends _i1.Mock implements _i9.FirebaseUtils {
  MockFirebaseUtils() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<void> initFirebase({
    required _i6.Future<void> Function(_i10.RemoteMessage)? foregroundHandler,
    required _i6.Future<void> Function(_i10.RemoteMessage)? backgroundHandler,
    required void Function(String?)? updateFirebaseToken,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #initFirebase,
          [],
          {
            #foregroundHandler: foregroundHandler,
            #backgroundHandler: backgroundHandler,
            #updateFirebaseToken: updateFirebaseToken,
          },
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<String?> getFBToken() => (super.noSuchMethod(
        Invocation.method(
          #getFBToken,
          [],
        ),
        returnValue: _i6.Future<String?>.value(),
      ) as _i6.Future<String?>);
}
