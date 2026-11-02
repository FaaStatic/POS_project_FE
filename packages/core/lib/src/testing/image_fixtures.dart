import 'dart:convert';
import 'dart:typed_data';

/// Real WebP files from cwebp (gradients, no production data). The header sizes were confirmed with
/// webpinfo. Shared by the CMS, cashier, and core tests; `ui` keeps its own copy because it cannot import core.
const square64Base64 =
    'UklGRvIAAABXRUJQVlA4IOYAAADQCACdASpAAEAAPrVYo0w/sqMiLB1YA/AWiWIzgX//WDE8sJnBreoNEox3ve7+5jV8cMxfTNaTZyWbtfk8p7aAcAsRP/9hIR2PExdH/6QAAP76Ff0f86ftP+q3kuqg/MIxGa5mS9jastmdbk+xYAcFFVOYFBMRkaWko3SvRPBbgoMsN/yGPArIR2CWfpFWN6TSIKBTelzHsMJNk/gXHwFIylib5cAQluRvIeDX9+SX/LzndUiOXnQSEFNYyuzQQOWSh/XavLZkBMeyL+LG/lEDwlYhJogaiX63E1FuI74GpB1gxKAAAA==';

const wide100x60Base64 =
    'UklGRgwBAABXRUJQVlA4IAABAAAwCQCdASpkADwAPrFGnEm/v6KiNbKOM/AWCUZwL//rBieqMBqRY5sHHiZQKnpCuNXkOlH+JRctFYCp9Xa3+R6RAJ1dtf5HqGUiqUrd8vseD+wQAP72e6L1427/bKZcW9wurhekZe1JPseDxsJHw3Wrx8OqYMvGQXT3uAHNSTNwfaq4aFNoQBp4OmaEmll7ZsN6PeI3VuHUcpq5UcHRG1ANItghFu3ajfx5rG2Z/g/n6EA1/1DL94K1gg1seoUDjrKzA2hAGne/Oo1mY+P5gVu53H00Ayy+J/NujVLpaSn7ET4kqHQxJYrOZJa3Xj1IWZ9B9BWIpnPEQa7kK4WX9PAA';

final square64 = base64Decode(square64Base64);
final wide100x60 = base64Decode(wide100x60Base64);

/// A 64x64 WebP followed by padding up to [length] bytes: the header stays valid, so only size can fail.
Uint8List squareWebpOfSize(int length) => Uint8List(length)..setRange(0, square64.length, square64);

/// The first bytes of a PNG, enough for a file named .png that is not a WebP.
final pngBytes = Uint8List.fromList([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, ...List.filled(40, 0)]);
