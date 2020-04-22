# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Added `Prependers.setup_for_rails` helper for Rails integration
- Added support for Rails 6 and Zeitwerk 

## [0.2.0] - 2019-07-09

### Added

- `ClassMethods` is now automagically prepended to the singleton class ([#5](https://github.com/nebulab/prependers/pull/5))

## [0.1.1] - 2019-06-21

### Fixed

- Prependers are now always loaded in alphabetical order ([#3](https://github.com/nebulab/prependers/pull/3))

## [0.1.0] - 2019-06-21

Initial release.

[Unreleased]: https://github.com/nebulab/prependers/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/nebulab/prependers/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/nebulab/prependers/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/nebulab/prependers/releases/tag/v0.1.0
