<?xml version="1.0" encoding="UTF-8"?>

<!-- pass-filter: /mets:mets/mets:amdSec/mets:techMD -->
<!-- context-filter: mets:techMD|mets:mdWrap|mets:xmlData -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.7.5">
        <sch:title>METS techMD validation</sch:title>

<!--
Validates METS techMD.
-->

        <sch:ns prefix="mets" uri="http://www.loc.gov/METS/"/>
        <sch:ns prefix="fikdk" uri="http://www.kdk.fi/standards/mets/kdk-extensions"/>
        <sch:ns prefix="fi" uri="http://digitalpreservation.fi/schemas/mets/fi-extensions"/>
        <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
        <sch:ns prefix="exsl" uri="http://exslt.org/common"/>
        <sch:ns prefix="sets" uri="http://exslt.org/sets"/>
        <sch:ns prefix="str" uri="http://exslt.org/strings"/>
        <sch:ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
        <sch:ns prefix="xml" uri="https://www.w3.org/XML/1998/namespace"/>
        <sch:ns prefix="premis" uri="info:lc/xmlns/premis-v2"/>
        <sch:ns prefix="marc21" uri="http://www.loc.gov/MARC21/slim"/>
        <sch:ns prefix="mods" uri="http://www.loc.gov/mods/v3"/>
        <sch:ns prefix="dc" uri="http://purl.org/dc/elements/1.1/"/>
        <sch:ns prefix="dcterms" uri="http://purl.org/dc/terms/"/>
        <sch:ns prefix="dcmitype" uri="http://purl.org/dc/dcmitype/"/>
        <sch:ns prefix="ead" uri="urn:isbn:1-931666-22-9"/>
        <sch:ns prefix="ead3" uri="http://ead3.archivists.org/schema/"/>
        <sch:ns prefix="eac" uri="urn:isbn:1-931666-33-4"/>
        <sch:ns prefix="eac2" uri="https://archivists.org/ns/eac/v2"/>
        <sch:ns prefix="vra" uri="http://www.vraweb.org/vracore4.htm"/>
        <sch:ns prefix="lido" uri="http://www.lido-schema.org"/>
        <sch:ns prefix="ddilc33" uri="ddi:instance:3_3"/>
        <sch:ns prefix="ddilc32" uri="ddi:instance:3_2"/>
        <sch:ns prefix="ddilc31" uri="ddi:instance:3_1"/>
        <sch:ns prefix="ddicb25" uri="ddi:codebook:2_5"/>
        <sch:ns prefix="ddicb21" uri="http://www.icpsr.umich.edu/DDI"/>
        <sch:ns prefix="datacite" uri="http://datacite.org/schema/kernel-4"/>

        <sch:include href="./abstracts/disallowed_element_pattern.incl"/>
        <sch:include href="./abstracts/required_element_pattern.incl"/>
        <sch:include href="./abstracts/required_values_attribute_pattern.incl"/>
        <sch:include href="./abstracts/required_metadata_pattern.incl"/>


        <!-- Container formats divided with a space character -->
        <sch:let name="container_formats" value="string('video/x-ms-asf video/avi video/MP1S video/MP2P video/MP2T video/mp4 application/mxf video/mj2 video/quicktime')"/>


        <!-- mdWrap and mdRef elements -->
        <sch:pattern id="mets_techMD_mdWrap" is-a="required_element_pattern">
                <sch:param name="context_element" value="mets:techMD"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="mets:mdWrap"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="mets_techMD_mdRef" is-a="disallowed_element_pattern">
                <sch:param name="context_element" value="mets:techMD"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_element" value="mets:mdRef"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

        <!-- dmdSec, techMD, rightsMD, sourceMD and digiprovMD attributes -->
        <sch:pattern id="mets_techMD_MDTYPE" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:techMD/mets:mdWrap"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="context_attribute" value="@MDTYPE"/>
                <sch:param name="valid_values" value="string('PREMIS:OBJECT; NISOIMG; TEXTMD; OTHER')"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

        <!-- Attribute MDTYPE version values -->
        <sch:pattern id="mets_techMD_MDTYPEVERSION_values_OBJECT" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:techMD/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='PREMIS:OBJECT'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('2.2; 2.3')"/>
                <sch:param name="specifications" value="string('not: 1.5.0')"/>
        </sch:pattern>
        <sch:pattern id="mets_techMD_MDTYPEVERSION_values_MIX" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:techMD/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='NISOIMG'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('2.0')"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="mets_techMD_MDTYPEVERSION_values_AudioMD" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:techMD/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='OTHER' and normalize-space(@OTHERMDTYPE)='AudioMD'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('2.0')"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="mets_techMD_MDTYPEVERSION_values_VideoMD" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:techMD/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='OTHER' and normalize-space(@OTHERMDTYPE)='VideoMD'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('2.0')"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="mets_techMD_MDTYPEVERSION_values_ADDML" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:techMD/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='OTHER' and normalize-space(@OTHERMDTYPE)='ADDML'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('8.2; 8.3')"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="mets_techMD_MDTYPEVERSION_values_EBUCORE" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:techMD/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='OTHER' and normalize-space(@OTHERMDTYPE)='EBUCORE'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('1.10')"/>
                <sch:param name="specifications" value="string('not: 1.5.0; 1.6.0; 1.6.1; 1.7.0; 1.7.1; 1.7.2')"/>
        </sch:pattern>

        <!-- Known descriptive, rights, technical, or provenance metadata can not be used inside wrong section -->
        <sch:pattern id="techmd_no_rights" is-a="disallowed_element_pattern">
                <sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_element" value="premis:rights"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="techmd_no_digiprov" is-a="disallowed_element_pattern">
                <sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_element" value="premis:agent or premis:event"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="techmd_no_descriptive" is-a="disallowed_element_pattern">
                <sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_element" value="eac:* or eac2:* or datacite:* or lido:* or ead:* or ead3:* or vra:* or mods:* or marc21:* or dc:* or dcterms:* or dcmitype:* or ddilc33:* or ddilc32:* or ddilc31:* or ddicb25:* or ddicb21:*"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

        <!-- Container and stream checks -->
        <sch:pattern id="container_with_streams">
                <sch:rule context="mets:techMD[./mets:mdWrap/mets:xmlData/premis:object/premis:objectCharacteristics/premis:format/premis:formatDesignation/premis:formatName and ancestor-or-self::mets:mets/mets:fileSec]">
                        <sch:let name="tech_id" value="normalize-space(@ID)"/>
                        <sch:let name="premis_format" value="normalize-space(./mets:mdWrap/mets:xmlData/premis:object/premis:objectCharacteristics/premis:format/premis:formatDesignation/premis:formatName)"/>
                        <sch:let name="container_file" value="ancestor-or-self::mets:mets/mets:fileSec/mets:fileGrp/mets:file[contains(concat(' ', @ADMID, ' '), concat(' ', $tech_id, ' '))]"/>
                        <sch:assert test="$container_file/mets:stream or not(contains(concat(' ', $container_formats, ' '), concat(' ', $premis_format, ' '))) or $premis_format='video/mp4' or $container_file/@USE=normalize-space('fi-dpres-no-file-format-validation')">
                                Streams missing for container file '<sch:value-of select="$container_file/mets:FLocat/@xlink:href"/>'.
                        </sch:assert>
                </sch:rule>
        </sch:pattern>

        <!-- COMPATIBILITY WITH DEPRECATED VERSIONS -->

        <!-- PREMIS 2.1 in specification 1.5.0 -->
        <sch:pattern id="mets15_techMD_MDTYPEVERSION_values_OBJECT" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:techMD/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='PREMIS:OBJECT'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('2.1; 2.2; 2.3')"/>
                <sch:param name="specifications" value="string('1.5.0')"/>
        </sch:pattern>

</sch:schema>
