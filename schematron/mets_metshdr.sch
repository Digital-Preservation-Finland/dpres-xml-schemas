<?xml version="1.0" encoding="UTF-8"?>

<!-- pass-filter: /mets:mets/mets:metsHdr -->
<!-- context-filter: mets:metsHdr|mets:agent -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.7.3">
	<sch:title>METS metsHdr validation</sch:title>

<!--
Validates metsHdr.
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
	<sch:include href="./abstracts/disallowed_element_pattern.incl"/>
	<sch:include href="./abstracts/disallowed_attribute_pattern.incl"/>
	<sch:include href="./abstracts/required_attribute_pattern.incl"/>
	<sch:include href="./abstracts/required_element_pattern.incl"/>
	<sch:include href="./abstracts/required_values_attribute_pattern.incl"/>
	<sch:include href="./abstracts/required_agent_pattern.incl"/>

	<!-- Allow only given attributes -->
        <sch:pattern id="mets_metsHdr_attribute_list" is-a="allowed_attribute_list_pattern">
                <sch:param name="context_element" value="mets:metsHdr"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="allowed_attributes" value="@CREATEDATE | @LASTMODDATE | @RECORDSTATUS | @ID | @ADMID"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

	<!-- METS Header attributes -->
	<sch:pattern id="mets_metsHdr_CREATEDATE" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:metsHdr"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@CREATEDATE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_RECORDSTATUS_values_csc" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:metsHdr"/>
		<sch:param name="context_condition" value="count(mets:agent)=1 and normalize-space(mets:agent/mets:name)='CSC - IT Center for Science Ltd.'"/>
		<sch:param name="context_attribute" value="@RECORDSTATUS"/>
		<sch:param name="valid_values" value="string('submission; update; dissemination')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
        <sch:pattern id="mets_RECORDSTATUS_values" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:metsHdr"/>
                <sch:param name="context_condition" value="count(mets:agent)!=1 or normalize-space(mets:agent/mets:name)!='CSC - IT Center for Science Ltd.'"/>
                <sch:param name="context_attribute" value="@RECORDSTATUS"/>
                <sch:param name="valid_values" value="string('submission; update')"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

	<!-- METS Header agent -->
	<sch:pattern id="mets_metsHdr_agent" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:metsHdr"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mets:agent"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_agent_ROLE" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:metsHdr/mets:agent"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@ROLE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_agent_TYPE" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:metsHdr/mets:agent"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@TYPE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
        <sch:pattern id="mets_agent_OTHERTYPE" is-a="required_attribute_pattern">
                <sch:param name="context_element" value="mets:metsHdr/mets:agent"/>
                <sch:param name="context_condition" value="normalize-space(@TYPE)='OTHER'"/>
                <sch:param name="required_attribute" value="@OTHERTYPE"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
	<sch:pattern id="mets_agent_creator" is-a="required_agent_pattern">
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="role" value="string('CREATOR')"/>
                <sch:param name="type" value="string('')"/>
                <sch:param name="specifications" value="string('not: 1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>
        <sch:pattern id="mets_no_note_attributes" is-a="disallowed_attribute_pattern">
                <sch:param name="context_element" value="mets:metsHdr/mets:agent/mets:note"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_attribute" value="@*"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

        <!-- METS Header elements -->
	<sch:pattern id="mets_metsHdr_altRecordID" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:metsHdr"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mets:altRecordID"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- COMPATIBILITY WITH DEPRECATED VERSIONS -->
        <sch:pattern id="mets_agent_creator_pre170" is-a="required_agent_pattern">
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="role" value="string('CREATOR')"/>
                <sch:param name="type" value="string('ORGANIZATION')"/>
                <sch:param name="specifications" value="string('1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>

</sch:schema>
