/// Non-web builds (tests) have no browser download; the call is recorded instead.
final savedFiles = <String>[];

void saveFile(List<int> bytes, String name, {String mime = 'application/pdf'}) => savedFiles.add(name);

final openedUrls = <String>[];

void openInNewTab(String url) => openedUrls.add(url);
