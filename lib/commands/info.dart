import "dart:async";
import "dart:math";

import "package:args/command_runner.dart";

import "package:multipack/package.dart";

String toHex(int color) {
  final colorString = color.toRadixString(16);

  return [if (colorString.length == 1) "0", colorString].join();
}

String getColor(String name) {
  final random = Random(name.hashCode);

  final r = random.nextInt(256);
  final g = random.nextInt(256);
  final b = random.nextInt(256);

  return [
    "#",
    toHex(r),
    toHex(g),
    toHex(b),
  ].join();
}

class InfoCommand extends Command<void> {
  @override
  final String name = "info";

  @override
  final String description = "Show info about local packages.";

  final List<Package> packages;

  InfoCommand(this.packages);

  @override
  FutureOr<void> run() {
    print("digraph packages {");
    print('  size="10"; ratio=fill;');

    for (final package in packages) {
      print(
          '  ${package.name} [shape="box"; color="${getColor(package.name)}"];');
    }

    for (final package in packages) {
      package.pubspec.allDependencies.keys
          .where((dep) => packages.any((package) => package.name == dep))
          .forEach((dep) {
        final attrs = package.pubspec.dependencies.containsKey(dep)
            ? 'style="filled"; color="${getColor(dep)}"'
            : 'style="dashed"; color="${getColor(dep)}"';
        print("  ${package.name} -> ${dep} [${attrs}];");
      });
    }

    final groupedPackages =
        packages.fold<Map<String, List<Package>>>({}, (grouped, package) {
      if (!grouped.containsKey(package.namespace)) {
        grouped[package.namespace] = [];
      }

      grouped[package.namespace].add(package);

      return grouped;
    });

    groupedPackages.forEach((namespace, packagesInGroup) {
      print('  subgraph "cluster ${namespace}" {');
      print('    label="${namespace}";');
      print('    color="${getColor(namespace)}";');
      packagesInGroup.forEach((package) {
        print("    ${package.name};");
      });
      print("  }");
    });

    print("}");
  }
}
