<?xml version="1.0" encoding="UTF-8"?>

<!-- pass-filter: /mets:mets/mets:dmdSec/mets:mdWrap|/mets:mets/mets:amdSec/mets:*/mets:mdWrap -->
<!-- context-filter: mets:mdWrap -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.7.4">
        <sch:title>METS mdWrap validation</sch:title>

<!--
Validates METS mdWrap.
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
        <sch:ns prefix="mix" uri="http://www.loc.gov/mix/v20"/>
        <sch:ns prefix="addml" uri="http://www.arkivverket.no/standarder/addml"/>
        <sch:ns prefix="audiomd" uri="http://www.loc.gov/audioMD/"/>
        <sch:ns prefix="videomd" uri="http://www.loc.gov/videoMD/"/>
        <sch:ns prefix="marc21" uri="http://www.loc.gov/MARC21/slim"/>
        <sch:ns prefix="mods" uri="http://www.loc.gov/mods/v3"/>
        <sch:ns prefix="dc" uri="http://purl.org/dc/elements/1.1/"/>
        <sch:ns prefix="dcterms" uri="http://purl.org/dc/terms/"/>
        <sch:ns prefix="dcmitype" uri="http://purl.org/dc/dcmitype/"/>
        <sch:ns prefix="ead" uri="urn:isbn:1-931666-22-9"/>
        <sch:ns prefix="ead3" uri="http://ead3.archivists.org/schema/"/>
        <sch:ns prefix="eac" uri="urn:isbn:1-931666-33-4"/>
        <sch:ns prefix="vra" uri="http://www.vraweb.org/vracore4.htm"/>
        <sch:ns prefix="lido" uri="http://www.lido-schema.org"/>
        <sch:ns prefix="ddilc33" uri="ddi:instance:3_3"/>
        <sch:ns prefix="ddilc32" uri="ddi:instance:3_2"/>
        <sch:ns prefix="ddilc31" uri="ddi:instance:3_1"/>
        <sch:ns prefix="ddicb25" uri="ddi:codebook:2_5"/>
        <sch:ns prefix="ddicb21" uri="http://www.icpsr.umich.edu/DDI"/>
        <sch:ns prefix="datacite" uri="http://datacite.org/schema/kernel-4"/>
        <sch:ns prefix="ebucore" uri="urn:ebu:metadata-schema:ebucore"/>

        <sch:include href="./abstracts/disallowed_attribute_pattern.incl"/>
        <sch:include href="./abstracts/disallowed_element_pattern.incl"/>
        <sch:include href="./abstracts/required_attribute_pattern.incl"/>
        <sch:include href="./abstracts/required_element_pattern.incl"/>
        <sch:include href="./abstracts/allowed_unsupported_metadata_pattern.incl"/>
        <sch:include href="./abstracts/required_metadata_match_pattern.incl"/>

        <!-- mdWrap elements and attributes -->
        <sch:pattern id="mets_mdWrap_xmlData" is-a="required_element_pattern">
                <sch:param name="context_element" value="mets:mdWrap"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="mets:xmlData"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="mets_mdWrap_binData" is-a="disallowed_element_pattern">
                <sch:param name="context_element" value="mets:mdWrap"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_element" value="mets:binData"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="mets_OTHERMDTYPE" is-a="required_attribute_pattern">
                <sch:param name="context_element" value="mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='OTHER'"/>
                <sch:param name="required_attribute" value="@OTHERMDTYPE"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="mets_no_OTHERMDTYPE" is-a="disallowed_attribute_pattern">
                <sch:param name="context_element" value="mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)!='OTHER'"/>
                <sch:param name="disallowed_attribute" value="@OTHERMDTYPE"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="mets_mdWrap_CHECKSUM" is-a="required_attribute_pattern">
                <sch:param name="context_element" value="mets:mdWrap"/>
                <sch:param name="context_condition" value="@CHECKSUMTYPE"/>
                <sch:param name="required_attribute" value="@CHECKSUM"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="mets_mdWrap_CHECKSUMTYPE" is-a="required_attribute_pattern">
                <sch:param name="context_element" value="mets:mdWrap"/>
                <sch:param name="context_condition" value="@CHECKSUM"/>
                <sch:param name="required_attribute" value="@CHECKSUMTYPE"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
           <sch:pattern id="mets_MDTYPEVERSION" is-a="required_attribute_pattern">
                <sch:param name="context_element" value="mets:mdWrap"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

        <!-- Check metadata content in mdWrap -->
        <sch:pattern id="mets_mdtype_content" is-a="required_metadata_match_pattern">
                <sch:param name="context_condition" value="not(@OTHERMDTYPE)"/>
                <sch:param name="required_condition" value="(number(normalize-space(@MDTYPE)='PREMIS:OBJECT')*count(mets:xmlData/premis:object)*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='PREMIS:RIGHTS')*count(mets:xmlData/premis:rights)*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='PREMIS:EVENT')*count(mets:xmlData/premis:event)*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='PREMIS:AGENT')*count(mets:xmlData/premis:agent)*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='NISOIMG')*number(boolean(mets:xmlData/mix:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='MARC')*number(boolean(mets:xmlData/marc21:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DC')*number(boolean(mets:xmlData/dc:* or mets:xmlData/dcterms:* or mets:xmlData/dcmitype:*))
                          + number(normalize-space(@MDTYPE)='MODS')*number(boolean(mets:xmlData/mods:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='EAD')*number(boolean(mets:xmlData/ead:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='EAC-CPF')*number(boolean(mets:xmlData/eac:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='LIDO')*number(boolean(mets:xmlData/lido:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='VRA')*number(boolean(mets:xmlData/vra:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='3.3')*number(boolean(mets:xmlData/ddilc33:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='3.2')*number(boolean(mets:xmlData/ddilc32:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='3.1')*number(boolean(mets:xmlData/ddilc31:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='2.5')*number(boolean(mets:xmlData/ddicb25:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='2.5.1')*number(boolean(mets:xmlData/ddicb25:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='2.1')*number(boolean(mets:xmlData/ddicb21:*))*count(mets:xmlData/*)) = 1"/>
                <sch:param name="used_attribute" value="@MDTYPE"/>
                <sch:param name="specifications" value="string('not: 1.5.0; 1.6.0; 1.6.1; 1.7.0; 1.7.1; 1.7.2')"/>
        </sch:pattern>
        <sch:pattern id="mets_othermdtype_content" is-a="required_metadata_match_pattern">
                <sch:param name="context_condition" value="@OTHERMDTYPE"/>
                <sch:param name="required_condition" value="(number(normalize-space(@OTHERMDTYPE)='ADDML')*number(boolean(mets:xmlData/addml:*))*count(mets:xmlData/*)
                          + number(normalize-space(@OTHERMDTYPE)='AudioMD')*number(boolean(mets:xmlData/audiomd:*))*count(mets:xmlData/*)
                          + number(normalize-space(@OTHERMDTYPE)='VideoMD')*number(boolean(mets:xmlData/videomd:*))*count(mets:xmlData/*)
                          + number(normalize-space(@OTHERMDTYPE)='EAD3')*number(boolean(mets:xmlData/ead3:*))*count(mets:xmlData/*)
                          + number(normalize-space(@OTHERMDTYPE)='DATACITE')*number(boolean(mets:xmlData/datacite:*))*count(mets:xmlData/*)
                          + number(normalize-space(@OTHERMDTYPE)='EBUCORE')*number(boolean(mets:xmlData/ebucore:*))*count(mets:xmlData/*)
                          + number(normalize-space(@OTHERMDTYPE)!='ADDML' and normalize-space(@OTHERMDTYPE)!='AudioMD' and normalize-space(@OTHERMDTYPE)!='VideoMD' and normalize-space(@OTHERMDTYPE)!='EAD3' and normalize-space(@OTHERMDTYPE)!='DATACITE')*count(mets:xmlData/*)) = 1"/>
                <sch:param name="used_attribute" value="@OTHERMDTYPE"/>
                <sch:param name="specifications" value="string('not: 1.5.0; 1.6.0; 1.6.1; 1.7.0; 1.7.1; 1.7.2')"/>
        </sch:pattern>

        <!-- Notify the existence of unsupported metadata -->
        <sch:pattern id="mets_allowedmd_unsupported" is-a="allowed_unsupported_metadata_pattern">
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_condition" value="@OTHERMDTYPE!='AudioMD' and @OTHERMDTYPE!='VideoMD' and @OTHERMDTYPE!='EAD3' and @OTHERMDTYPE!='ADDML' and @OTHERMDTYPE!='DATACITE' and @OTHERMDTYPE!='EBUCORE'"/>
                <sch:param name="specifications" value="string('not: 1.5.0; 1.6.0; 1.6.1; 1.7.0; 1.7.1; 1.7.2')"/>
        </sch:pattern>

        <!-- COMPATIBILITY WITH DEPRECATED VERSIONS -->

        <!-- Check metadata content in mdWrap with old specifications -->
        <sch:pattern id="mets_mdtype_content_pre173" is-a="required_metadata_match_pattern">
                <sch:param name="context_condition" value="not(@OTHERMDTYPE)"/>
                <sch:param name="required_condition" value="(number(normalize-space(@MDTYPE)='PREMIS:OBJECT')*count(mets:xmlData/premis:object)*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='PREMIS:RIGHTS')*count(mets:xmlData/premis:rights)*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='PREMIS:EVENT')*count(mets:xmlData/premis:event)*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='PREMIS:AGENT')*count(mets:xmlData/premis:agent)*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='NISOIMG')*number(boolean(mets:xmlData/mix:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='MARC')*number(boolean(mets:xmlData/marc21:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DC')*number(boolean(mets:xmlData/dc:* or mets:xmlData/dcterms:* or mets:xmlData/dcmitype:*))
                          + number(normalize-space(@MDTYPE)='MODS')*number(boolean(mets:xmlData/mods:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='EAD')*number(boolean(mets:xmlData/ead:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='EAC-CPF')*number(boolean(mets:xmlData/eac:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='LIDO')*number(boolean(mets:xmlData/lido:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='VRA')*number(boolean(mets:xmlData/vra:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='3.2')*number(boolean(mets:xmlData/ddilc32:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='3.1')*number(boolean(mets:xmlData/ddilc31:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='2.5')*number(boolean(mets:xmlData/ddicb25:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='2.5.1')*number(boolean(mets:xmlData/ddicb25:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='2.1')*number(boolean(mets:xmlData/ddicb21:*))*count(mets:xmlData/*)) = 1"/>
                <sch:param name="used_attribute" value="@MDTYPE"/>
                <sch:param name="specifications" value="string('1.6.0; 1.6.1; 1.7.0; 1.7.1; 1.7.2')"/>
        </sch:pattern>
        <sch:pattern id="mets_othermdtype_content_pre173" is-a="required_metadata_match_pattern">
                <sch:param name="context_condition" value="@OTHERMDTYPE"/>
                <sch:param name="required_condition" value="(number(normalize-space(@OTHERMDTYPE)='ADDML')*number(boolean(mets:xmlData/addml:*))*count(mets:xmlData/*)
                          + number(normalize-space(@OTHERMDTYPE)='AudioMD')*number(boolean(mets:xmlData/audiomd:*))*count(mets:xmlData/*)
                          + number(normalize-space(@OTHERMDTYPE)='VideoMD')*number(boolean(mets:xmlData/videomd:*))*count(mets:xmlData/*)
                          + number(normalize-space(@OTHERMDTYPE)='EAD3')*number(boolean(mets:xmlData/ead3:*))*count(mets:xmlData/*)
                          + number(normalize-space(@OTHERMDTYPE)='DATACITE')*number(boolean(mets:xmlData/datacite:*))*count(mets:xmlData/*)
                          + number(normalize-space(@OTHERMDTYPE)!='ADDML' and normalize-space(@OTHERMDTYPE)!='AudioMD' and normalize-space(@OTHERMDTYPE)!='VideoMD' and normalize-space(@OTHERMDTYPE)!='EAD3' and normalize-space(@OTHERMDTYPE)!='DATACITE')*count(mets:xmlData/*)) = 1"/>
                <sch:param name="used_attribute" value="@OTHERMDTYPE"/>
                <sch:param name="specifications" value="string('1.7.0; 1.7.1; 1.7.2')"/>
        </sch:pattern>

        <!-- Notify the existence of unsupported metadata with old specifications -->
        <sch:pattern id="mets_allowedmd_unsupported_pre173" is-a="allowed_unsupported_metadata_pattern">
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_condition" value="@OTHERMDTYPE!='AudioMD' and @OTHERMDTYPE!='VideoMD' and @OTHERMDTYPE!='EAD3' and @OTHERMDTYPE!='ADDML' and @OTHERMDTYPE!='DATACITE'"/>
                <sch:param name="specifications" value="string('1.7.0; 1.7.1; 1.7.2')"/>
        </sch:pattern>

        <!-- Check metadata content in mdWrap with old specifications -->
        <sch:pattern id="mets_mdtype_content_150" is-a="required_metadata_match_pattern">
                <sch:param name="context_condition" value="not(@OTHERMDTYPE)"/>
                <sch:param name="required_condition" value="(number(normalize-space(@MDTYPE)='PREMIS:OBJECT')*count(mets:xmlData/premis:object)*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='PREMIS:RIGHTS')*count(mets:xmlData/premis:rights)*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='PREMIS:RIGHTS')*count(mets:xmlData/premis:rightsStatement)*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='PREMIS:EVENT')*count(mets:xmlData/premis:event)*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='PREMIS:AGENT')*count(mets:xmlData/premis:agent)*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='NISOIMG')*number(boolean(mets:xmlData/mix:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='MARC')*number(boolean(mets:xmlData/marc21:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DC')*number(boolean(mets:xmlData/dc:* or mets:xmlData/dcterms:* or mets:xmlData/dcmitype:*))
                          + number(normalize-space(@MDTYPE)='MODS')*number(boolean(mets:xmlData/mods:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='EAD')*number(boolean(mets:xmlData/ead:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='EAC-CPF')*number(boolean(mets:xmlData/eac:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='LIDO')*number(boolean(mets:xmlData/lido:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='VRA')*number(boolean(mets:xmlData/vra:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='3.2')*number(boolean(mets:xmlData/ddilc32:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='3.1')*number(boolean(mets:xmlData/ddilc31:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='2.5')*number(boolean(mets:xmlData/ddicb25:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='2.5.1')*number(boolean(mets:xmlData/ddicb25:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='2.1')*number(boolean(mets:xmlData/ddicb21:*))*count(mets:xmlData/*)) = 1"/>
                <sch:param name="used_attribute" value="@MDTYPE"/>
                <sch:param name="specifications" value="string('1.5.0')"/>
        </sch:pattern>
        <sch:pattern id="mets_othermdtype_content_pre170" is-a="required_metadata_match_pattern">
                <sch:param name="context_condition" value="@OTHERMDTYPE"/>
                <sch:param name="required_condition" value="(number(normalize-space(@OTHERMDTYPE)='ADDML')*number(boolean(mets:xmlData/addml:*))*count(mets:xmlData/*)
                          + number(normalize-space(@OTHERMDTYPE)='AudioMD')*number(boolean(mets:xmlData/audiomd:*))*count(mets:xmlData/*)
                          + number(normalize-space(@OTHERMDTYPE)='VideoMD')*number(boolean(mets:xmlData/videomd:*))*count(mets:xmlData/*)
                          + number(normalize-space(@OTHERMDTYPE)='EAD3')*number(boolean(mets:xmlData/ead3:*))*count(mets:xmlData/*)
                          + number(normalize-space(@OTHERMDTYPE)!='ADDML' and normalize-space(@OTHERMDTYPE)!='AudioMD' and normalize-space(@OTHERMDTYPE)!='VideoMD' and normalize-space(@OTHERMDTYPE)!='EAD3')*count(mets:xmlData/*)) = 1"/>
                <sch:param name="used_attribute" value="@OTHERMDTYPE"/>
                <sch:param name="specifications" value="string('1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>
        <sch:pattern id="mets_allowedmd_unsupported_pre170" is-a="allowed_unsupported_metadata_pattern">
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_condition" value="@OTHERMDTYPE!='AudioMD' and @OTHERMDTYPE!='VideoMD' and @OTHERMDTYPE!='EAD3' and @OTHERMDTYPE!='ADDML'"/>
                <sch:param name="specifications" value="string('1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>


</sch:schema>
