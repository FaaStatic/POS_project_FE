import 'dart:io';

/// Fails when line coverage of domain, data, or presentation/bloc layers in
/// ./coverage/lcov.info is under the threshold. Generated code is excluded.
void main(List<String> args) {
  const threshold = 80.0;
  final file = File('coverage/lcov.info');
  if (!file.existsSync()) {
    stdout.writeln('No coverage/lcov.info in ${Directory.current.path}, skipping.');
    return;
  }
  final layer = RegExp(r'/(domain|data|presentation/bloc)/');
  final generated = RegExp(r'\.(g|freezed)\.dart$');
  var hit = 0, total = 0;
  var counted = false;
  for (final line in file.readAsLinesSync()) {
    if (line.startsWith('SF:')) {
      final path = line.substring(3);
      counted = layer.hasMatch(path) && !generated.hasMatch(path);
    } else if (counted && line.startsWith('DA:')) {
      total++;
      if (int.parse(line.split(',')[1]) > 0) hit++;
    }
  }
  if (total == 0) {
    stdout.writeln('No domain/data/bloc lines in ${Directory.current.path}.');
    return;
  }
  final pct = hit * 100 / total;
  stdout.writeln('Layer coverage ${pct.toStringAsFixed(1)}% ($hit/$total) in ${Directory.current.path}');
  if (pct < threshold) {
    stderr.writeln('Below ${threshold.toStringAsFixed(0)}% threshold.');
    exit(1);
  }
}
