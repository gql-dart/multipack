import "dart:async";

import 'package:collection/collection.dart';
import "package:multipack/commands/common.dart";
import "package:multipack/package.dart";
import "package:path/path.dart" as path;
import "package:pubspec/pubspec.dart";

class HardOverrideCommand extends MultipackCommand {
  HardOverrideCommand(
    List<Package> packages,
  ) : super(
          "hard_override",
          "overrides dependencies for local packages",
          packages,
        );

  @override
  FutureOr<int> runOnPackage(Package package) async {
    try {
      MapEntry<String, DependencyReference> map(
        String key,
        DependencyReference ref,
      ) {
        if (ref is! HostedReference) return MapEntry(key, ref);

        final localPackage = packages.firstWhereOrNull(
          (package) => package.name == key,
        );

        if (localPackage == null) return MapEntry(key, ref);

        return MapEntry(
          key,
          PathReference(
            path.relative(
              localPackage.directory.path,
              from: package.directory.path,
            ),
          ),
        );
      }

      await package.pubspec
          .copy(
            dependencies: package.pubspec.dependencies.map(map),
            devDependencies: package.pubspec.devDependencies.map(map),
          )
          .save(package.directory);

      return 0;
    } catch (e) {
      return 1;
    }
  }
}
