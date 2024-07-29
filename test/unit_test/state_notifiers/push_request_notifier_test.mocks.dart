// Mocks generated by Mockito 5.4.4 from annotations
// in privacyidea_authenticator/test/unit_test/state_notifiers/push_request_notifier_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i10;
import 'dart:typed_data' as _i9;

import 'package:http/http.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i8;
import 'package:pointycastle/export.dart' as _i2;
import 'package:privacyidea_authenticator/interfaces/repo/push_request_repository.dart' as _i14;
import 'package:privacyidea_authenticator/model/push_request.dart' as _i13;
import 'package:privacyidea_authenticator/model/states/push_request_state.dart' as _i7;
import 'package:privacyidea_authenticator/model/tokens/push_token.dart' as _i11;
import 'package:privacyidea_authenticator/utils/firebase_utils.dart' as _i4;
import 'package:privacyidea_authenticator/utils/privacyidea_io_client.dart' as _i5;
import 'package:privacyidea_authenticator/utils/push_provider.dart' as _i12;
import 'package:privacyidea_authenticator/utils/rsa_utils.dart' as _i6;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
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

class _FakeAsymmetricKeyPair_2<B extends _i2.PublicKey, V extends _i2.PrivateKey> extends _i1.SmartFake implements _i2.AsymmetricKeyPair<B, V> {
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

class _FakeFirebaseUtils_4 extends _i1.SmartFake implements _i4.FirebaseUtils {
  _FakeFirebaseUtils_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakePrivacyideaIOClient_5 extends _i1.SmartFake implements _i5.PrivacyideaIOClient {
  _FakePrivacyideaIOClient_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeRsaUtils_6 extends _i1.SmartFake implements _i6.RsaUtils {
  _FakeRsaUtils_6(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakePushRequestState_7 extends _i1.SmartFake implements _i7.PushRequestState {
  _FakePushRequestState_7(
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
class MockRsaUtils extends _i1.Mock implements _i6.RsaUtils {
  MockRsaUtils() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.RSAPublicKey deserializeRSAPublicKeyPKCS1(String? keyStr) => (super.noSuchMethod(
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
  String serializeRSAPublicKeyPKCS1(_i2.RSAPublicKey? publicKey) => (super.noSuchMethod(
        Invocation.method(
          #serializeRSAPublicKeyPKCS1,
          [publicKey],
        ),
        returnValue: _i8.dummyValue<String>(
          this,
          Invocation.method(
            #serializeRSAPublicKeyPKCS1,
            [publicKey],
          ),
        ),
      ) as String);

  @override
  _i2.RSAPublicKey deserializeRSAPublicKeyPKCS8(String? keyStr) => (super.noSuchMethod(
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
  String serializeRSAPublicKeyPKCS8(_i2.RSAPublicKey? key) => (super.noSuchMethod(
        Invocation.method(
          #serializeRSAPublicKeyPKCS8,
          [key],
        ),
        returnValue: _i8.dummyValue<String>(
          this,
          Invocation.method(
            #serializeRSAPublicKeyPKCS8,
            [key],
          ),
        ),
      ) as String);

  @override
  String serializeRSAPrivateKeyPKCS1(_i2.RSAPrivateKey? key) => (super.noSuchMethod(
        Invocation.method(
          #serializeRSAPrivateKeyPKCS1,
          [key],
        ),
        returnValue: _i8.dummyValue<String>(
          this,
          Invocation.method(
            #serializeRSAPrivateKeyPKCS1,
            [key],
          ),
        ),
      ) as String);

  @override
  _i2.RSAPrivateKey deserializeRSAPrivateKeyPKCS1(String? keyStr) => (super.noSuchMethod(
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
    _i9.Uint8List? signedMessage,
    _i9.Uint8List? signature,
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
  _i10.Future<String?> trySignWithToken(
    _i11.PushToken? token,
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
        returnValue: _i10.Future<String?>.value(),
      ) as _i10.Future<String?>);

  @override
  _i10.Future<_i2.AsymmetricKeyPair<_i2.RSAPublicKey, _i2.RSAPrivateKey>> generateRSAKeyPair() => (super.noSuchMethod(
        Invocation.method(
          #generateRSAKeyPair,
          [],
        ),
        returnValue:
            _i10.Future<_i2.AsymmetricKeyPair<_i2.RSAPublicKey, _i2.RSAPrivateKey>>.value(_FakeAsymmetricKeyPair_2<_i2.RSAPublicKey, _i2.RSAPrivateKey>(
          this,
          Invocation.method(
            #generateRSAKeyPair,
            [],
          ),
        )),
      ) as _i10.Future<_i2.AsymmetricKeyPair<_i2.RSAPublicKey, _i2.RSAPrivateKey>>);

  @override
  String createBase32Signature(
    _i2.RSAPrivateKey? privateKey,
    _i9.Uint8List? dataToSign,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #createBase32Signature,
          [
            privateKey,
            dataToSign,
          ],
        ),
        returnValue: _i8.dummyValue<String>(
          this,
          Invocation.method(
            #createBase32Signature,
            [
              privateKey,
              dataToSign,
            ],
          ),
        ),
      ) as String);

  @override
  _i9.Uint8List createRSASignature(
    _i2.RSAPrivateKey? privateKey,
    _i9.Uint8List? dataToSign,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #createRSASignature,
          [
            privateKey,
            dataToSign,
          ],
        ),
        returnValue: _i9.Uint8List(0),
      ) as _i9.Uint8List);
}

/// A class which mocks [PrivacyideaIOClient].
///
/// See the documentation for Mockito's code generation for more information.
class MockPrivacyideaIOClient extends _i1.Mock implements _i5.PrivacyideaIOClient {
  MockPrivacyideaIOClient() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i10.Future<bool> triggerNetworkAccessPermission({
    required Uri? url,
    bool? sslVerify = true,
    bool? isRetry = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #triggerNetworkAccessPermission,
          [],
          {
            #url: url,
            #sslVerify: sslVerify,
            #isRetry: isRetry,
          },
        ),
        returnValue: _i10.Future<bool>.value(false),
      ) as _i10.Future<bool>);

  @override
  _i10.Future<_i3.Response> doPost({
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
        returnValue: _i10.Future<_i3.Response>.value(_FakeResponse_3(
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
      ) as _i10.Future<_i3.Response>);

  @override
  _i10.Future<_i3.Response> doGet({
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
        returnValue: _i10.Future<_i3.Response>.value(_FakeResponse_3(
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
      ) as _i10.Future<_i3.Response>);
}

/// A class which mocks [PushProvider].
///
/// See the documentation for Mockito's code generation for more information.
class MockPushProvider extends _i1.Mock implements _i12.PushProvider {
  MockPushProvider() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool get pollingIsEnabled => (super.noSuchMethod(
        Invocation.getter(#pollingIsEnabled),
        returnValue: false,
      ) as bool);

  @override
  set pollingIsEnabled(bool? _pollingIsEnabled) => super.noSuchMethod(
        Invocation.setter(
          #pollingIsEnabled,
          _pollingIsEnabled,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.FirebaseUtils get firebaseUtils => (super.noSuchMethod(
        Invocation.getter(#firebaseUtils),
        returnValue: _FakeFirebaseUtils_4(
          this,
          Invocation.getter(#firebaseUtils),
        ),
      ) as _i4.FirebaseUtils);

  @override
  _i5.PrivacyideaIOClient get ioClient => (super.noSuchMethod(
        Invocation.getter(#ioClient),
        returnValue: _FakePrivacyideaIOClient_5(
          this,
          Invocation.getter(#ioClient),
        ),
      ) as _i5.PrivacyideaIOClient);

  @override
  _i6.RsaUtils get rsaUtils => (super.noSuchMethod(
        Invocation.getter(#rsaUtils),
        returnValue: _FakeRsaUtils_6(
          this,
          Invocation.getter(#rsaUtils),
        ),
      ) as _i6.RsaUtils);

  @override
  void setPollingEnabled(bool? enablePolling) => super.noSuchMethod(
        Invocation.method(
          #setPollingEnabled,
          [enablePolling],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i10.Future<void> pollForChallenges({required bool? isManually}) => (super.noSuchMethod(
        Invocation.method(
          #pollForChallenges,
          [],
          {#isManually: isManually},
        ),
        returnValue: _i10.Future<void>.value(),
        returnValueForMissingStub: _i10.Future<void>.value(),
      ) as _i10.Future<void>);

  @override
  _i10.Future<void> pollForChallenge(
    _i11.PushToken? token, {
    bool? isManually = true,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #pollForChallenge,
          [token],
          {#isManually: isManually},
        ),
        returnValue: _i10.Future<void>.value(),
        returnValueForMissingStub: _i10.Future<void>.value(),
      ) as _i10.Future<void>);

  @override
  _i10.Future<(List<_i11.PushToken>, List<_i11.PushToken>)?> updateFirebaseToken([String? firebaseToken]) => (super.noSuchMethod(
        Invocation.method(
          #updateFirebaseToken,
          [firebaseToken],
        ),
        returnValue: _i10.Future<(List<_i11.PushToken>, List<_i11.PushToken>)?>.value(),
      ) as _i10.Future<(List<_i11.PushToken>, List<_i11.PushToken>)?>);

  @override
  void unsubscribe(void Function(_i13.PushRequest)? newRequest) => super.noSuchMethod(
        Invocation.method(
          #unsubscribe,
          [newRequest],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void subscribe(void Function(_i13.PushRequest)? newRequest) => super.noSuchMethod(
        Invocation.method(
          #subscribe,
          [newRequest],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [PushRequestRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockPushRequestRepository extends _i1.Mock implements _i14.PushRequestRepository {
  MockPushRequestRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i10.Future<_i7.PushRequestState> loadState() => (super.noSuchMethod(
        Invocation.method(
          #loadState,
          [],
        ),
        returnValue: _i10.Future<_i7.PushRequestState>.value(_FakePushRequestState_7(
          this,
          Invocation.method(
            #loadState,
            [],
          ),
        )),
      ) as _i10.Future<_i7.PushRequestState>);

  @override
  _i10.Future<void> saveState(_i7.PushRequestState? pushRequestState) => (super.noSuchMethod(
        Invocation.method(
          #saveState,
          [pushRequestState],
        ),
        returnValue: _i10.Future<void>.value(),
        returnValueForMissingStub: _i10.Future<void>.value(),
      ) as _i10.Future<void>);

  @override
  _i10.Future<void> clearState() => (super.noSuchMethod(
        Invocation.method(
          #clearState,
          [],
        ),
        returnValue: _i10.Future<void>.value(),
        returnValueForMissingStub: _i10.Future<void>.value(),
      ) as _i10.Future<void>);

  @override
  _i10.Future<_i7.PushRequestState> add(
    _i13.PushRequest? pushRequest, {
    _i7.PushRequestState? state,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #add,
          [pushRequest],
          {#state: state},
        ),
        returnValue: _i10.Future<_i7.PushRequestState>.value(_FakePushRequestState_7(
          this,
          Invocation.method(
            #add,
            [pushRequest],
            {#state: state},
          ),
        )),
      ) as _i10.Future<_i7.PushRequestState>);

  @override
  _i10.Future<_i7.PushRequestState> remove(
    _i13.PushRequest? pushRequest, {
    _i7.PushRequestState? state,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #remove,
          [pushRequest],
          {#state: state},
        ),
        returnValue: _i10.Future<_i7.PushRequestState>.value(_FakePushRequestState_7(
          this,
          Invocation.method(
            #remove,
            [pushRequest],
            {#state: state},
          ),
        )),
      ) as _i10.Future<_i7.PushRequestState>);
}
