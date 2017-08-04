<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.7.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:func="http://exslt.org/functions"
queryBinding="xslt">
	<sch:title>METS Cultural data profile validation</sch:title>

<!--
Validates METS cultural data profile and structmap.
-->
	
	<sch:ns prefix="mets" uri="http://www.loc.gov/METS/"/>
	<sch:ns prefix="fi" uri="http://www.kdk.fi/standards/mets/kdk-extensions"/>
	<sch:ns prefix="exsl" uri="http://exslt.org/common"/>
	<sch:ns prefix="sets" uri="http://exslt.org/sets"/>
	<sch:ns prefix="str" uri="http://exslt.org/strings"/>
	

	<sch:include href="./abstracts/parameter_vocabulary_check.incl"/>
	<sch:include href="./abstracts/required_values_attribute_pattern.incl"/>
	<sch:include href="./abstracts/required_element_pattern.incl"/>
	<sch:include href="./abstracts/disallowed_element_pattern.incl"/>

	<!-- Profile names -->
    <sch:let name="culture_profiles" value="exsl:node-set('http://www.kdk.fi/kdk-mets-profile')"/>

    <!-- Parameter names -->
    <sch:let name="culture_profile_params" value=""/>

	<sch:let name="given_profile" value="str:split(normalize-space(/mets:mets/@PROFILE), '?')"/>

	<sch:pattern id="profile_parameter_names">
		<sch:rule context="mets:mets">
			<sch:assert test="count($research_profile_params) = count(sets:distinct(str:tokenize($given_profile[2], '&amp;=')[position() mod 2 = 1] | $research_profile_params))
			or not(count($research_profiles) = count(sets:distinct(exsl:node-set($given_profile[1]) | $research_profiles)))">
				Unknown parameter name in attribute 'PROFILE'.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

        <sch:pattern id="mets_CATALOG_values" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:mets"/>
                <sch:param name="context_attribute" value="@fi:CATALOG"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="valid_values" value="string('1.5.0; 1.6.0; 1.7.0')"/>
                
		<sch:param name="profiles" value="exsl:node-set('')"/>
		<sch:param name="specifications" value="string('')"/>
                <sch:param name="profiles" value="$culture_profiles"/>
        </sch:pattern>
        <sch:pattern id="mets_SPECIFICATION_values" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:mets"/>
                <sch:param name="context_attribute" value="@fi:SPECIFICATION"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="valid_values" value="string('1.5.0; 1.6.0; 1.6.1; 1.7.0')"/>
                
		<sch:param name="profiles" value="exsl:node-set('')"/>
		<sch:param name="specifications" value="string('')"/>
                <sch:param name="profiles" value="$culture_profiles"/>
        </sch:pattern>


</sch:schema>

