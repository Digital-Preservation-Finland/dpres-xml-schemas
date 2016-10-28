KDK-METS-SCHEMAS
================

This repository is currently used in `National Digital Library <http://www.kdk.fi/en/>`_ and `Open Science and Research Initiative <http://openscience.fi/frontpage>`_ for metadata validation of digital preservation. Kdk-mets-schemas is a collection of xsd-schemas and catalogs as well as schmematron files which together validate all xml metadata compiled in mets.xml used in digital preservation

Current catalog version is 1.5.0, and it includes the following files and directories.
The catalog can be used with KDK specifications 1.5.0 and 1.4. These catalogs paths are relative
to kdk-mets-catalog subdirectory.

-------------------

USAGE:
------

In KDK-PAS project we have utilized xmllint commandline tool for xsd-schema validation.
Following parameters are given for xml validation:

::

  xmllint --valid --huge --noout --catalogs --schema <schema_path> <mets_xml_file_path>

In addition, set an envirnonment variable $SGML_CATALOG_FILES:

::

  export SGML_CATALOG_FILES=<catalog_path>

where <catalog_path> is the path of catalog-local.xml provided in this repository in the
location of your installation. In similar way <schema_path> is the path of ./mets/mets.xsd provided in this repository.


For further information, see: http://xmlsoft.org/xmllint.html

-----------------

Schematron validation is done using xsltproc for xslt conversion. A generic way of doing single
xslt conversion with xsltproc is described below. 

::

   xsltproc -o <output_filename> <xslt_template> <input_filename>

Conversions in schematron validation are done in following steps:

::

  xsltproc -o tempfile1 iso_dsdl_include.xsl <schematron_schema>
  xsltproc -o tempfile2 iso_abstract_expand.xsl tempfile1
  xsltproc -o validator.xsl iso_svrl_for_xslt1.xsl tempfile2
  xsltproc -o outputfile validator.xsl /path-to/mets.xml

where <schematron_schema> is a schematron file provided in this repository.

XSLT conversion files are required to make conversions, see file iso-schematron-xslt1.zip
which can be downloaded from http://www.schematron.com/implementation.html
Additionally, EXSLT extensions for XSLT are required, see http://exslt.org/

If all steps return 0 and no stderr is produced, validation is succesfull. These steps
have to be repeated for all schematron schemas.

For further information, see: http://www.schematron.com/ and http://exslt.org/


INCLUDED FILES
--------------
Paths other than schematron schemas are described in relation to base path kdk-mets-catalog

CATALOGS:
+++++++++

+------------------------------+----------------------------------------------------------------+
|./catalog-local.xml           |KDK Schema Catalog for local purposes.                          |
+------------------------------+----------------------------------------------------------------+
|./catalog-web.xml             |KDK Schema Catalog for web purposes.                            |
+------------------------------+----------------------------------------------------------------+
|./catalog.dtd                 |OASIS Catalog specification file (unchanged)                    |
+------------------------------+----------------------------------------------------------------+

KDK EXTENSIONS TO SCHEMAS:
++++++++++++++++++++++++++

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


SCHEMAS:
++++++++

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


SCHEMATRON:
+++++++++++

+--------------------------------+--------------------------------------------------------------+
|schematron/kdk-schematron/addml | ADDML 8.3 schema files (unchanged)                           |
+--------------------------------+--------------------------------------------------------------+
|schematron/kdk-schematron/avmd  |  AudioMD 2.0 and VideoMD 2.0 schema files (unchanged)        |
+--------------------------------+--------------------------------------------------------------+

CONTRIBUTION
------------
All contribution is wellcome and we can provide more information through our email address pas-support@csc.fi on issues related to this repository. Pull requests are handled according our schedule by our specialists and we aim to be fairly active on this. Most on the development takes place in `CSC - IT Center for Science <www.csc.fi>`_. 
