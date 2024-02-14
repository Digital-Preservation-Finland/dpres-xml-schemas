<?xml version="1.0" encoding="UTF-8"?>

<!-- pass-filter: /mets:mets/mets:dmdSec -->
<!-- context-filter: mets:dmdSec|mets:mdWrap|mets:xmlData -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.7.5">
        <sch:title>METS dmdSec validation</sch:title>

<!--
Validates METS dmdSec.
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

        <sch:include href="./abstracts/allowed_attribute_list_pattern.incl"/>
        <sch:include href="./abstracts/disallowed_element_pattern.incl"/>
        <sch:include href="./abstracts/disallowed_unsupported_metadata_pattern.incl"/>
        <sch:include href="./abstracts/required_attribute_xor_attribute_pattern.incl"/>
        <sch:include href="./abstracts/required_attribute_pattern.incl"/>
        <sch:include href="./abstracts/required_element_pattern.incl"/>
        <sch:include href="./abstracts/required_values_attribute_pattern.incl"/>
        <sch:include href="./abstracts/required_metadata_pattern.incl"/>

        <!-- METS internal linking, cross-check part 2: From target to link -->
        <sch:let name="divlinks" value="/mets:mets/mets:structMap//mets:div"/>

        <!-- Allow only given attributes -->
        <sch:pattern id="mets_dmdSec_attribute_list" is-a="allowed_attribute_list_pattern">
                <sch:param name="context_element" value="mets:dmdSec"/>
                <sch:param name="context_condition" value="substring(normalize-space(/mets:mets/@PROFILE),0,44)='http://digitalpreservation.fi/mets-profiles'"/>
                <sch:param name="allowed_attributes" value="@ID | @CREATED | @GROUPID | @ADMID | @STATUS | @fi:CREATED | @fi:PID | @fi:PIDTYPE | @xml:lang"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

        <!-- mdWrap and mdRef elements -->
        <sch:pattern id="mets_dmdSec_mdWrap" is-a="required_element_pattern">
                <sch:param name="context_element" value="mets:dmdSec"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="mets:mdWrap"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="mets_dmdSec_mdRef" is-a="disallowed_element_pattern">
                <sch:param name="context_element" value="mets:dmdSec"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_element" value="mets:mdRef"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

        <!-- dmdSec attributes -->
        <sch:pattern id="mets_dmdSec_CREATED" is-a="required_attribute_xor_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_attribute1" value="@CREATED"/>
                <sch:param name="required_attribute2" value="@fi:CREATED"/>
                <sch:param name="specifications" value="string('not: 1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>
        <sch:pattern id="mets_dmdSec_MDTYPE" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="context_attribute" value="@MDTYPE"/>
                <sch:param name="valid_values" value="string('MARC; DC; MODS; EAD; EAC-CPF; LIDO; VRA; DDI; OTHER')"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="mets_dmdSec_PID" is-a="required_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec"/>
                <sch:param name="context_condition" value="@fi:PIDTYPE"/>
                <sch:param name="required_attribute" value="@fi:PID"/>
                <sch:param name="specifications" value="string('not: 1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>
        <sch:pattern id="mets_dmdSec_PIDTYPE" is-a="required_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec"/>
                <sch:param name="context_condition" value="@fi:PID"/>
                <sch:param name="required_attribute" value="@fi:PIDTYPE"/>
                <sch:param name="specifications" value="string('not: 1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>

        <!-- dmdSec attribute values -->
        <sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_DC" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='DC'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('1.1; 2008')"/>
                <sch:param name="specifications" value="string('not: 1.5.0; 1.6.0; 1.6.1; 1.7.0; 1.7.1')"/>
        </sch:pattern>
        <sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_MODS" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='MODS'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('3.0; 3.1; 3.2; 3.3; 3.4; 3.5; 3.6; 3.7; 3.8')"/>
                <sch:param name="specifications" value="string('not: 1.5.0; 1.6.0; 1.6.1; 1.7.0; 1.7.1; 1.7.2; 1.7.3; 1.7.4; 1.7.5')"/>
        </sch:pattern>
        <sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_EAD" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='EAD'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('2002')"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_EAC" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='EAC-CPF'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('2010_revised; 2.0')"/>
                <sch:param name="specifications" value="string('not: 1.5.0; 1.6.0; 1.6.1; 1.7.0; 1.7.1; 1.7.2; 1.7.3; 1.7.4')"/>
        </sch:pattern>
        <sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_LIDO" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='LIDO'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('1.0; 1.1')"/>
                <sch:param name="specifications" value="string('not: 1.5.0; 1.6.0; 1.6.1; 1.7.0; 1.7.1; 1.7.2; 1.7.3; 1.7.4; 1.7.5')"/>
        </sch:pattern>
        <sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_VRA" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='VRA'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('4.0')"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_DDI" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='DDI'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('3.3; 3.2; 3.1; 2.5.1; 2.5; 2.1')"/>
                <sch:param name="specifications" value="string('not: 1.5.0; 1.6.0; 1.6.1; 1.7.0; 1.7.1; 1.7.2')"/>
        </sch:pattern>
        <sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_MARC" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='MARC'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('marcxml=1.2;marc=marc21')"/>
                <sch:param name="specifications" value="string('not: 1.5.0; 1.6.0; 1.6.1; 1.7.0; 1.7.1; 1.7.2')"/>
        </sch:pattern>
        <sch:pattern id="mets_techMD_MDTYPEVERSION_values_EAD3" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='OTHER' and normalize-space(@OTHERMDTYPE)='EAD3'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('1.1.1; 1.1.0; 1.0.0')"/>
                <sch:param name="specifications" value="string('not: 1.5.0; 1.6.0; 1.6.1; 1.7.0; 1.7.1; 1.7.2')"/>
        </sch:pattern>
        <sch:pattern id="mets_techMD_MDTYPEVERSION_values_DATACITE" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='OTHER' and normalize-space(@OTHERMDTYPE)='DATACITE'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('4.4; 4.3; 4.2; 4.1')"/>
                <sch:param name="specifications" value="string('not: 1.5.0; 1.6.0; 1.6.1; 1.7.0; 1.7.1; 1.7.2; 1.7.3')"/>
        </sch:pattern>
        <sch:pattern id="mets_techMD_MDTYPEVERSION_values_EBUCORE" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='OTHER' and normalize-space(@OTHERMDTYPE)='EBUCORE'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('1.10')"/>
                <sch:param name="specifications" value="string('not: 1.5.0; 1.6.0; 1.6.1; 1.7.0; 1.7.1; 1.7.2')"/>
        </sch:pattern>

        <!-- METS internal linking, cross-check part 2: From target to link -->
        <sch:pattern id="id_references_desc">
                <sch:rule context="mets:dmdSec">
                        <sch:let name="id" value="normalize-space(@ID)"/>
            <sch:assert test="count($divlinks[contains(concat(' ', normalize-space(@DMDID), ' '), concat(' ', $id, ' '))]) &gt; 0">
                                Section containing value '<sch:value-of select="@ID"/>' in attribute '<sch:value-of select="name(@ID)"/>' in element '<sch:value-of select="name(.)"/>' requires a reference from attribute '@DMDID'.
                        </sch:assert>
        </sch:rule>
        </sch:pattern>

        <!-- Known rights, technical, or provenance metadata can not be used inside wrong section -->
        <sch:pattern id="dmdsec_no_rights" is-a="disallowed_element_pattern">
                <sch:param name="context_element" value="mets:dmdSec/mets:mdWrap/mets:xmlData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_element" value="premis:rights"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="dmdsec_no_tech" is-a="disallowed_element_pattern">
                <sch:param name="context_element" value="mets:dmdSec/mets:mdWrap/mets:xmlData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_element" value="premis:object or addml:* or mix:* or audiomd:* or videomd:*"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="dmdsec_no_digiprov" is-a="disallowed_element_pattern">
                <sch:param name="context_element" value="mets:dmdSec/mets:mdWrap/mets:xmlData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_element" value="premis:agent or premis:event"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>


        <!-- COMPATIBILITY WITH DEPRECATED VERSIONS -->

        <!-- Allow only given attributes -->
        <sch:pattern id="mets_dmdSec_attribute_list_pre170" is-a="allowed_attribute_list_pattern">
                <sch:param name="context_element" value="mets:dmdSec"/>
                <sch:param name="context_condition" value="normalize-space(/mets:mets/@PROFILE)='http://www.kdk.fi/kdk-mets-profile'"/>
                <sch:param name="allowed_attributes" value="@ID | @CREATED | @GROUPID | @ADMID | @STATUS | @fikdk:CREATED | @fikdk:PID | @fikdk:PIDTYPE | @xml:lang"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

        <!-- CREATED, PIDTYPE and PID in old specifications -->
        <sch:pattern id="mets_dmdSec_CREATED_pre170" is-a="required_attribute_xor_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_attribute1" value="@CREATED"/>
                <sch:param name="required_attribute2" value="@fikdk:CREATED"/>
                <sch:param name="specifications" value="string('1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>
        <sch:pattern id="mets_dmdSec_PID_pre170" is-a="required_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec"/>
                <sch:param name="context_condition" value="@fikdk:PIDTYPE"/>
                <sch:param name="required_attribute" value="@fikdk:PID"/>
                <sch:param name="specifications" value="string('1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>
        <sch:pattern id="mets_dmdSec_PIDTYPE_pre170" is-a="required_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec"/>
                <sch:param name="context_condition" value="@fikdk:PID"/>
                <sch:param name="required_attribute" value="@fikdk:PIDTYPE"/>
                <sch:param name="specifications" value="string('1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>

        <!-- Metadata types and versions in old specifications -->
        <sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_LIDO_pre176" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='LIDO'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('1.0')"/>
                <sch:param name="specifications" value="string('1.5.0; 1.6.0; 1.6.1; 1.7.0; 1.7.1; 1.7.2; 1.7.3; 1.7.4; 1.7.5')"/>
        </sch:pattern>

        <sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_MODS_pre176" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='MODS'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('3.0; 3.1; 3.2; 3.3; 3.4; 3.5; 3.6; 3.7')"/>
                <sch:param name="specifications" value="string('1.7.1; 1.7.2; 1.7.3; 1.7.4; 1.7.5')"/>
        </sch:pattern>
        <sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_EAC_pre175" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='EAC-CPF'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('2010_revised')"/>
                <sch:param name="specifications" value="string('1.5.0; 1.6.0; 1.6.1; 1.7.0; 1.7.1; 1.7.2; 1.7.3; 1.7.4')"/>
        </sch:pattern>
        <sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_DC_pre172" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='DC'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('1.1')"/>
                <sch:param name="specifications" value="string('1.5.0; 1.6.0; 1.6.1; 1.7.0; 1.7.1')"/>
        </sch:pattern>
        <sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_MODS_pre171" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='MODS'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('3.0; 3.1; 3.2; 3.3; 3.4; 3.5; 3.6')"/>
                <sch:param name="specifications" value="string('1.5.0; 1.6.0; 1.6.1; 1.7.0')"/>
        </sch:pattern>
        <sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_DDI_pre173" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='DDI'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('3.2; 3.1; 2.5.1; 2.5; 2.1')"/>
                <sch:param name="specifications" value="string('1.5.0; 1.6.0; 1.6.1; 1.7.0; 1.7.1; 1.7.2')"/>
        </sch:pattern>
        <sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_MARC_pre173" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='MARC'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('marcxml=1.2;marc=marc21; marcxml=1.2;marc=finmarc')"/>
                <sch:param name="specifications" value="string('1.5.0; 1.6.0; 1.6.1; 1.7.0; 1.7.1; 1.7.2')"/>
        </sch:pattern>
        <sch:pattern id="mets_techMD_MDTYPEVERSION_values_EAD3_pre171" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='OTHER' and normalize-space(@OTHERMDTYPE)='EAD3'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('1.0.0')"/>
                <sch:param name="specifications" value="string('1.5.0; 1.6.0; 1.6.1; 1.7.0')"/>
        </sch:pattern>
        <sch:pattern id="mets_techMD_MDTYPEVERSION_values_EAD3_pre173" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='OTHER' and normalize-space(@OTHERMDTYPE)='EAD3'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('1.1.0; 1.0.0')"/>
                <sch:param name="specifications" value="string('1.7.1; 1.7.2')"/>
        </sch:pattern>
        <sch:pattern id="mets_techMD_MDTYPEVERSION_values_DATACITE_pre172" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='OTHER' and normalize-space(@OTHERMDTYPE)='DATACITE'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('4.1')"/>
                <sch:param name="specifications" value="string('1.7.0; 1.7.1')"/>
        </sch:pattern>
        <sch:pattern id="mets_techMD_MDTYPEVERSION_values_DATACITE_pre174" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='OTHER' and normalize-space(@OTHERMDTYPE)='DATACITE'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('4.3; 4.2; 4.1')"/>
                <sch:param name="specifications" value="string('1.7.2; 1.7.3')"/>
        </sch:pattern>

</sch:schema>
