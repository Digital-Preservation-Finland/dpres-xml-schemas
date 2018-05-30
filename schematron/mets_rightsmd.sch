<?xml version="1.0" encoding="UTF-8"?>

<!-- pass-filter: /mets:mets/mets:amdSec/mets:rightsMD -->
<!-- context-filter: mets:rightsMD|mets:mdWrap|mets:xmlData -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.7.0">
	<sch:title>METS rightsMD validation</sch:title>

<!--
Validates METS rightsMD.
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
        <sch:ns prefix="textmd" uri="info:lc/xmlns/textMD-v3"/>
        <sch:ns prefix="textmd_kdk" uri="http://www.kdk.fi/standards/textmd"/>
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
        <sch:ns prefix="ddilc32" uri="ddi:instance:3_2"/>
        <sch:ns prefix="ddilc31" uri="ddi:instance:3_1"/>
        <sch:ns prefix="ddicb25" uri="ddi:codebook:2_5"/>
        <sch:ns prefix="ddicb21" uri="http://www.icpsr.umich.edu/DDI"/>
        <sch:ns prefix="datacite" uri="http://datacite.org/schema/kernel-4"/>

	<sch:include href="./abstracts/disallowed_element_pattern.incl"/>
	<sch:include href="./abstracts/required_element_pattern.incl"/>
	<sch:include href="./abstracts/required_values_attribute_pattern.incl"/>
        <sch:include href="./abstracts/deprecated_element_pattern.incl"/>

	<sch:pattern id="mets_rightsMD_mdWrap" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:rightsMD"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mets:mdWrap"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_rightsMD_mdRef" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:rightsMD"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mets:mdRef"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_rightsMD_MDTYPE" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:rightsMD/mets:mdWrap"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@MDTYPE"/>
		<sch:param name="valid_values" value="string('PREMIS:RIGHTS; OTHER')"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>

	<!-- Attribute MDTYPE version values -->
	<sch:pattern id="mets_rightsMD_MDTYPEVERSION_values_RIGHTS" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:rightsMD/mets:mdWrap"/>
		<sch:param name="context_condition" value="normalize-space(@MDTYPE)='PREMIS:RIGHTS'"/>
		<sch:param name="context_attribute" value="@MDTYPEVERSION"/>
		<sch:param name="valid_values" value="string('2.2; 2.3')"/>
                <sch:param name="specifications" value="string('not: 1.4.1; 1.4; 1.5.0')"/>
	</sch:pattern>

        <!-- Known descriptive, technical, or provenance metadata can not be used inside wrong section -->
        <sch:pattern id="rights_no_tech" is-a="disallowed_element_pattern">
                <sch:param name="context_element" value="mets:rightsMD/mets:mdWrap/mets:xmlData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_element" value="premis:object or addml:* or textmd:* or textmd_kdk:* or mix:* or audiomd:* or videomd:*"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="rights_no_digiprov" is-a="disallowed_element_pattern">
                <sch:param name="context_element" value="mets:rightsMD/mets:mdWrap/mets:xmlData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_element" value="premis:agent or premis:event"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="rights_no_descriptive" is-a="disallowed_element_pattern">
                <sch:param name="context_element" value="mets:rightsMD/mets:mdWrap/mets:xmlData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_element" value="datacite:* or lido:* or ead:* or ead3:* or vra:* or mods:* or marc21:* or dc:* or dcterms:* or dcmitype:* or ddilc32:* or ddilc31:* or ddicb25:* or ddicb21:*"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

	<!-- COMPATIBILITY WITH DEPRECATED VERSIONS -->

	<!-- METSRIGHTS in specification 1.4 -->
        <sch:pattern id="mets14_rightsMD_MDTYPE" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:rightsMD/mets:mdWrap"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="context_attribute" value="@MDTYPE"/>
                <sch:param name="valid_values" value="string('METSRIGHTS; PREMIS:RIGHTS; OTHER')"/>
                <sch:param name="specifications" value="string('1.4.1; 1.4')"/>
        </sch:pattern>

	<!-- PREMIS 2.1 in specification 1.5.0 -->
        <sch:pattern id="mets15_rightsMD_MDTYPEVERSION_values_RIGHTS" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:rightsMD/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='PREMIS:RIGHTS'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('2.1; 2.2; 2.3')"/>
                <sch:param name="specifications" value="string('1.5.0')"/>
        </sch:pattern>

        <!-- Notify deprecation of using rightsStatement as root element in rightsMD, in specification 1.5.0 -->
        <sch:pattern id="mets_deprecated_rightsStatement" is-a="deprecated_element_pattern">
                <sch:param name="context_element" value="mets:rightsMD/mets:mdWrap/mets:xmlData"/>
                <sch:param name="context_condition" value="../@MDTYPE='PREMIS:RIGHTS'"/>
                <sch:param name="deprecated_element" value="premis:rightsStatement"/>
                <sch:param name="specifications" value="string('1.5.0')"/>
        </sch:pattern>

</sch:schema>
