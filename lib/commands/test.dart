import "dart:async";

import "package:multipack/commands/common.dart";
import "package:multipack/package.dart";

class TestCommand extends PassthroughCommand {
  TestCommand(List<Package> packages)
      : super(
          "test",
          "Run tests.",
          packages,
        );

  @override
  FutureOr<int> runOnPackage(Package package) => package.test(
        argResults.arguments,
        nameWidth: nameWidth,
      );
}
