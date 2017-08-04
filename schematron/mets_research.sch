<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.7.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:func="http://exslt.org/functions"
queryBinding="xslt">
	<sch:title>METS Research data profile validation</sch:title>

<!--
Validates METS reseach data profile and structmap.
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
    <sch:let name="research_profiles" value="
    	exsl:node-set('http://www.avointiede.fi/att-mets-profile') 
		| exsl:node-set('http://www.avointiede.fi/att-midterm-mets-profile')"/>

    <!-- Parameter names -->
    <sch:let name="research_profile_params" value="
    	exsl:node-set('dissemination_service')"/>

	<sch:let name="given_profile" value="str:split(normalize-space(/mets:mets/@PROFILE), '?')"/>

	<sch:pattern id="profile_parameter_names">
		<sch:rule context="mets:mets">
			<sch:assert test="count($research_profile_params) = count(sets:distinct(str:tokenize($given_profile[2], '&amp;=')[position() mod 2 = 1] | $research_profile_params))
			or not(count($research_profiles) = count(sets:distinct(exsl:node-set($given_profile[1]) | $research_profiles)))">
				Unknown parameter name in attribute 'PROFILE'.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- Check dissemination_service parameter -->
	<sch:pattern id="profile_dissemination_service_check" is-a="parameter_vocabulary_check">
		<sch:param name="context" value="/mets:mets/@PROFILE"/>	
		<sch:param name="check_parameter" value="string('dissemination_service')"/>
		<sch:param name="required" value="true()"/>
		<sch:param name="given_params" value="$given_profile[2]"/>
		<sch:param name="allowed_params" value="$research_profile_params"/>
		<sch:param name="allowed_values" value="exsl:node-set('yes') | exsl:node-set('no')"/>
		<sch:param name="profiles" value="$research_profiles"/>
		<sch:param name="profiles" value="exsl:node-set('')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

        <sch:pattern id="mets_CATALOG_values" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:mets"/>
                <sch:param name="context_attribute" value="@fi:CATALOG"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="valid_values" value="string('1.7.0')"/>
		<sch:param name="profiles" value="exsl:node-set('')"/>
		<sch:param name="specifications" value="string('')"/>
                <sch:param name="profiles" value="$research_profiles"/>
        </sch:pattern>
        <sch:pattern id="mets_SPECIFICATION_values" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:mets"/>
                <sch:param name="context_attribute" value="@fi:SPECIFICATION"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="valid_values" value="string('1.7.0')"/>
		<sch:param name="profiles" value="exsl:node-set('')"/>
		<sch:param name="specifications" value="string('')"/>
                <sch:param name="profiles" value="$research_profiles"/>
        </sch:pattern>

    <!-- Require one and only one Dataset structMap -->
	<sch:pattern id="mets_structmap_dataset">
		<sch:rule context="mets:mets">
			<sch:assert test="count(mets:structMap/mets:div[@TYPE='Dataset'])=1
			or not(count($research_profiles) = count(sets:distinct(exsl:node-set($given_profile[1]) | $research_profiles)))">
				One (and only one) such structMap is required, where the bottom div TYPE is 'Dataset'.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- Allow only divs /w vocabulary in the first level (after Dataset div) -->
	<sch:pattern id="mets_structmap_dataset_div" is-a="required_element_pattern">
        <sch:param name="context_element" value="mets:structMap/mets:div"/>
		<sch:param name="required_element" value="mets:div"/>
		<sch:param name="context_condition" value="@TYPE='Dataset'"/>
		<sch:param name="profiles" value="exsl:node-set('')"/>
		<sch:param name="specifications" value="string('')"/>
		<sch:param name="profiles" value="$research_profiles"/>	
	</sch:pattern>
	<sch:pattern id="mets_structmap_dataset_fptr" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:structMap/mets:div"/>
		<sch:param name="disallowed_element" value="mets:fptr"/>
		<sch:param name="context_condition" value="@TYPE='Dataset'"/>
		<sch:param name="profiles" value="exsl:node-set('')"/>
		<sch:param name="specifications" value="string('')"/>
		<sch:param name="profiles" value="$research_profiles"/>		
	</sch:pattern>
	<sch:pattern id="mets_structmap_dataset_mptr" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:structMap/mets:div"/>
		<sch:param name="disallowed_element" value="mets:mptr"/>
		<sch:param name="context_condition" value="@TYPE='Dataset'"/>
		<sch:param name="profiles" value="exsl:node-set('')"/>
		<sch:param name="specifications" value="string('')"/>
		<sch:param name="profiles" value="$research_profiles"/>		
	</sch:pattern>
	<sch:pattern id="mets_structmap_dataset_div_type" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:structMap/mets:div[@TYPE='Dataset']/mets:div"/>
		<sch:param name="context_attribute" value="@TYPE"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="valid_values" value="string('Data files; Documentation files; Publication files; Machine-readable metadata; Access and use rights files; Software files')"/>
		<sch:param name="profiles" value="exsl:node-set('')"/>
		<sch:param name="specifications" value="string('')"/>
		<sch:param name="profiles" value="$research_profiles"/>		
	</sch:pattern>

    <!-- Disallow mptr in second level -->
	<sch:pattern id="mets_structmap_dataset_div_mptr" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:structMap/mets:div[@TYPE='Dataset']/mets:div"/>
		<sch:param name="disallowed_element" value="mets:mptr"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="profiles" value="exsl:node-set('')"/>
		<sch:param name="specifications" value="string('')"/>
		<sch:param name="profiles" value="$research_profiles"/>		
	</sch:pattern>

    <!-- Require divs and only divs /w vocabulary in the second level, when first level is Documentation files -->
	<sch:pattern id="mets_structmap_dataset_docs_div" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:structMap/mets:div[@TYPE='Dataset']/mets:div"/>
		<sch:param name="required_element" value="mets:div"/>
		<sch:param name="context_condition" value="@TYPE='Documentation files'"/>
		<sch:param name="profiles" value="exsl:node-set('')"/>
		<sch:param name="specifications" value="string('')"/>
		<sch:param name="profiles" value="$research_profiles"/>		
	</sch:pattern>
	<sch:pattern id="mets_structmap_dataset_docs_fptr" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:structMap/mets:div[@TYPE='Dataset']/mets:div"/>
		<sch:param name="disallowed_element" value="mets:fptr"/>
		<sch:param name="context_condition" value="@TYPE='Documentation files'"/>
		<sch:param name="profiles" value="exsl:node-set('')"/>
		<sch:param name="specifications" value="string('')"/>
		<sch:param name="profiles" value="$research_profiles"/>		
	</sch:pattern>
	<sch:pattern id="mets_structmap_dataset_docs_type" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:structMap/mets:div[@TYPE='Dataset']/mets:div[@TYPE='Documentation files']/mets:div"/>
		<sch:param name="context_attribute" value="@TYPE"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="valid_values" value="string('Observations notebook; Configuration files; Method files; Other files')"/>
		<sch:param name="profiles" value="exsl:node-set('')"/>
		<sch:param name="specifications" value="string('')"/>
		<sch:param name="profiles" value="$research_profiles"/>		
	</sch:pattern>

    <!-- Require fptrs and disallow divs in the second level, when first level is NOT Documentation files -->
	<sch:pattern id="mets_structmap_dataset_div_fptr" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:structMap/mets:div[@TYPE='Dataset']/mets:div"/>
		<sch:param name="required_element" value="mets:fptr"/>
		<sch:param name="context_condition" value="@TYPE!='Documentation files'"/>
		<sch:param name="profiles" value="exsl:node-set('')"/>
		<sch:param name="specifications" value="string('')"/>
		<sch:param name="profiles" value="$research_profiles"/>		
	</sch:pattern>
	<sch:pattern id="mets_structmap_dataset_div_div" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:structMap/mets:div[@TYPE='Dataset']/mets:div"/>
		<sch:param name="disallowed_element" value="mets:div"/>
		<sch:param name="context_condition" value="@TYPE!='Documentation files'"/>
		<sch:param name="profiles" value="exsl:node-set('')"/>
		<sch:param name="specifications" value="string('')"/>
		<sch:param name="profiles" value="$research_profiles"/>		
	</sch:pattern>

    <!-- Require fptrs and only fptrs in the third level, when first level is Documentation files -->
	<sch:pattern id="mets_structmap_dataset_docs_div_fptr" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:structMap/mets:div[@TYPE='Dataset']/mets:div[@TYPE='Documentation files']/mets:div"/>
		<sch:param name="required_element" value="mets:fptr"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="profiles" value="exsl:node-set('')"/>
		<sch:param name="specifications" value="string('')"/>
		<sch:param name="profiles" value="$research_profiles"/>		
	</sch:pattern>
	<sch:pattern id="mets_structmap_dataset_docs_div_div" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:structMap/mets:div[@TYPE='Dataset']/mets:div[@TYPE='Documentation files']/mets:div"/>
		<sch:param name="disallowed_element" value="mets:div"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="profiles" value="exsl:node-set('')"/>
		<sch:param name="specifications" value="string('')"/>
		<sch:param name="profiles" value="$research_profiles"/>		
	</sch:pattern> 
	<sch:pattern id="mets_structmap_dataset_docs_div_mptr" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:structMap/mets:div[@TYPE='Dataset']/mets:div[@TYPE='Documentation files']/mets:div"/>
		<sch:param name="disallowed_element" value="mets:mptr"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="profiles" value="exsl:node-set('')"/>
		<sch:param name="specifications" value="string('')"/>
		<sch:param name="profiles" value="$research_profiles"/>	
	</sch:pattern>

</sch:schema>

