import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:sqlite3/open.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  if (Platform.isWindows) {
    final dll = File('.dart_tool/test-sqlite/sqlite3.dll');
    if (!dll.existsSync()) {
      throw StateError(
        'Run ./tool/prepare-test-sqlite.ps1 before Windows tests.',
      );
    }
    // winsqlite3.dll on some Windows releases is compiled OMIT_FOREIGN_KEY.
    // Native mobile apps use the bundled sqlite3_flutter_libs library instead.
    open.overrideFor(
      OperatingSystem.windows,
      () => DynamicLibrary.open(dll.absolute.path),
    );
  }
  await testMain();
}
