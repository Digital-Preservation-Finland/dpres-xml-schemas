<?xml version="1.0" encoding="UTF-8"?>

<!-- pass-filter: /mets:mets/mets:amdSec -->
<!-- context-filter: mets:amdSec|mets:techMD|mets:rightsMD|mets:sourceMD|mets:digiprovMD -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.7.4">
	<sch:title>METS amdSec validation</sch:title>

<!--
Validates METS amdSec.
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
	<sch:include href="./abstracts/required_attribute_xor_attribute_pattern.incl"/>
	<sch:include href="./abstracts/required_attribute_pattern.incl"/>
	<sch:include href="./abstracts/required_element_pattern.incl"/>

	<!-- METS internal linking, cross-check part 2: From target to link -->
	<sch:let name="divlinks" value="/mets:mets/mets:structMap//mets:div"/>
	<sch:let name="filelinks" value="/mets:mets/mets:fileSec/mets:fileGrp/mets:file"/>
	<sch:let name="streamlinks" value="/mets:mets/mets:fileSec/mets:fileGrp/mets:file/mets:stream"/>

        <sch:pattern id="mets_amdSec_attribute_list" is-a="allowed_attribute_list_pattern">
                <sch:param name="context_element" value="mets:amdSec/*"/>
                <sch:param name="context_condition" value="substring(normalize-space(/mets:mets/@PROFILE),0,44)='http://digitalpreservation.fi/mets-profiles'"/>
                <sch:param name="allowed_attributes" value="@ID | @CREATED | @GROUPID | @ADMID | @STATUS | @fi:CREATED | @fi:PID | @fi:PIDTYPE | @xml:lang"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="mets_amdSec_root_attribute_list" is-a="allowed_attribute_list_pattern">
                <sch:param name="context_element" value="mets:amdSec"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="allowed_attributes" value="@ID"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

	<!-- METS amdSec elements -->
	<sch:pattern id="mets_amdSec_techMD" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:amdSec"/>
		<sch:param name="context_condition" value="count(../mets:amdSec)=1"/>
		<sch:param name="required_element" value="mets:techMD"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_amdSec_digiprovMD" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:amdSec"/>
		<sch:param name="context_condition" value="count(../mets:amdSec)=1"/>
		<sch:param name="required_element" value="mets:digiprovMD"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<sch:pattern id="mets_amdSec_CREATED" is-a="required_attribute_xor_attribute_pattern">
		<sch:param name="context_element" value="mets:amdSec/*"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute1" value="@CREATED"/>
		<sch:param name="required_attribute2" value="@fi:CREATED"/>
		<sch:param name="specifications" value="string('not: 1.5.0; 1.6.0; 1.6.1')"/>
	</sch:pattern>
        <sch:pattern id="mets_amdSec_PID" is-a="required_attribute_pattern">
                <sch:param name="context_element" value="mets:amdSec/*"/>
                <sch:param name="context_condition" value="@fi:PIDTYPE"/>
                <sch:param name="required_attribute" value="@fi:PID"/>
                <sch:param name="specifications" value="string('not: 1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>
        <sch:pattern id="mets_amdSec_PIDTYPE" is-a="required_attribute_pattern">
                <sch:param name="context_element" value="mets:amdSec/*"/>
                <sch:param name="context_condition" value="@fi:PID"/>
                <sch:param name="required_attribute" value="@fi:PIDTYPE"/>
                <sch:param name="specifications" value="string('not: 1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>

	<!-- METS internal linking, cross-check part 2: From target to link -->
	<sch:pattern id="id_references_adm">
        <sch:rule context="mets:amdSec/*">
			<sch:let name="id" value="normalize-space(@ID)"/>
			<sch:assert test="count($filelinks[contains(concat(' ', normalize-space(@ADMID), ' '), concat(' ', $id, ' '))]) &gt; 0
			or count($divlinks[contains(concat(' ', normalize-space(@ADMID), ' '), concat(' ', $id, ' '))]) &gt; 0
			or count($streamlinks[contains(concat(' ', normalize-space(@ADMID), ' '), concat(' ', $id, ' '))]) &gt; 0">
				Section containing value '<sch:value-of select="@ID"/>' in attribute '<sch:value-of select="name(@ID)"/>' in element '<sch:value-of select="name(.)"/>' requires a reference from attribute '@ADMID'.
			</sch:assert>
        </sch:rule>
	</sch:pattern>

	<!-- COMPATIBILITY WITH DEPRECATED VERSIONS -->

	<!-- Allow only given attributes -->
        <sch:pattern id="mets_amdSec_attribute_list_pre170" is-a="allowed_attribute_list_pattern">
                <sch:param name="context_element" value="mets:amdSec/*"/>
                <sch:param name="context_condition" value="normalize-space(/mets:mets/@PROFILE)='http://www.kdk.fi/kdk-mets-profile'"/>
                <sch:param name="allowed_attributes" value="@ID | @CREATED | @GROUPID | @ADMID | @STATUS | @fikdk:CREATED | @fikdk:PID | @fikdk:PIDTYPE | @xml:lang"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

	<!-- CREATED, PIDTYPE and PID in old specifications -->
        <sch:pattern id="mets_amdSec_CREATED_pre170" is-a="required_attribute_xor_attribute_pattern">
                <sch:param name="context_element" value="mets:amdSec/*"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_attribute1" value="@CREATED"/>
                <sch:param name="required_attribute2" value="@fikdk:CREATED"/>
                <sch:param name="specifications" value="string('1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>
        <sch:pattern id="mets_amdSec_PID_pre170" is-a="required_attribute_pattern">
                <sch:param name="context_element" value="mets:amdSec/*"/>
                <sch:param name="context_condition" value="@fikdk:PIDTYPE"/>
                <sch:param name="required_attribute" value="@fikdk:PID"/>
                <sch:param name="specifications" value="string('1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>
        <sch:pattern id="mets_amdSec_PIDTYPE_pre170" is-a="required_attribute_pattern">
                <sch:param name="context_element" value="mets:amdSec/*"/>
                <sch:param name="context_condition" value="@fikdk:PID"/>
                <sch:param name="required_attribute" value="@fikdk:PIDTYPE"/>
                <sch:param name="specifications" value="string('1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>
</sch:schema>
