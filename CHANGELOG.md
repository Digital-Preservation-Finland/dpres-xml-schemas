# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.2] - 2025-09-24
### Fixed
 - Fix filesec's conversion's source and outcome assignment logic for USE="fi-dpres-ignore-validation-errors" case

## [1.0.1] - 2025-08-27
### Fixed
 - Exclude external schemas from sonarqube scans.

## [1.0.0] - 2025-05-27
### Added
 - Add support for mets:file USE="fi-dpres-ignore-validation-errors" case

### Changed
 - Moved the project to use Keep a Changelog format and Semantic Versioning

## [0.48]

- Add support for WebP files

## [0.47]

- Map DataCite v4 namespace to version 4.3 schema in METS XML schema import

## [0.46]

- Update specifications to version 1.7.7.
- Add new PRONOM codes.
- Add support for Datacite 4.5 schema

## [0.45]

- Add GPX schema to external catalog
- Update LIDO 1.1 licence

## [0.44]

- Sort mimetypes alphabetically

## [0.43]

- Add schematron checks for MODS versions older than 3.8

## [0.42]

- Installation instructions for AlmaLinux 9 using RPM packages

## [0.41]

- Update specifications to version 1.7.6.
- Add new schema versions for LIDO v1.1 and MODS v3.8.
- Add support for video/h265 (HEVC) files.
- Update the following mimetypes:

   - AAC files from audio/mp4 to audio/aac
   - AVC files from video/mp4 to video/h264.

## [0.40]

- Add support for Apple M4A AAC files (do not require AudioMD for audio/mp4
  containers).
- Code cleanups.
- Version 0.40 is the same as 0.39 due to a tagging error.

## [0.38]

- Add support for multi-image files.
- Add RHEL9 support.

## [0.37]

- Fix DNG MIME type.

## [0.36]

- Update schema and schematron files to support specifications 1.7.5.
- Add support for EAC-CPF 2.0 metadata format and fix minor bugs related to
  EAC-CPF checks (disallowing to use EAC format e.g. as provenance metadata).
- Update pronom codes of supported file formats. The codes were updated for
  the following formats: IFC, DNG, GEOPACKAGE, KML, SIARD
- The rules for checking that MDTYPE and the contained namespace match were
  previously coded differently for different specification versions. This is
  now simplified and done in the same way regardless of the specification
  version. The supported values for MDTYPE and MDTYPEVERSION have still been
  kept as specification dependent.
- There was a bug in catalog version 1.5.0 with handling rightsStatement
  element in PREMIS metadata. This bug was kept only for that version to keep
  backwards compatibility. Since it is against the official PREMIS
  specification and (according to our knowledge) not used by anyone, the
  exceptional handling for catalog version 1.5.0. is now removed.

## [0.35]

- Add support for ALTO 4.2 and 4.3.

## [0.34]

- MIME types requiring AudioMD or MIX metadata is updated.
- Metadata specifications for bit-level preservation is updated to meet all
  three use cases listed in the specifications. Previously, only one of these
  cases were supported.
- Take care that file format specific metadata (e.g. AudioMD or MIX) is not
  required for the streams where the container file is marked for bit-level
  preservation.

## [0.33]

- Fix schema and schematron files to support specifications 1.7.4.
- Add support for DataCite 4.4.
- Remove Schematron rules related to EN15744

## [0.32]

- Make tests compatible with Python3

## [0.31]

- Terminology change to fi-dpres.

## [0.30]

- Update PRONOM codes for file formats.

## [0.29]

- Fix schema and schematron files to support specifications 1.7.3.
- Update more accurate support between different specification versions
  in schematron.
- Add EAD3 1.1.1, DDI 3.3, EBUCORE 1.10, and Sähke2 2019.03 schema files.
- Change ingest report schema and schematron files to support updated event
  types described in interfaces specification 2.2.0.

## [0.28]

- Build el8 rpms

## [0.27]

- Allow known video container to have unknown streams when marked as a native
  file.

## [0.26]

- Add normalization event type for native files.

## [0.25]

- Licence update.

## [0.24]

- Update METSRIGHTS schema.

## [0.23]

- Update schema according to national specifications 1.7.2.
- HTML ingest report: Update stylesheet accessible, remove NDL logo, minor
  XSLT fixes.

[Unreleased]: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas/compare/v0.48...v1.0.0
[0.48]: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas/compare/v0.47...v0.48
[0.47]: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas/compare/v0.46...v0.47
[0.46]: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas/compare/v0.45...v0.46
[0.45]: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas/compare/v0.44...v0.45
[0.44]: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas/compare/v0.43...v0.44
[0.43]: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas/compare/v0.42...v0.43
[0.42]: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas/compare/v0.41...v0.42
[0.41]: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas/compare/v0.40...v0.41
[0.40]: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas/compare/v0.39...v0.40
[0.39]: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas/compare/v0.38...v0.39
[0.38]: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas/compare/v0.37...v0.38
[0.37]: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas/compare/v0.36...v0.37
[0.36]: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas/compare/v0.35...v0.36
[0.35]: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas/compare/v0.34...v0.35
[0.34]: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas/compare/v0.33...v0.34
[0.33]: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas/compare/v0.32...v0.33
[0.32]: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas/compare/v0.31...v0.32
[0.31]: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas/compare/v0.30...v0.31
[0.30]: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas/compare/v0.29...v0.30
[0.29]: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas/compare/v0.28...v0.29
[0.28]: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas/compare/v0.27...v0.28
[0.27]: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas/compare/v0.26...v0.27
[0.26]: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas/compare/v0.25...v0.26
[0.25]: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas/compare/v0.24...v0.25
[0.24]: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas/compare/v0.23...v0.24
[0.23]: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas/compare/v0.22...v0.23
