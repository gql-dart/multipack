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
-s, --skip    Blacklist packages for this command.

Available commands:
  analyze   Run analyzer.
  exec      Execute any command.
  fmt       Run formatter.
  pub       Run pub.
  pubspec   Update pubspec.yaml.
  test      Run tests.
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

### Filtering

`multipack` always recursively discovers all the packages from the current working directory
 to build a local dependency graph.
 
 By default, `multipack` works in all the discovered packages, but that can be changed
 by using global options. 

```bash
# only work in packages changed since `master`
multipack --since master pub --version 

# only work in packages `a`, `b` and `c`
multipack --only a,b,c fmt --version

# work in all discovered packages except `a`
multipack --skip a fmt --version
```


## Design goals

Make development and management of [`gql-dart/gql`](https://github.com/gql-dart/gql) easier.

That implies the following properties:

- knows about Dart and Flutter (in that order) tooling
- knows about git
- fine-tuned for use in GitHub Actions
- packages follow a common "template"

### Future plans

```bash
# status of required tools
multipack doctor

# list packages and their names (may include more meta data)
multipack info
multipack info --format json
multipack info --format html
multipack info --format gviz

# temporarily checkout a different branch to get versions to compare to current version
multipack info --checkout stable --format json --output-file stable-info.json

# bump versions
multipack version bump patch
multipack version bump minor
multipack version bump major
multipack version bump breaking
multipack version bump pre --name alpha --with-timestamp

multipack version set 1.2.3-gamma.0+456789

multipack version --verify changelog

# link local packages
multipack dependencies link

# unlink local packages
multipack dependencies unlink

# find missing, under-promoted, over-promoted, and unused dependencies
multipack dependencies validate

# verify that local packages fall within other package dependency constraints
multipack dependencies validate-versions

# synchronize local package dependency versions
multipack dependencies sync-versions

# create new package (`gql_local_state_link`@`0.1.0`) in `./links/` from template (`gql_link`)
multipack create gql_link gql_local_state_link --version 0.1.0 --in ./links/

# Possibly hide flutter/dart differences for test and build
multipack test
multipack test --coverage
multipack build
multipack pubspec clean
```

### `singlepack`

Most of the commands also make sense in a single package context.


## Other interesting tools:

- https://pub.dev/packages/pubviz
- https://pub.dev/packages/gpm
- https://pub.dev/packages/pubspec_version
- https://pub.dev/packages/grinder
- https://pub.dev/packages/fvm
- https://pub.dev/packages/shared_versions
- https://pub.dev/packages/dpm
- https://pub.dev/packages/mono_repo
- https://pub.dev/packages/tuneup
- https://pub.dev/packages/test_coverage
- https://pub.dev/packages/dependency_validator
- https://pub.dev/packages/pkgraph
- https://pub.dev/packages/dart_dev
