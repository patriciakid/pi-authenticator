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
import 'package:flutter/material.dart';

import 'globals.dart';
import 'logger.dart';

/// Shows a snackbar message to the user for a given `Duration`.
void showMessage({
  required String message,
  Duration duration = const Duration(seconds: 5),
}) {
  if (globalSnackbarKey.currentState == null) {
    Logger.warning('globalSnackbarKey.currentState is null');
    return;
  }
  globalSnackbarKey.currentState!.showSnackBar(
    SnackBar(content: Text(message), duration: duration),
  );
}

Future<T?> showAsyncDialog<T>({
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) {
  if (globalContextSync == null) {
    Logger.error('globalContextSync is null');
    return Future.value(null);
  }
  return showDialog(
    context: globalContextSync!,
    builder: builder,
    useRootNavigator: false,
    barrierDismissible: barrierDismissible,
  );
}
