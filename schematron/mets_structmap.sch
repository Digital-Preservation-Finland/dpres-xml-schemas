<?xml version="1.0" encoding="UTF-8"?>

<!-- pass-filter: /mets:mets/mets:structMap -->
<!-- context-filter: mets:structMap|mets:div|mets:fptr|mets:mptr|mets:par|mets:seq|mets:area -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.7.3">
	<sch:title>METS structMap validation</sch:title>

<!--
Validates METS structMap.
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

        <sch:include href="./abstracts/allowed_attribute_list_pattern.incl"/>
	<sch:include href="./abstracts/disallowed_attribute_pattern.incl"/>
	<sch:include href="./abstracts/required_attribute_or_element_pattern.incl"/>
	<sch:include href="./abstracts/required_attribute_pattern.incl"/>
	<sch:include href="./abstracts/required_element_pattern.incl"/>
	<sch:include href="./abstracts/required_max_elements_pattern.incl"/>
	<sch:include href="./abstracts/required_values_attribute_pattern.incl"/>

        <!-- METS internal linking, cross-check part 1: From link to target -->
        <sch:let name="dmdids" value="/mets:mets/mets:dmdSec/@ID"/>
        <sch:let name="admids" value="/mets:mets/mets:amdSec/*/@ID"/>
        <sch:let name="fileids" value="/mets:mets/mets:fileSec/mets:fileGrp/mets:file/@ID"/>
        <sch:let name="dmdids_c" value="count($dmdids)"/>
        <sch:let name="admids_c" value="count($admids)"/>
        <sch:let name="fileids_c" value="count($fileids)"/>

	<!-- Allow only given attributes -->
        <sch:pattern id="mets_structMap_attribute_list" is-a="allowed_attribute_list_pattern">
                <sch:param name="context_element" value="mets:structMap"/>
                <sch:param name="context_condition" value="substring(normalize-space(/mets:mets/@PROFILE),0,44)='http://digitalpreservation.fi/mets-profiles'"/>
                <sch:param name="allowed_attributes" value="@ID | @TYPE | @LABEL | @fi:PID | @fi:PIDTYPE"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="mets_fptr_attribute_list" is-a="allowed_attribute_list_pattern">
                <sch:param name="context_element" value="mets:fptr"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="allowed_attributes" value="@ID | @CONTENTIDS | @FILEID"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="mets_par_attribute_list" is-a="allowed_attribute_list_pattern">
                <sch:param name="context_element" value="mets:par"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="allowed_attributes" value="@ID | @ORDER | @ORDERLABEL | @LABEL"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="mets_seq_attribute_list" is-a="allowed_attribute_list_pattern">
                <sch:param name="context_element" value="mets:seq"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="allowed_attributes" value="@ID | @ORDER | @ORDERLABEL | @LABEL"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="mets_area_attribute_list" is-a="allowed_attribute_list_pattern">
                <sch:param name="context_element" value="mets:area"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="allowed_attributes" value="@ID | @ORDER | @ORDERLABEL | @LABEL | @FILEID | @SHAPE | @COORDS | @BEGIN | @END | @BETYPE | @EXTENT | @EXTTYPE | @ADMID | @CONTENTIDS"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

	<!-- StructMap div and attributes -->
        <sch:pattern id="mets_structMap_PID" is-a="required_attribute_pattern">
                <sch:param name="context_element" value="mets:structMap"/>
                <sch:param name="context_condition" value="@fi:PIDTYPE"/>
                <sch:param name="required_attribute" value="@fi:PID"/>
                <sch:param name="specifications" value="string('not: 1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>
        <sch:pattern id="mets_structMap_PIDTYPE" is-a="required_attribute_pattern">
                <sch:param name="context_element" value="mets:structMap"/>
                <sch:param name="context_condition" value="@fi:PID"/>
                <sch:param name="required_attribute" value="@fi:PIDTYPE"/>
                <sch:param name="specifications" value="string('not: 1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>
	<sch:pattern id="mets_div_TYPE" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:div"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@TYPE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- fptr and mptr attributes -->
	<sch:pattern id="mets_fptr_FILEID" is-a="required_attribute_or_element_pattern">
		<sch:param name="context_element" value="mets:fptr"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@FILEID"/>
		<sch:param name="required_element" value=".//mets:area"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mptr_href" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:mptr"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@xlink:href"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mptr_type" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:mptr"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@xlink:type"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mptr_OTHERLOCTYPE" is-a="disallowed_attribute_pattern">
		<sch:param name="context_element" value="mets:mptr"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@OTHERLOCTYPE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mptr_LOCTYPE_values" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:mptr"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@LOCTYPE"/>
		<sch:param name="valid_values" value="string('URL')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mptr_type_values" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:mptr"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@xlink:type"/>
		<sch:param name="valid_values" value="string('simple')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

        <!-- METS internal linking, cross-check part 1: From link to target -->
        <sch:pattern id="link_div_dmdid">
                <sch:rule context="mets:div[@DMDID]">
            <sch:assert test="count(sets:distinct(str:tokenize(normalize-space(@DMDID),' ') | exsl:node-set($dmdids))) = $dmdids_c">
                                Value '<sch:value-of select="@DMDID"/>' in attribute '<sch:value-of select="name(@DMDID)"/>' in element '<sch:name/>' contains a link to nowhere. The corresponding target attribute '@ID' with the same value was not found.
                        </sch:assert>
                </sch:rule>
        </sch:pattern>
        <sch:pattern id="link_div_admid">
                <sch:rule context="mets:div[@ADMID]">
            <sch:assert test="count(sets:distinct(str:tokenize(normalize-space(@ADMID),' ') | exsl:node-set($admids))) = $admids_c">
                                Value '<sch:value-of select="@ADMID"/>' in attribute '<sch:value-of select="name(@ADMID)"/>' in element '<sch:name/>' contains a link to nowhere. The corresponding target attribute '@ID' with the same value was not found.
                        </sch:assert>
                </sch:rule>
        </sch:pattern>
        <sch:pattern id="link_fptr_fileid">
                <sch:rule context="mets:fptr[@FILEID]">
            <sch:assert test="count(sets:distinct(str:tokenize(normalize-space(@FILEID),' ') | exsl:node-set($fileids))) = $fileids_c">
                                Value '<sch:value-of select="@FILEID"/>' in attribute '<sch:value-of select="name(@FILEID)"/>' in element '<sch:name/>' contains a link to nowhere. The corresponding target attribute '@ID' with the same value was not found.
                        </sch:assert>
                </sch:rule>
        </sch:pattern>
        <sch:pattern id="link_area_fileid">
                <sch:rule context="mets:area[@FILEID]">
            <sch:assert test="count(sets:distinct(str:tokenize(normalize-space(@FILEID),' ') | exsl:node-set($fileids))) = $fileids_c">
                                Value '<sch:value-of select="@FILEID"/>' in attribute '<sch:value-of select="name(@FILEID)"/>' in element '<sch:name/>' contains a link to nowhere. The corresponding target attribute '@ID' with the same value was not found.
                        </sch:assert>
                </sch:rule>
        </sch:pattern>


	<!-- COMPATIBILITY WITH DEPRECATED VERSIONS -->

	<!-- Allow only given attributes -->
        <sch:pattern id="mets_structMap_attribute_list_pre170" is-a="allowed_attribute_list_pattern">
                <sch:param name="context_element" value="mets:structMap"/>
                <sch:param name="context_condition" value="normalize-space(/mets:mets/@PROFILE)='http://www.kdk.fi/kdk-mets-profile'"/>
                <sch:param name="allowed_attributes" value="@ID | @TYPE | @LABEL | @fikdk:PID | @fikdk:PIDTYPE"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

	<!-- PIDTYPE and PID in old specifications -->
        <sch:pattern id="mets_structMap_PID_pre170" is-a="required_attribute_pattern">
                <sch:param name="context_element" value="mets:structMap"/>
                <sch:param name="context_condition" value="@fikdk:PIDTYPE"/>
                <sch:param name="required_attribute" value="@fikdk:PID"/>
                <sch:param name="specifications" value="string('1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>
        <sch:pattern id="mets_structMap_PIDTYPE_pre170" is-a="required_attribute_pattern">
                <sch:param name="context_element" value="mets:structMap"/>
                <sch:param name="context_condition" value="@fikdk:PID"/>
                <sch:param name="required_attribute" value="@fikdk:PIDTYPE"/>
                <sch:param name="specifications" value="string('1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>

</sch:schema>
