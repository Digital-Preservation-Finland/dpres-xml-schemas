Schema Catalogs and Schematron Rules
====================================

This repository is currently used for XML validation in Finnish national digital
preservation services. The dpres-xml-schemas is a collection of XML schema
catalogs and schmematron files which together can be used to validate all metadata
included in METS document against the national specifications. The catalog can
be used also for validating XML formatted digital objects.

The current METS catalog version is 1.7.6.
The same catalog can be used also with older specifications, starting from version 1.5.0.

For further information about specifications, see: http://digitalpreservation.fi/

Requirements
------------

The software is tested with Python 3.9 on AlmaLinux 9 release.

Installation using RPM packages (preferred)
-------------------------------------------

Installation on Linux distributions is done by using the RPM Package Manager.
See how to `configure the PAS-jakelu RPM repositories`_ to setup necessary software sources.

.. _configure the PAS-jakelu RPM repositories: https://www.digitalpreservation.fi/user_guide/installation_of_tools 

After the repository has been added, the package can be installed by running the following command::

    sudo dnf install dpres-xml-schemas


Installation for development purposes
-------------------------------------

Installation and usage requires additional software:

        * GNU Make
        * libxml2 & libxslt / xmllint & xsltproc ( with exslt extension )
        * Schematron conversion scripts: https://github.com/Digital-Preservation-Finland/iso-schematron-xslt1.git

Install with commands::

        make install
        /usr/bin/xmlcatalog --noout --add "nextCatalog" "catalog" "/etc/xml/dpres-xml-schemas/schema_catalogs/catalog_main.xml" /etc/xml/catalog

We have utilized xmllint commandline tool for XML schema validation and xsltproc for XSLT conversions.
For further information, see: http://xmlsoft.org/xmllint.html, http://xmlsoft.org/XSLT/xsltproc2.html, and http://xmlsoft.org/XSLT/EXSLT/index.html

Usage
-----

Use the following command to validate a METS document::

    xmllint --huge --noout --nonet --catalogs --nowarning --schema /etc/xml/dpres-xml-schemas/schema_catalogs/schemas/mets/mets.xsd <METS document>

If no error messages are produced, schema validation is successful.

Use the following commands to compile schematron files to XSL files::

    xsltproc -o tempfile1 /usr/share/iso_schematron_xslt1/iso_dsdl_include.xsl /usr/share/dpres-xml-schemas/schematron/<schematron schema>.sch
    xsltproc -o tempfile2 /usr/share/iso_schematron_xslt1/iso_abstract_expand.xsl tempfile1
    xsltproc -o tempfile3 /usr/share/iso_schematron_xslt1/optimize_schematron.xsl tempfile2
    xsltproc -o <new compiled xsl>.xsl --stringparam outputfilter only_messages /usr/share/iso_schematron_xslt1/iso_svrl_for_xslt1.xsl tempfile3

To print out also those activated patterns and fired rules which do not result any messages,
use the following command instead of the last command (this may result to huge output)::

    xsltproc -o <new compiled xsl>.xsl /usr/share/iso_schematron_xslt1/iso_svrl_for_xslt1.xsl tempfile3

Use the following command to validate a METS document::

    xsltproc -o outputfile <compiled xsl>.xsl <METS document>

If all steps return 0 and no "<svrl:failed-assert>" elements are produced to output, validation is succesful. These steps have to be repeated for all schematron schemas (.sch) found in /usr/share/dpres-xml-schemas/schematron/

To validate other XML files (i.e. digital objects), use command::

    xmllint --huge --noout --nonet --catalogs --nowarning --schema <schema file> <XML file>

It is required that the schema files are located in the local catalog, see: /etc/xml/dpres-xml-schemas/schema_catalogs/


Included files
--------------

Schema Catalog:
+++++++++++++++

Paths are described in relation to base path ./schema_catalogs/

./catalog_main.xml
  Main catalog for METS document validation.

./catalog_external.xml
  Catalog for external schemas.

./catalog.dtd
  OASIS Catalog specification file (unchanged)

Modifications to Schemas:
+++++++++++++++++++++++++

Paths are described in relation to base path ./schema_catalogs/schemas/

./mets/mets.xsd
  Schema file importing METS and it's national extensions (main schema)

./mets/fi-mets-extensions.xsd
  National METS extensions

./mets/kdk-mets-extensions.xsd
  Deprecated National METS extensions for specifications v.1.5.0 - 1.6.1

./mods/mods.xsd
  MODS patch file for compatibility

./w3/xlink.xsd
  Xlink patch file for the schema catalog


Schemas:
++++++++

Paths are described in relation to base path ./schema_catalogs/schemas_external/

./addml
  ADDML schema files

./alto
  ALTO schema files

./avmd
  AudioMD and VideoMD schema files

./datacite
  DataCite schema files

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

./ebucore
  EBUCore schema files

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

Schematron:
+++++++++++

Paths related to schematron are described in relation to base path ./schematron/

./abstracts/*
  Abstract patterns used by schematron schemas

./*.sch
  Schematron schemas

