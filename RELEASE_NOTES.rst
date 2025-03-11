Release notes
=============

Unreleased
----------

- Map Datacite v4 namespace to version 4.3 schema in METS XML schema import

0.46
----

- Update specifications to version 1.7.7.
- Add new PRONOM codes.
- Add support for Datacite 4.5 schema

Version 0.45
------------

- Add GPX schema to external catalog
- Update LIDO 1.1 licence

Version 0.44
------------

- Sort mimetypes alphabetically

Version 0.43
------------

- Add schematron checks for MODS versions older than 3.8

Version 0.42
------------

- Installation instructions for AlmaLinux 9 using RPM packages

Version 0.41
------------

- Update specifications to version 1.7.6.
- Add new schema versions for LIDO v1.1 and MODS v3.8.
- Add support for video/h265 (HEVC) files.
- Update the following mimetypes:

   - AAC files from audio/mp4 to audio/aac
   - AVC files from video/mp4 to video/h264.

Version 0.40
------------

- Add support for Apple M4A AAC files (do not require AudioMD for audio/mp4
  containers).
- Code cleanups.
- Version 0.40 is the same as 0.39 due to a tagging error.

Version 0.38
------------

- Add support for multi-image files.
- Add RHEL9 support.

Version 0.37
------------

- Fix DNG MIME type.

Version 0.36
------------

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

Version 0.35
------------

- Add support for ALTO 4.2 and 4.3.

Version 0.34
------------

- MIME types requiring AudioMD or MIX metadata is updated.
- Metadata specifications for bit-level preservation is updated to meet all
  three use cases listed in the specifications. Previously, only one of these
  cases were supported.
- Take care that file format specific metadata (e.g. AudioMD or MIX) is not
  required for the streams where the container file is marked for bit-level
  preservation.

Version 0.33
------------

- Fix schema and schematron files to support specifications 1.7.4.
- Add support for DataCite 4.4.
- Remove Schematron rules related to EN15744

Version 0.32
------------

- Make tests compatible with Python3

Version 0.31
------------

- Terminology change to fi-dpres.

Version 0.30
------------

- Update PRONOM codes for file formats.

Version 0.29
------------

- Fix schema and schematron files to support specifications 1.7.3.
- Update more accurate support between different specification versions
  in schematron.
- Add EAD3 1.1.1, DDI 3.3, EBUCORE 1.10, and Sähke2 2019.03 schema files.
- Change ingest report schema and schematron files to support updated event
  types described in interfaces specification 2.2.0.

Version 0.28
------------

- Build el8 rpms

Version 0.27
------------

- Allow known video container to have unknown streams when marked as a native
  file.

Version 0.26
------------

- Add normalization event type for native files.

Version 0.25
------------

- Licence update.

Version 0.24
------------

- Update METSRIGHTS schema.

Version 0.23
------------

- Update schema according to national specifications 1.7.2.
- HTML ingest report: Update stylesheet accessible, remove NDL logo, minor
  XSLT fixes.
