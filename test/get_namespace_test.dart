import "dart:io";
import "package:test/test.dart";
import "package:multipack/package.dart";

void main() {
  // group("get namespace", () {
  test("pubspec just in root", () {
    const String rootPath = "/root";
    const String dirPath = "/root";

    const rootIndex = rootPath.length;
    final int dirIndex = dirPath.lastIndexOf(Platform.pathSeparator);
    expect(getNamespace(dirPath, rootIndex, dirIndex), "");
  });

  // To keep it As before
  test("pubspec in subdir of root", () {
    const String rootPath = "/root";
    const String dirPath = "/root/dir1";

    const int rootIndex = rootPath.length;
    final int dirIndex = dirPath.lastIndexOf(Platform.pathSeparator);
    expect(getNamespace(dirPath, rootIndex, dirIndex), "");
  });

  // To keep it As before
  test("pubspec in Sun of fold", () {
    const String rootPath = "/root";
    const String dirPath = "/root/dir1/dir2";

    const int rootIndex = rootPath.length;
    final int dirIndex = dirPath.lastIndexOf(Platform.pathSeparator);
    expect(getNamespace(dirPath, rootIndex, dirIndex), "dir1");
  });
  // });
}
