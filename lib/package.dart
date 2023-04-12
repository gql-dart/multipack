@experimental
library package;

import "dart:io";

import "package:ansicolor/ansicolor.dart";
import 'package:collection/collection.dart';
import "package:directed_graph/directed_graph.dart";
import "package:meta/meta.dart";
import "package:pubspec/pubspec.dart";

final mpPen = AnsiPen()
  ..xterm(89, bg: true)
  ..white(bold: true);
final multipack = mpPen.write(" multipack ");

final packPen = AnsiPen()
  ..xterm(241, bg: true)
  ..white(bold: true);

final commandPen = AnsiPen()
  ..xterm(166, bg: true)
  ..white(bold: true);

final successPen = AnsiPen()
  ..xterm(22, bg: true)
  ..white(bold: true);

final failurePen = AnsiPen()
  ..xterm(124, bg: true)
  ..white(bold: true);

class Package {
  final Directory directory;
  final String namespace;
  final String name;
  final PubSpec pubspec;
  final bool isFlutter;

  const Package({
    required this.directory,
    required this.namespace,
    required this.name,
    required this.pubspec,
    required this.isFlutter,
  });

  Future<bool> hasChangedSince(String? since) async {
    if (since == null) return true;

    final process = await Process.start(
      "git",
      ["diff", "--exit-code", "--name-only", since, "."],
      workingDirectory: directory.path,
    );

    return await process.exitCode != 0;
  }

  Future<int> run(
    String executable,
    List<String> arguments, {
    int nameWidth = 0,
  }) async {
    final packName = packPen.write(
      " ${name.padRight(nameWidth)} ",
    );

    final cmd = [executable, ...arguments].join(" ");
    final command = commandPen.write(
      " ${cmd.padRight(nameWidth)} ",
    );

    print("$multipack$packName");
    print("$multipack$command");

    final process = await Process.start(
      executable,
      arguments,
      workingDirectory: directory.path,
    );

    process.stdout.listen((data) => stdout.add(data));
    process.stderr.listen((data) => stderr.add(data));

    final exitCode = await process.exitCode;

    final status = exitCode == 0
        ? successPen.write(" success ".padRight(nameWidth + 2))
        : failurePen.write(" failure $exitCode ".padRight(nameWidth + 2));

    print("$multipack$status");

    print("");

    return exitCode;
  }

  Future<int> pub(
    List<String> args, {
    int nameWidth = 0,
  }) {
    final executable = isFlutter ? "flutter" : "dart";
    final arguments = ["pub", ...args];

    return run(
      executable,
      arguments,
      nameWidth: nameWidth,
    );
  }

  Future<int> fmt(
    List<String> args, {
    int nameWidth = 0,
  }) {
    final executable = isFlutter ? "flutter" : "dart";
    final arguments = isFlutter ? ["format", ...args] : args;

    return run(
      executable,
      arguments,
      nameWidth: nameWidth,
    );
  }

  Future<int> analyze(
    List<String> args, {
    int nameWidth = 0,
  }) {
    final executable = isFlutter ? "flutter" : "dart";
    final arguments = ["format", ...args];

    return run(
      executable,
      arguments,
      nameWidth: nameWidth,
    );
  }

  Future<int> test(
    List<String> args, {
    int nameWidth = 0,
  }) {
    final executable = isFlutter ? "flutter" : "dart";

    final arguments = isFlutter ? ["test", ...args] : ["test", ...args];

    return run(
      executable,
      arguments,
      nameWidth: nameWidth,
    );
  }

  @override
  String toString() => name;
}

Stream<Package> findPackages(Directory root) =>
    findPackageDirectories(root).asyncMap(
      (dir) async {
        final pubspec = await PubSpec.load(dir);

        final dirPath = dir.path;
        final rootPath = root.path;

        final rootIndex = rootPath.length;
        final dirIndex = dirPath.lastIndexOf(Platform.pathSeparator);

        return Package(
          directory: dir,
          namespace: dirPath.substring(
            rootIndex == dirIndex ? rootIndex : rootIndex + 1,
            dirIndex,
          ),
          name: pubspec.name!,
          isFlutter: pubspec.allDependencies.containsKey("flutter"),
          pubspec: pubspec,
        );
      },
    );

Stream<Directory> findPackageDirectories(Directory root) => root
    .list(recursive: true)
    .where(
      (entity) =>
          entity is File &&
          entity.path.endsWith("${Platform.pathSeparator}pubspec.yaml"),
    )
    .cast<File>()
    .map(
      (pubspec) => pubspec.parent.absolute,
    );

Future<DirectedGraph<Package>> getPackageGraph(Directory root) async {
  final vertices = await findPackages(root).toList();

  return DirectedGraph<Package>(
    {
      for (var vertex in vertices)
        vertex: vertex.pubspec.allDependencies.keys
            .map(
              (dep) => vertices.firstWhereOrNull(
                (v) => v.name == dep,
              ),
            )
            .whereNotNull()
            .toSet(),
    },
    comparator: (
      vertex1,
      vertex2,
    ) =>
        vertex1.name.compareTo(vertex2.name),
  );
}
