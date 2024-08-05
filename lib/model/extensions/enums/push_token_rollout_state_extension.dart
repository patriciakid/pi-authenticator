/*
 * privacyIDEA Authenticator
 *
 * Author: Frank Merkel <frank.merkel@netknights.it>
 *
 * Copyright (c) 2024 NetKnights GmbH
 *
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import '../../../l10n/app_localizations.dart';
import '../../enums/push_token_rollout_state.dart';

extension PushTokenRollOutStateX on PushTokenRollOutState {
  bool get rollOutInProgress => switch (this) {
        PushTokenRollOutState.rolloutNotStarted => false,
        PushTokenRollOutState.generatingRSAKeyPair => true,
        PushTokenRollOutState.generatingRSAKeyPairFailed => false,
        PushTokenRollOutState.sendRSAPublicKey => true,
        PushTokenRollOutState.sendRSAPublicKeyFailed => false,
        PushTokenRollOutState.parsingResponse => true,
        PushTokenRollOutState.parsingResponseFailed => false,
        PushTokenRollOutState.rolloutComplete => false,
      };

  PushTokenRollOutState getFailed() => switch (this) {
        PushTokenRollOutState.rolloutNotStarted => PushTokenRollOutState.rolloutNotStarted,
        PushTokenRollOutState.generatingRSAKeyPair => PushTokenRollOutState.generatingRSAKeyPairFailed,
        PushTokenRollOutState.generatingRSAKeyPairFailed => PushTokenRollOutState.generatingRSAKeyPairFailed,
        PushTokenRollOutState.sendRSAPublicKey => PushTokenRollOutState.sendRSAPublicKeyFailed,
        PushTokenRollOutState.sendRSAPublicKeyFailed => PushTokenRollOutState.sendRSAPublicKeyFailed,
        PushTokenRollOutState.parsingResponse => PushTokenRollOutState.parsingResponseFailed,
        PushTokenRollOutState.parsingResponseFailed => PushTokenRollOutState.parsingResponseFailed,
        PushTokenRollOutState.rolloutComplete => PushTokenRollOutState.rolloutComplete,
      };

  String rolloutMsg(AppLocalizations localizations) => switch (this) {
        PushTokenRollOutState.rolloutNotStarted => localizations.rollingOut,
        PushTokenRollOutState.generatingRSAKeyPair => localizations.generatingRSAKeyPair,
        PushTokenRollOutState.generatingRSAKeyPairFailed => localizations.generatingRSAKeyPairFailed,
        PushTokenRollOutState.sendRSAPublicKey => localizations.sendingRSAPublicKey,
        PushTokenRollOutState.sendRSAPublicKeyFailed => localizations.sendingRSAPublicKeyFailed,
        PushTokenRollOutState.parsingResponse => localizations.parsingResponse,
        PushTokenRollOutState.parsingResponseFailed => localizations.parsingResponseFailed,
        PushTokenRollOutState.rolloutComplete => localizations.rolloutCompleted,
      };
}
