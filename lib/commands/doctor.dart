import "dart:async";
import "dart:io" as io;

import "package:args/command_runner.dart";

import "package:process_run/which.dart";
import "package:process_run/process_run.dart" as process_run;

class DoctorCommand extends Command<void> {
  @override
  final String name = "doctor";

  @override
  final String description = "Show information about the installed tooling.";

  DoctorCommand();

  @override
  FutureOr<void> run() async {
    final tools = <String, String>{
      "flutter": whichSync("flutter"),
      "dart": whichSync("dart"),
      "pub": whichSync("pub"),
      "dartanalyzer": whichSync("dartanalyzer"),
      "dartfmt": whichSync("dartfmt"),
      "git": whichSync("git"),
      "zzz": whichSync("zzz"),
    };

    for (final tool in tools.entries) {
      if (tool.value == null) {
        print(":( --> ${tool.key}");
        continue;
      }
      print(":) --> ${tool.key}");
      await process_run.run(
        tool.value,
        ["--version"],
        stdout: io.stdout,
        stderr: io.stderr,
      );
    }
  }
}
