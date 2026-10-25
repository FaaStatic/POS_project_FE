import 'picked_file.dart';

export 'picked_file.dart';

/// Tests set this to simulate the user's choice; null means cancelled.
PickedFile? debugPickedFile;

Future<PickedFile?> pickFile({required List<String> accept}) async => debugPickedFile;
