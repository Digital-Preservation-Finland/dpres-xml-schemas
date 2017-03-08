================
KDK-METS-SCHEMAS
================

This repository is currently used in `National Digital Library <http://www.kdk.fi/en/>`_ and `Open Science and Research Initiative <http://openscience.fi/frontpage>`_ for metadata validation in digital preservation services. Kdk-mets-schemas is a collection of XML schema catalog and schmematron files which together can be used to validate all metadata combined in METS document against the national specifications.

The current catalog version is 1.6.0. The same catalog can be used also with older specifications, starting from version 1.4.

-------------------

USAGE
-----

We have utilized xmllint commandline tool for XML schema validation.
Use the following commands to validate a METS document:

::

  export SGML_CATALOG_FILES=/<base path>/kdk_mets_catalog/catalog-local.xml
  xmllint --valid --huge --noout --catalogs --schema  ./kdk_mets_catalog/mets/mets.xsd <METS document>

For further information, see: http://xmlsoft.org/xmllint.html.

Schematron validation is done using xsltproc for XSLT conversions. EXSLT extensions are required, see http://xmlsoft.org/XSLT/EXSLT/. Additionally, Schematron XSLT conversion files are also required to make conversions, see the files in https://github.com/Schematron/schematron/tree/master/trunk/schematron/code. 

Use the following commands to compile schematron files:

::

  xsltproc -o tempfile1 iso_dsdl_include.xsl ./kdk_schematron/<schematron schema>.sch
  xsltproc -o tempfile2 iso_abstract_expand.xsl tempfile1
  xsltproc -o <new compiled xsl>.xsl iso_svrl_for_xslt1.xsl tempfile2

Use the following command to validate a METS document.

::

  xsltproc -o outputfile <new compiled xsl>.xsl <METS document>

If all steps return 0 and no "<svrl:failed-assert>" elements are produced to stdout, validation is succesful. These steps have to be repeated for all schematron schemas.

For further information, see: http://xmlsoft.org/XSLT/xsltproc2.html, http://www.schematron.com/ and http://exslt.org/


INCLUDED FILES
--------------
Paths related to schema catalog are described in relation to base path ./kdk_mets_catalog/

SCHEMA CATALOG:
+++++++++++++++

./catalog-local.xml
  KDK Schema Catalog for local purposes.

./catalog-web.xml
  KDK Schema Catalog for web purposes.

./catalog.dtd
  OASIS Catalog specification file (unchanged)

KDK EXTENSIONS TO CATALOG SCHEMAS:
++++++++++++++++++++++++++++++++++

./mets/mets.xsd
  KDK METS schema file (main schema)

./mets/kdk-mets-extensions.xsd
  KDK extension file for KDK METS schema

./w3/xlink.xsd
  Xlink patch file for KDK Schema Catalog

./mods/mods.xsd
  MODS patch file for KDK Schema Catalog

./textmd/textmd_kdk.xsd
  For historical purposes related to KDK specification 1.4

CATALOG SCHEMAS:
++++++++++++++++

./addml
  ADDML 8.3 schema files (unchanged)

./avmd
  AudioMD 2.0 and VideoMD 2.0 schema files (unchanged)

./dc
  Dublin Core 1.1 schema files (unchanged)

./ddi-codebook/2.5
  DDI Codebook 2.5.1/2.5 schema files (unchanged)

./ddi-codebook/2.1
  DDI Codebook 2.1 schema files (unchanged)

./ddi-lifecycle/3.2
  DDI Lifecycle 3.2 schema files (unchanged)

./ddi-lifecycle/3.1
  DDI Lifecycle 3.1 schema files (unchanged)

./eac
  EAC-CPF 2010 schema files (unchanged)

./ead
  EAD 2002 schema files (unchanged)

./ead3
  EAD3 1.0.0 schema files (changed, see ./ead3/readme.txt)

./gml
  OpenGIS GML 3.1.1 schema files (changed, see ./gml/readme.txt)

./lido
  LIDO 1.0 schema files (changed, see ./lido/readme.txt)

./marc
  MARC21 1.2 schema files (unchanged)

./mets
  METS 1.11 schema files (extended with separate files)

./mix
  MIX 2.0 (NISOIMG) schema files (unchanged)                    

./mods
  MODS 3.6 schema files (extended with separate file)

./premis
  PREMIS 2.3 schema files (unchanged)

./textmd
  TextMD 3.01a schema files (unchanged)

./vra
  VRA Core 4.0 schema files (unchanged)

./w3
  W3 schema files (extended with separate file)

SCHEMATRON:
+++++++++++

Paths related to schematron are described in relation to base path ./kdk_schematron/.

./abstracts/*
  Abstract patterns used by schematron schemas

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
All contribution is welcome. We can provide more information through our email address pas-support (ät) csc.fi on issues related to this repository. Pull requests are handled according our schedule by our specialists and we aim to be fairly active on this. Most on the development takes place in `CSC - IT Center for Science <www.csc.fi>`_. 
