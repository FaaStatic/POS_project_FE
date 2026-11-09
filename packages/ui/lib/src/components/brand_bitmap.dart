import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_svg/flutter_svg.dart';

import '../../gen/assets.gen.dart';

/// The app mark drawn from its SVG as straight RGBA, [width] pixels wide. For callers that need pixels,
/// such as a thermal printer; the screen uses [BrandLogo]. Null when it cannot be rendered.
Future<({Uint8List rgba, int width, int height})?> brandMarkBitmap(int width) async {
  try {
    final info = await vg.loadPicture(SvgAssetLoader(Assets.brand.mark.path, packageName: Assets.package), null);
    final scale = width / info.size.width;
    final height = (info.size.height * scale).round();
    final recorder = ui.PictureRecorder();
    ui.Canvas(recorder)
      ..scale(scale)
      ..drawPicture(info.picture);
    final picture = recorder.endRecording();
    final image = await picture.toImage(width, height);
    final data = await image.toByteData();
    info.picture.dispose();
    picture.dispose();
    image.dispose();
    return data == null ? null : (rgba: data.buffer.asUint8List(), width: width, height: height);
  } catch (_) {
    return null;
  }
}
