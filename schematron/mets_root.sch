<?xml version="1.0" encoding="UTF-8"?>

<!-- pass-filter: / -->
<!-- context-filter: mets:mets -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.7.4">
	<sch:title>METS root validation</sch:title>

<!--
Validates METS root.
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

	<sch:include href="./abstracts/deprecated_value_attribute_pattern.incl"/>
        <sch:include href="./abstracts/allowed_attribute_list_pattern.incl"/>
	<sch:include href="./abstracts/disallowed_attribute_pattern.incl"/>
	<sch:include href="./abstracts/disallowed_element_pattern.incl"/>
	<sch:include href="./abstracts/required_attribute_or_attribute_pattern.incl"/>
	<sch:include href="./abstracts/required_attribute_pattern.incl"/>
	<sch:include href="./abstracts/required_element_pattern.incl"/>
	<sch:include href="./abstracts/required_max_elements_pattern.incl"/>
	<sch:include href="./abstracts/required_specification_pattern.incl"/>
	<sch:include href="./abstracts/required_values_attribute_pattern.incl"/>
	<sch:include href="./abstracts/required_nonempty_attribute_pattern.incl"/>

        <!-- Check that identifiers of PREMIS sections are unique between the sections -->
	<sch:let name="objectid" value="/mets:mets/mets:amdSec/mets:*/mets:mdWrap/mets:xmlData/premis:object/premis:objectIdentifier/premis:objectIdentifierValue"/>
        <sch:let name="eventid" value="/mets:mets/mets:amdSec/mets:*/mets:mdWrap/mets:xmlData/premis:event/premis:eventIdentifier/premis:eventIdentifierValue"/>
        <sch:let name="agentid" value="/mets:mets/mets:amdSec/mets:*/mets:mdWrap/mets:xmlData/premis:agent/premis:agentIdentifier/premis:agentIdentifierValue"/>
        <sch:let name="rightsid" value="/mets:mets/mets:amdSec/mets:*/mets:mdWrap/mets:xmlData/premis:rights/premis:rightsStatement/premis:rightsStatementIdentifier/premis:rightsStatementIdentifierValue"/>

	<!-- METS root -->
	<sch:pattern id="mets_root">
		<sch:rule context="/">
			<sch:assert test="/mets:mets">
				This is not a METS document.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- METS profiles -->
        <sch:pattern id="mets_profile" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:mets"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="context_attribute" value="@PROFILE"/>
                <sch:param name="valid_values" value="string('http://digitalpreservation.fi/mets-profiles/cultural-heritage; http://digitalpreservation.fi/mets-profiles/research-data')"/>
                <sch:param name="specifications" value="string('not: 1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>


	<!-- Allow only given attributes -->
        <sch:pattern id="mets_mets_attribute_list" is-a="allowed_attribute_list_pattern">
                <sch:param name="context_element" value="mets:mets"/>
                <sch:param name="context_condition" value="substring(normalize-space(/mets:mets/@PROFILE),0,44)='http://digitalpreservation.fi/mets-profiles'"/>
                <sch:param name="allowed_attributes" value="@xsi:schemaLocation | @PROFILE | @OBJID | @LABEL | @ID | @TYPE | @fi:CATALOG | @fi:SPECIFICATION | @fi:CONTENTID | @fi:CONTRACTID"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

	<!-- Specification attributes -->
        <sch:pattern id="mets_CATALOG_SPECIFICATION" is-a="required_attribute_or_attribute_pattern">
                <sch:param name="context_element" value="mets:mets"/>
                <sch:param name="context_condition" value="substring(@PROFILE,0,44)='http://digitalpreservation.fi/mets-profiles'"/>
                <sch:param name="required_attribute1" value="@fi:CATALOG"/>
                <sch:param name="required_attribute2" value="@fi:SPECIFICATION"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="mets_specification" is-a="required_specification_pattern">
                <sch:param name="required_condition" value="normalize-space(@fi:CATALOG) = normalize-space(@fi:SPECIFICATION)"/>
        </sch:pattern>

	<!-- METS root attributes -->
	<sch:pattern id="mets_OBJID" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:mets"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@OBJID"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_OBJID_value" is-a="required_nonempty_attribute_pattern">
		<sch:param name="context_element" value="mets:mets"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@OBJID"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
        <sch:pattern id="mets_CONTRACTID" is-a="required_attribute_pattern">
                <sch:param name="context_element" value="mets:mets"/>
                <sch:param name="context_condition" value="substring(normalize-space(/mets:mets/@PROFILE),0,44)='http://digitalpreservation.fi/mets-profiles'"/>
                <sch:param name="required_attribute" value="@fi:CONTRACTID"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="mets_CONTRACTID_value" is-a="required_nonempty_attribute_pattern">
                <sch:param name="context_element" value="mets:mets"/>
                <sch:param name="context_condition" value="substring(normalize-space(/mets:mets/@PROFILE),0,44)='http://digitalpreservation.fi/mets-profiles'"/>
                <sch:param name="context_attribute" value="@fi:CONTRACTID"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

        <sch:pattern id="mets_CONTENTID_value" is-a="required_nonempty_attribute_pattern">
                <sch:param name="context_element" value="mets:mets"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="context_attribute" value="@fi:CONTENTID"/>
                <sch:param name="specifications" value="string('not: 1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>

	<sch:pattern id="mets_PROFILE" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:mets"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@PROFILE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- METS root elements -->
	<sch:pattern id="mets_metsHdr" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:mets"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mets:metsHdr"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_dmdSec" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:mets"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mets:dmdSec"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_amdSec" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:mets"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mets:amdSec"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_amdSec_amdSec_max" is-a="required_max_elements_pattern">
		<sch:param name="context_element" value="mets:mets"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mets:amdSec"/>
		<sch:param name="num" value="1"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_structMap" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:mets"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mets:structMap"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_structLink" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:mets"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mets:structLink"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_behaviorSec" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:mets"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mets:behaviorSec"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

        <!-- Standard portfolio schemas -->
        <sch:pattern id="mets_descriptive_exists" is-a="required_metadata_pattern">
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_metadata" value="mets:dmdSec/mets:mdWrap[@MDTYPE='LIDO' or @MDTYPE='EAC-CPF' or @MDTYPE='EAD' or @OTHERMDTYPE='EAD3'
                or @MDTYPE='VRA' or @MDTYPE='MODS' or @MDTYPE='MARC' or @MDTYPE='DC' or @MDTYPE='DDI' or @OTHERMDTYPE='DATACITE']"/>
                <sch:param name="metadata_name" value="string('Standard portfolio descriptive')"/>
                <sch:param name="specifications" value="string('not: 1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>
        <sch:pattern id="mets_object_exists" is-a="required_metadata_pattern">
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_metadata" value="mets:amdSec/mets:techMD/mets:mdWrap[@MDTYPE='PREMIS:OBJECT']"/>
                <sch:param name="metadata_name" value="string('PREMIS:OBJECT')"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="mets_event_exists" is-a="required_metadata_pattern">
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_metadata" value="mets:amdSec/mets:digiprovMD/mets:mdWrap[@MDTYPE='PREMIS:EVENT']"/>
                <sch:param name="metadata_name" value="string('PREMIS:EVENT')"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

	<!-- Check that OBJID attribute is unique with METS internal IDs (except for CONTENTID) -->
	<sch:pattern id="unique_objid">
		<sch:rule context="mets:mets[@OBJID]">
		    <sch:let name="objid" value="normalize-space(@OBJID)"/>
		    <sch:let name="same_id_count" value="count(@ID[.=$objid] | ./mets:*/@ID[.=$objid] | ./mets:*/mets:*/@ID[.=$objid] | ./mets:*/mets:*/mets:*/@ID[.=$objid] | ./mets:fileSec/mets:fileGrp/mets:file/*/@ID[.=$objid] | ./mets:structMap//@ID[.=$objid])"/>
			<sch:assert test="$same_id_count = 0">
				Value '<sch:value-of select="@OBJID"/>' in attribute '<sch:value-of select="name(@OBJID)"/>' in element '<sch:name/>' is required to be unique. Another attribute 'ID' with the same value exists.
			</sch:assert>
                        <sch:assert test="not($objid = normalize-space(@fi:CONTRACTID)) or not(@fi:CONTRACTID)">
                                Value '<sch:value-of select="@OBJID"/>' in attribute '<sch:value-of select="name(@OBJID)"/>' in element '<sch:name/>' is required to be unique. Another attribute '<sch:value-of select="name(@fi:CONTRACTID)"/>' with the same value exists.
                        </sch:assert>
		</sch:rule>
	</sch:pattern>


        <!-- Check that identifiers of PREMIS sections are unique between the sections -->
        <sch:pattern id="premis_identifierValue_unique">
                <sch:rule context="mets:mets">
                         <sch:let name="unique_elements" value="$objectid | $eventid | $agentid | $rightsid"/>
                        <sch:assert test="count(sets:distinct($unique_elements)) = count($unique_elements)">
                                Value '<sch:value-of select="normalize-space(sets:difference($unique_elements, sets:distinct($unique_elements)))"/>' in the elements 'premis:objectIdentifierValue; premis:eventIdentifierValue; premis:agentIdentifierValue; premis:rightsStatementIdentifierValue' is required to be unique.
                        </sch:assert>
                </sch:rule>
        </sch:pattern>


	<!-- COMPATIBILITY WITH DEPRECATED VERSIONS -->

        <!-- METS profile -->
        <sch:pattern id="mets_profile_pre170" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:mets"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="context_attribute" value="@PROFILE"/>
                <sch:param name="valid_values" value="string('http://www.kdk.fi/kdk-mets-profile')"/>
                <sch:param name="specifications" value="string('1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>
        <sch:pattern id="mets_profile_deprecated_pre170" is-a="deprecated_value_attribute_pattern">
                <sch:param name="context_element" value="mets:mets"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="context_attribute" value="@PROFILE"/>
                <sch:param name="deprecated_value" value="string('http://www.kdk.fi/kdk-mets-profile')"/>
                <sch:param name="valid_values" value="string('http://digitalpreservation.fi/mets-profiles/cultural-heritage; http://digitalpreservation.fi/mets-profiles/research-data')"/>
                <sch:param name="specifications" value="string('1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>

	<!-- Allow only given attributes -->
        <sch:pattern id="mets_mets_attribute_list_pre170" is-a="allowed_attribute_list_pattern">
                <sch:param name="context_element" value="mets:mets"/>
                <sch:param name="context_condition" value="normalize-space(/mets:mets/@PROFILE)='http://www.kdk.fi/kdk-mets-profile'"/>
                <sch:param name="allowed_attributes" value="@xsi:schemaLocation | @PROFILE | @OBJID | @LABEL | @ID | @TYPE | @fikdk:CATALOG | @fikdk:SPECIFICATION | @fikdk:CONTENTID"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

        <!-- Specification attributes -->
        <sch:pattern id="mets_CATALOG_SPECIFICATION_pre170" is-a="required_attribute_or_attribute_pattern">
                <sch:param name="context_element" value="mets:mets"/>
                <sch:param name="context_condition" value="@PROFILE='http://www.kdk.fi/kdk-mets-profile'"/>
                <sch:param name="required_attribute1" value="@fikdk:CATALOG"/>
                <sch:param name="required_attribute2" value="@fikdk:SPECIFICATION"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="mets_specification_pre170" is-a="required_specification_pattern">
                <sch:param name="required_condition" value="normalize-space(@fikdk:CATALOG) = normalize-space(@fikdk:SPECIFICATION)
                        or (normalize-space(@fikdk:CATALOG)='1.6.0' and normalize-space(@fikdk:SPECIFICATION)='1.6.1')"/>
        </sch:pattern>

	<!-- CONTENTID in old specifications -->
        <sch:pattern id="mets_CONTENTID_value_pre170" is-a="required_nonempty_attribute_pattern">
                <sch:param name="context_element" value="mets:mets"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="context_attribute" value="@fikdk:CONTENTID"/>
                <sch:param name="specifications" value="string('1.6.0; 1.6.1')"/>
        </sch:pattern>
        <sch:pattern id="mets_no_CONTENTID_150" is-a="disallowed_attribute_pattern">
                <sch:param name="context_element" value="mets:mets"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_attribute" value="@fikdk:CONTENTID"/>
                <sch:param name="specifications" value="string('1.5.0')"/>
        </sch:pattern>
        <sch:pattern id="mets_no_CONTENTID_pre170" is-a="disallowed_attribute_pattern">
                <sch:param name="context_element" value="mets:mets"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_attribute" value="@fi:CONTENTID"/>
                <sch:param name="specifications" value="string('1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>

        <!-- Standard portfolio descriptive metadata formats with old specifications -->
        <sch:pattern id="mets_descriptive_exists_pre170" is-a="required_metadata_pattern">
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_metadata" value="mets:dmdSec/mets:mdWrap[@MDTYPE='LIDO' or @MDTYPE='EAC-CPF' or @MDTYPE='EAD' or @OTHERMDTYPE='EAD3'
                or @MDTYPE='VRA' or @MDTYPE='MODS' or @MDTYPE='MARC' or @MDTYPE='DC' or @MDTYPE='DDI']"/>
                <sch:param name="metadata_name" value="string('Standard portfolio descriptive')"/>
                <sch:param name="specifications" value="string('1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>

</sch:schema>
