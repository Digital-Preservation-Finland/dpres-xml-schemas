KDK METS Schema Catalog and Schematron Rules
============================================

This repository is currently used in `National Digital Library <http://www.kdk.fi/en/>`_ and `Open Science and Research Initiative <http://openscience.fi/frontpage>`_ for metadata validation in digital preservation services. Kdk-mets-schemas is a collection of XML schema catalog and schmematron files which together can be used to validate all metadata combined in METS document against the national specifications.

The current catalog version is 1.6.0. The same catalog can be used also with older specifications, starting from version 1.4.

USAGE
-----

We have utilized xmllint commandline tool for XML schema validation.
Use the following commands to validate a METS document:

::

  export SGML_CATALOG_FILES=/<base path>/schema_catalogs/catalog_main.xml
  xmllint --valid --huge --noout --catalogs --schema  ./schema_catalogs/mets/mets.xsd <METS document>

For further information, see: http://xmlsoft.org/xmllint.html.

Schematron validation is done using xsltproc for XSLT conversions.

Use the following commands to compile schematron files:

::

  xsltproc -o tempfile1 ./schematron/iso_schematron_xslt1/iso_dsdl_include.xsl ./schematron/<schematron schema>.sch
  xsltproc -o tempfile2 ./schematron/iso_schematron_xslt1/iso_abstract_expand.xsl tempfile1
  xsltproc -o <new compiled xsl>.xsl ./schematron/iso_schematron_xslt1/iso_svrl_for_xslt1.xsl tempfile2

Use the following command to validate a METS document.

::

  xsltproc -o outputfile <new compiled xsl>.xsl <METS document>

If all steps return 0 and no "<svrl:failed-assert>" elements are produced to output, validation is succesful. These steps have to be repeated for all schematron schemas.

For further information, see: http://xmlsoft.org/XSLT/xsltproc2.html, http://www.schematron.com/, and http://exslt.org/


INCLUDED FILES
--------------

SCHEMA CATALOG:
+++++++++++++++

Paths are described in relation to base path ./schema_catalogs/

./catalog_main.xml
  Main catalog for METS document validation.

./catalog_external.xml
  Catalog for external schemas.

./catalog.dtd
  OASIS Catalog specification file (unchanged)

MODIFICATIONS TO SCHEMAS:
+++++++++++++++++++++++++

Paths are described in relation to base path ./schema_catalogs/schemas/

./mets/mets.xsd
  Schema file importing METS and it's national extensions (main schema)

./mets/kdk-mets-extensions.xsd
  National METS extensions

./mods/mods.xsd
  MODS patch file for compatibility

./textmd/textmd_kdk.xsd
  For historical purposes related to KDK specifications v. 1.4

./w3/xlink.xsd
  Xlink patch file for the schema catalog


SCHEMAS:
++++++++

Paths are described in relation to base path ./schema_catalogs/schemas_external/

./addml
  ADDML schema files

./alto
  ALTO schema files

./avmd
  AudioMD and VideoMD schema files

./dc
  Dublin Core schema files

./ddi-codebook
  DDI Codebook schema files

./ddi-lifecycle
  DDI Lifecycle schema files

./eac
  EAC-CPF schema files

./ead
  EAD schema files

./ead3
  EAD3 schema files (changed, see ./ead3/README)

./lido
  LIDO schema files

./mads
  MADS schema files

./marc
  MARC21 schema files

./mets
  METS schema files

./metsrights
  METSRIGHTS schema files

./mix
  NISOIMG (MIX) schema files                

./mods
  MODS schema files

./opengis.gml
  OpenGIS GML schema files

./premis
  PREMIS schema files

./sahke2
  SAHKE2 schema files

./shared
  W3 schema files

./textmd
  TextMD schema files

./vra
  VRA Core schema files


SCHEMATRON:
+++++++++++

Paths related to schematron are described in relation to base path ./schematron/

./abstracts/*
  Abstract patterns used by schematron schemas

./iso_schematron_xslt1/*
  XSLT files for Schematron conversions

./mets_addml.sch
  Schematron schema for ADDML

./mets_avmd.sch
  Schematron schema for AudioMD and VideoMD

./mets_ead3.sch
  Schematron schema for EAD3

./mets_internal.sch
  Schematron schema for METS internal checks

./mets_mdtype.sch
  Schematron schema for metadata wrapping in METS

./mets_mix.sch
  Schematron schema for MIX

./mets_mods.sch
  Schematron schema for MODS

./mets_premis.sch
  Schematron schema for PREMIS

CONTRIBUTION
------------
All contribution is welcome. Pull requests are handled according our schedule by our specialists and we aim to be fairly active on this. Most on the development takes place in `CSC - IT Center for Science <www.csc.fi>`_. 
