import "dart:io";

import "package:args/command_runner.dart";
import "package:directed_graph/directed_graph.dart";
import "package:multipack/commands.dart";
import "package:multipack/package.dart";

void main(List<String> arguments) async {
  final DirectedGraph<Package> dependencyGraph =
      await getPackageGraph(Directory.current);
  final List<Package> orderedPackages = getOrderdPackages(dependencyGraph);

  final packageNames = orderedPackages
      .map(
        (package) => package.name,
      )
      .toList();

  final runner = CommandRunner<void>(
    "multipack",
    "Manage monorepo.",
  );

  runner.argParser.addOption(
    "since",
    abbr: "d",
    help: "Consider only the changed packages.",
    valueHelp: "commit",
  );

  runner.argParser.addMultiOption(
    "only",
    abbr: "o",
    help: "Whitelist packages, skipping those not included for this command.",
    defaultsTo: packageNames,
    allowed: packageNames,
  );

  runner.argParser.addMultiOption(
    "skip",
    abbr: "s",
    help: "Blacklist packages for this command.",
    defaultsTo: [],
    allowed: packageNames,
  );

  runner.addCommand(PubCommand(orderedPackages));
  runner.addCommand(FmtCommand(orderedPackages));
  runner.addCommand(InfoCommand(orderedPackages));
  runner.addCommand(AnalyzeCommand(orderedPackages));
  runner.addCommand(ExecCommand(orderedPackages));
  runner.addCommand(PubspecCommand(orderedPackages));
  runner.addCommand(TestCommand(orderedPackages));

  await runner.run(arguments);
}

List<Package> getOrderdPackages(DirectedGraph<Package> dependencyGraph) {
  final List<Package> packages =
      dependencyGraph.edgeMap.keys.map((vertex) => vertex.data).toList();
  final topologicalOrdering = dependencyGraph.sortedTopologicalOrdering.reversed
      .map((vertex) => vertex.data)
      .toList();
  final freeDependentPackages =
      packages.toSet().difference(topologicalOrdering.toSet());
  final orderedPackages = [...topologicalOrdering, ...freeDependentPackages];
  return orderedPackages;
}
