### `multipack`

A tool for monorepo management. Link local packages and execute commands in topological order.

[![MIT License][license-badge]][license-link]
[![PRs Welcome][prs-badge]][prs-link]
[![Watch on GitHub][github-watch-badge]][github-watch-link]
[![Star on GitHub][github-star-badge]][github-star-link]
[![Watch on GitHub][github-forks-badge]][github-forks-link]
[![Discord][discord-badge]][discord-link]

[license-badge]: https://img.shields.io/github/license/gql-dart/multipack.svg?style=for-the-badge
[license-link]: https://github.com/gql-dart/multipack/blob/master/LICENSE
[prs-badge]: https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=for-the-badge
[prs-link]: https://github.com/gql-dart/multipack/issues

[github-watch-badge]: https://img.shields.io/github/watchers/gql-dart/multipack.svg?style=for-the-badge&logo=github&logoColor=ffffff
[github-watch-link]: https://github.com/gql-dart/multipack/watchers
[github-star-badge]: https://img.shields.io/github/stars/gql-dart/multipack.svg?style=for-the-badge&logo=github&logoColor=ffffff
[github-star-link]: https://github.com/gql-dart/multipack/stargazers
[github-forks-badge]: https://img.shields.io/github/forks/gql-dart/multipack.svg?style=for-the-badge&logo=github&logoColor=ffffff
[github-forks-link]: https://github.com/gql-dart/multipack/network/members

[discord-badge]: https://img.shields.io/discord/559455668810153989.svg?style=for-the-badge&logo=discord&logoColor=ffffff
[discord-link]: https://discord.gg/NryjpVa


This repo comes with an unpublished tool called `multipack`. To activate it run the following command.
```bash
pub global activate multipack
```

`multipack` provides a simple way of running commands in multiple packages at once. It builds a directed graph of packages
to run commands in topological order.
```text
Manage monorepo.

Usage: multipack <command> [arguments]

Global options:
-h, --help    Print this usage information.
-o, --only    Whitelist packages, skipping those not included for this command.
              [multipack (default)]
-s, --skip    Blacklist packages for this command.
              [multipack]

Available commands:
  analyze   Run analyzer.
  exec      Execute any command.
  fmt       Run formatter.
  pub       Run pub.
  pubspec   Update pubspec.yaml
``` 

`pubspec` has 3 subcommands:
```text
Available subcommands:
  bump-alpha      Bumps versions for alpha release.
  clean           cleans dependency overrides
  hard_override   overrides dependencies for local packages
  override        overrides dependencies for local packages
  sync-versions   Synchronizes dependency versions
```

Link all local packages by running
```bash
multipack pubspec override
```

Get all packages by running
```bash
multipack pub get
```

Clean up the pubspec file before publishing
```bash
multipack pubspec clean
```

## Design goals

Make development and management of [`gql-dart/gql`](https://github.com/gql-dart/gql) easier.

That implies the following properties:

- knows about Dart and Flutter (in that order) tooling
- knows about git
- fine-tuned for use in GitHub Actions
- packages follow a common "template"


## Other interesting tools:

- https://pub.dev/packages/pubviz
- https://pub.dev/packages/gpm
- https://pub.dev/packages/pubspec_version
- https://pub.dev/packages/grinder
- https://pub.dev/packages/fvm
- https://pub.dev/packages/shared_versions
- https://pub.dev/packages/dpm
- https://pub.dev/packages/mono_repo
