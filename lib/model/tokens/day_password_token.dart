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
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import '../token_container.dart';
import 'package:uuid/uuid.dart';

import '../../utils/errors.dart';
import '../../utils/identifiers.dart';
import '../enums/algorithms.dart';
import '../enums/day_password_token_view_mode.dart';
import '../enums/encodings.dart';
import '../enums/token_types.dart';
import '../extensions/enums/algorithms_extension.dart';
import '../extensions/enums/encodings_extension.dart';
import '../token_import/token_origin_data.dart';
import 'otp_token.dart';
import 'token.dart';

part 'day_password_token.g.dart';

@JsonSerializable()
@immutable
class DayPasswordToken extends OTPToken {
  static String get tokenType => TokenTypes.DAYPASSWORD.name;
  final DayPasswordTokenViewMode viewMode;
  final Duration period;

  DayPasswordToken({
    required Duration period,
    required super.id,
    required super.algorithm,
    required super.digits,
    required super.secret,
    super.containerSerial,
    super.serial,
    this.viewMode = DayPasswordTokenViewMode.VALIDFOR,
    String? type, // just for @JsonSerializable(): type of DayPasswordToken is always TokenTypes.DAYPASSWORD
    super.tokenImage,
    super.sortIndex,
    super.folderId,
    super.pin,
    super.isLocked,
    super.isHidden,
    super.origin,
    super.label = '',
    super.issuer = '',
  })  : period = period.inSeconds > 0 ? period : const Duration(hours: 24),
        super(type: TokenTypes.DAYPASSWORD.name);

  @override
  // Only the viewMode can be changed even if its the same token
  bool sameValuesAs(Token other) {
    return super.sameValuesAs(other) && other is DayPasswordToken && other.viewMode == viewMode;
  }

  @override
  // It is the same token the the period as to be the same
  bool isSameTokenAs(Token other) {
    return super.isSameTokenAs(other) && other is DayPasswordToken && other.period == period;
  }

  @override
  bool operator ==(Object other) {
    return super == other && other is DayPasswordToken && other.period == period && other.viewMode == viewMode;
  }

  @override
  int get hashCode => Object.hashAll([super.hashCode, period, viewMode]);

  @override
  DayPasswordToken copyWith({
    String? serial,
    Duration? period,
    DayPasswordTokenViewMode? viewMode,
    String? label,
    String? issuer,
    String? Function()? containerSerial,
    String? id,
    Algorithms? algorithm,
    int? digits,
    String? secret,
    String? tokenImage,
    bool? pin,
    bool? isLocked,
    bool? isHidden,
    int? sortIndex,
    int? Function()? folderId,
    TokenOriginData? origin,
  }) =>
      DayPasswordToken(
        serial: serial ?? this.serial,
        period: period ?? this.period,
        viewMode: viewMode ?? this.viewMode,
        label: label ?? this.label,
        issuer: issuer ?? this.issuer,
        containerSerial: containerSerial != null ? containerSerial() : this.containerSerial,
        id: id ?? this.id,
        type: TokenTypes.DAYPASSWORD.name,
        algorithm: algorithm ?? this.algorithm,
        digits: digits ?? this.digits,
        secret: secret ?? this.secret,
        tokenImage: tokenImage ?? this.tokenImage,
        sortIndex: sortIndex ?? this.sortIndex,
        pin: pin ?? this.pin,
        isLocked: isLocked ?? this.isLocked,
        isHidden: isHidden ?? this.isHidden,
        folderId: folderId != null ? folderId() : this.folderId,
        origin: origin ?? this.origin,
      );

  @override
  String get otpValue => algorithm.generateTOTPCodeString(
        secret: secret,
        time: DateTime.now(),
        length: digits,
        interval: period,
        isGoogle: true,
      );

  Duration get durationSinceLastOTP {
    final msPassedThisPeriod = (DateTime.now().millisecondsSinceEpoch) % period.inMilliseconds;
    return Duration(milliseconds: msPassedThisPeriod);
  }

  Duration get durationUntilNextOTP => period - durationSinceLastOTP;
  DateTime get thisOTPTimeStart => DateTime.now().subtract(durationSinceLastOTP);
  DateTime get nextOTPTimeStart {
    // Sometimes there is an rounding error. For example it showes sometomes 23:59:59 instead of 00:00:00 so we add 1ms to be sure
    return DateTime.now().add(durationUntilNextOTP + const Duration(milliseconds: 1));
  }

  @override
  DayPasswordToken copyWithFromTemplate(TokenTemplate template) {
    final uriMap = template.data;
    return copyWith(
      label: uriMap[URI_LABEL],
      issuer: uriMap[URI_ISSUER],
      id: uriMap[URI_ID] == String ? uriMap[URI_ID] : const Uuid().v4(),
      serial: uriMap[URI_SERIAL],
      algorithm: uriMap[URI_ALGORITHM] != null ? Algorithms.values.byName((uriMap[URI_ALGORITHM] as String).toUpperCase()) : null,
      digits: uriMap[URI_DIGITS],
      secret: uriMap[URI_SECRET] != null ? Encodings.base32.encode(uriMap[URI_SECRET]) : null,
      period: uriMap[URI_PERIOD] != null ? Duration(seconds: uriMap[URI_PERIOD]) : null,
      tokenImage: uriMap[URI_IMAGE],
      pin: uriMap[URI_PIN],
      isLocked: uriMap[URI_PIN],
      origin: uriMap[URI_ORIGIN],
    );
  }

  factory DayPasswordToken.fromUriMap(Map<String, dynamic> uriMap) {
    validateUriMap(uriMap);
    return DayPasswordToken(
      label: uriMap[URI_LABEL] ?? '',
      issuer: uriMap[URI_ISSUER] ?? '',
      id: const Uuid().v4(),
      algorithm: Algorithms.values.byName((uriMap[URI_ALGORITHM] as String? ?? 'SHA1').toUpperCase()),
      digits: uriMap[URI_DIGITS] ?? 6,
      secret: Encodings.base32.encode(uriMap[URI_SECRET]),
      period: Duration(seconds: uriMap[URI_PERIOD] ?? 86400), // default 24 hours
      tokenImage: uriMap[URI_IMAGE],
      pin: uriMap[URI_PIN],
      isLocked: uriMap[URI_PIN],
      origin: uriMap[URI_ORIGIN],
    );
  }

  @override
  Map<String, dynamic> toUriMap() {
    return super.toUriMap()
      ..addAll({
        URI_PERIOD: period.inSeconds,
      });
  }

  /// Validates the uriMap for the required fields throws [LocalizedArgumentError] if a field is missing or invalid.
  static void validateUriMap(Map<String, dynamic> uriMap) {
    if (uriMap[URI_SECRET] is! Uint8List) {
      throw LocalizedArgumentError(
        localizedMessage: ((localizations, value, name) => localizations.secretIsRequired),
        unlocalizedMessage: 'Secret is required and must be a Uint8List',
        invalidValue: uriMap[URI_SECRET],
        name: URI_SECRET,
      );
    }
    if (uriMap[URI_PERIOD] != null && uriMap[URI_PERIOD] < 1) {
      throw LocalizedArgumentError(
        localizedMessage: (localizations, value, parameter) => localizations.invalidValueForParameter(value, parameter),
        unlocalizedMessage: 'Period must be greater than 0',
        invalidValue: uriMap[URI_PERIOD],
        name: URI_PERIOD,
      );
    }
    if (uriMap[URI_DIGITS] != null && uriMap[URI_DIGITS] < 1) {
      throw LocalizedArgumentError(
        localizedMessage: (localizations, value, parameter) => localizations.invalidValueForParameter(value, parameter),
        unlocalizedMessage: 'Digits must be greater than 0',
        invalidValue: uriMap[URI_DIGITS],
        name: URI_DIGITS,
      );
    }
    if (uriMap[URI_ALGORITHM] != null) {
      try {
        Algorithms.values.byName((uriMap[URI_ALGORITHM] as String).toUpperCase());
      } catch (e) {
        throw ArgumentError('Algorithm ${uriMap[URI_ALGORITHM]} is not supported');
      }
    }
  }

  @override
  Map<String, dynamic> toJson() => _$DayPasswordTokenToJson(this);
  factory DayPasswordToken.fromJson(Map<String, dynamic> json) => _$DayPasswordTokenFromJson(json);

  @override
  String toString() => 'DayPassword${super.toString()}period: $period';
}
