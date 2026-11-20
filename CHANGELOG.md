# Changelog

All notable changes to this project are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and versions follow [Semantic Versioning](https://semver.org/).

## [0.1.0] - 2026-11-20

Initial release: issue in, signed pull request out. `foreman → planner → coder` runs end to end on Argo Workflows.

### Added

- First Argo workflow template ([#8](https://github.com/julie-ng/ai-native-sdlc-workflows/pull/8)).
- Trusted `foreman` step: creates the run and hands each agent step a scoped HMAC token ([#9](https://github.com/julie-ng/ai-native-sdlc-workflows/pull/9)).
- `initial-release` workflow: the planner uploads a plan, the coder implements it and opens a signed pull request; each step checks its result exists, because goose can exit successfully on model errors ([#10](https://github.com/julie-ng/ai-native-sdlc-workflows/pull/10)).
- GitHub tokens from the token broker: projected ServiceAccount token and repository annotation per agent pod; pull requests are opened by the GitHub App ([#12](https://github.com/julie-ng/ai-native-sdlc-workflows/pull/12)).
- `Makefile`: `make apply` and `make submit`, rejecting an incomplete registry name up front ([#14](https://github.com/julie-ng/ai-native-sdlc-workflows/pull/14)).

### Security

- Argo's mirrored credential mounts are removed from its helper container.

[0.1.0]: https://github.com/julie-ng/ai-native-sdlc-workflows/releases/tag/v0.1.0
