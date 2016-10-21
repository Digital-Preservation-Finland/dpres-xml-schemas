KDK SCHEMA CATALOG
==================
Current catalog version is 1.5.0, and it includes the following files and directories.
The catalog can be used with KDK specifications 1.5.0 and 1.4. These catalogs paths are relative
to kdk-mets-catalog subdirectory.


CATALOGS:
---------

+------------------------------+----------------------------------------------------------------+
|./catalog-local.xml           |KDK Schema Catalog for local purposes.                          |
+------------------------------+----------------------------------------------------------------+
|./catalog-web.xml             |KDK Schema Catalog for web purposes.                            |
+------------------------------+----------------------------------------------------------------+
|./catalog.dtd                 |OASIS Catalog specification file (unchanged)                    |
+------------------------------+----------------------------------------------------------------+

KDK XSD FILES:
--------------

+------------------------------+----------------------------------------------------------------+
|./mets/mets.xsd               |    KDK METS schema file (main schema)                          |
+------------------------------+----------------------------------------------------------------+
|./mets/kdk-mets-extensions.xsd|    KDK extension file for KDK METS schema                      |
+------------------------------+----------------------------------------------------------------+
|./w3/xlink.xsd                |    Xlink patch file for KDK Schema Catalog                     |
+------------------------------+----------------------------------------------------------------+
|./mods/mods.xsd               |    MODS patch file for KDK Schema Catalog                      |
+------------------------------+----------------------------------------------------------------+
|./textmd/textmd_kdk.xsd       |    For historical purposes related to KDK specification 1.4    |
+------------------------------+----------------------------------------------------------------+


INCLUDED SCHEMAS:
-----------------

+------------------------------+----------------------------------------------------------------+
|./addml                       | ADDML 8.3 schema files (unchanged)                             |
+------------------------------+----------------------------------------------------------------+
|./avmd                        |  AudioMD 2.0 and VideoMD 2.0 schema files (unchanged)          |
+------------------------------+----------------------------------------------------------------+
|./dc                          |  Dublin Core 1.1 schema files (unchanged)                      |
+------------------------------+----------------------------------------------------------------+
|./ddi-codebook/2.5            |  DDI Codebook 2.5.1/2.5 schema files (unchanged)               |
+------------------------------+----------------------------------------------------------------+
|./ddi-codebook/2.1            |  DDI Codebook 2.1 schema files (unchanged)                     |
+------------------------------+----------------------------------------------------------------+
|./ddi-lifecycle/3.2           |  DDI Lifecycle 3.2 schema files (unchanged)                    |
+------------------------------+----------------------------------------------------------------+
|./ddi-lifecycle/3.1           |  DDI Lifecycle 3.1 schema files (unchanged)                    |
+------------------------------+----------------------------------------------------------------+
|./eac                         |  EAC-CPF 2010 schema files (unchanged)                         |
+------------------------------+----------------------------------------------------------------+
|./ead                         |  EAD 2002 schema files (unchanged)                             |
+------------------------------+----------------------------------------------------------------+
|./ead3                        |  EAD3 1.0.0 schema files (changed, see ./ead3/readme.txt)      |
+------------------------------+----------------------------------------------------------------+
|./gml                         |  OpenGIS GML 3.1.1 schema files (changed, see ./gml/readme.txt)|
+------------------------------+----------------------------------------------------------------+
|./lido                        |  LIDO 1.0 schema files (changed, see ./lido/readme.txt)        |
+------------------------------+----------------------------------------------------------------+
|./marc                        |  MARC21 1.2 schema files (unchanged)                           |
+------------------------------+----------------------------------------------------------------+
|./mets                        |  METS 1.11 schema files (extended with separate files)         |
+------------------------------+----------------------------------------------------------------+
|./mix                         |  MIX 2.0 (NISOIMG) schema files (unchanged)                    |
+------------------------------+----------------------------------------------------------------+
|./mods                        |  MODS 3.6 schema files (extended with separate file)           |
+------------------------------+----------------------------------------------------------------+
|./premis                      |  PREMIS 2.3 schema files (unchanged)                           |
+------------------------------+----------------------------------------------------------------+
|./textmd                      |  TextMD 3.01a schema files (unchanged)                         |
+------------------------------+----------------------------------------------------------------+
|./vra                         |  VRA Core 4.0 schema files (unchanged)                         |
+------------------------------+----------------------------------------------------------------+
|./w3                          |  W3 schema files (extended with separate file)                 |
+------------------------------+----------------------------------------------------------------+


SCHEMAS USAGE:
--------------

In KDK-PAS project we have utilized xmllint commandline tool for xsd-schema validation. Following parameters were given
for xml validation:

::

  xmllint --valid --huge --noout --catalogs --schema <schema path> <xml file path>

In addition, set an envirnonment variable $SGML_CATALOG_FILES:

::

  export SGML_CATALOG_FILES=<catalog path>

where <catalog path> is the path of catalog-local.xml provided in this repository in the
location of your installation. In similar way <schema path> is the path of mets/mets.xml provided in this repository.


for further information please read http://xmlsoft.org/xmllint.html fpr xmllint documentation.


SCHEMATRON SCHEMAS:
===================

The schematron schemas paths are described in relation to schematron/kdk-schematron path.

SCHEMATRON USAGE:
-----------------

In schematron validation is done using xsltproc for xslt conversion. A generic way of doing single
xslt conversion with xsltproc is described below. 

::

   xsltproc -o <output_filename> <xslt_template> <input_filename>

Conversions in schematron validation are done in three steps:

::

  xsltproc -o tempfile1 iso_dsdl_include.xsl schematron_schema.sch
  xsltproc -o tempfile2 iso_abstract_expand.xsl tempfile1
  xsltproc -o validator.xsl iso_svrl_for_xslt<schematron version>.xsl tempfile2
  xsltproc -o outputfile validator.xsl mets.xml

If all steps return 0 and no stderr is produced, validation is succesfull. These steps
have to be repeated for all schematron schemas. 
