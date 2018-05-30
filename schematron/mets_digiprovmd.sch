<?xml version="1.0" encoding="UTF-8"?>

<!-- pass-filter: /mets:mets/mets:amdSec/mets:digiprovMD -->
<!-- context-filter: mets:digiprovMD|mets:mdWrap|mets:mdRef|mets:xmlData -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.7.0">
	<sch:title>METS digiprovMD validation</sch:title>

<!--
Validates METS digiprovMD.
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

	<sch:include href="./abstracts/required_attribute_pattern.incl"/>
	<sch:include href="./abstracts/required_element_or_element_pattern.incl"/>
	<sch:include href="./abstracts/required_values_attribute_pattern.incl"/>
        <sch:include href="./abstracts/disallowed_element_pattern.incl"/>
        <sch:include href="./abstracts/required_metadata_pattern.incl"/>

	<!-- mdWrap and mdRef elements -->
	<sch:pattern id="mets_digiprovMD_mdWrap_mdRef" is-a="required_element_or_element_pattern">
		<sch:param name="context_element" value="mets:digiprovMD"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element1" value="mets:mdWrap"/>
		<sch:param name="required_element2" value="mets:mdRef"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- digiprovMD MDTYPE -->
	<sch:pattern id="mets_digiprovMD_MDTYPE" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdWrap"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@MDTYPE"/>
		<sch:param name="valid_values" value="string('PREMIS:OBJECT; PREMIS:EVENT; PREMIS:AGENT; OTHER')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- Attribute MDTYPE version values -->
	<sch:pattern id="mets_digiprovMD_MDTYPEVERSION_values_OBJECT" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdWrap"/>
		<sch:param name="context_condition" value="normalize-space(@MDTYPE)='PREMIS:OBJECT'"/>
		<sch:param name="context_attribute" value="@MDTYPEVERSION"/>
		<sch:param name="valid_values" value="string('2.2; 2.3')"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4; 1.5.0')"/>
	</sch:pattern>
	<sch:pattern id="mets_digiprovMD_MDTYPEVERSION_values_EVENT" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdWrap"/>
		<sch:param name="context_condition" value="normalize-space(@MDTYPE)='PREMIS:EVENT'"/>
		<sch:param name="context_attribute" value="@MDTYPEVERSION"/>
		<sch:param name="valid_values" value="string('2.2; 2.3')"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4; 1.5.0')"/>
	</sch:pattern>
	<sch:pattern id="mets_digiprovMD_MDTYPEVERSION_values_AGENT" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdWrap"/>
		<sch:param name="context_condition" value="normalize-space(@MDTYPE)='PREMIS:AGENT'"/>
		<sch:param name="context_attribute" value="@MDTYPEVERSION"/>
		<sch:param name="valid_values" value="string('2.2; 2.3')"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4; 1.5.0')"/>
	</sch:pattern>

	<!-- mdRef attributes -->
	<sch:pattern id="mets_mdRef_OTHERMDTYPE" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdRef"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@OTHERMDTYPE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mdRef_OTHERLOCTYPE" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdRef"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@OTHERLOCTYPE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mdRef_href" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdRef"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@xlink:href"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mdRef_type" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdRef"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@xlink:type"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mdRef_CHECKSUM" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdRef"/>
		<sch:param name="context_condition" value="@CHECKSUMTYPE"/>
		<sch:param name="required_attribute" value="@CHECKSUM"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mdRef_CHECKSUMTYPE" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdRef"/>
		<sch:param name="context_condition" value="@CHECKSUM"/>
		<sch:param name="required_attribute" value="@CHECKSUMTYPE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- mdRef attribute values -->
	<sch:pattern id="mets_mdRef_MDTYPE_values" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdRef"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@MDTYPE"/>
		<sch:param name="valid_values" value="string('OTHER')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
        <sch:pattern id="mets_mdRef_OTHERMDTYPE_values" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:digiprovMD/mets:mdRef"/>
                <sch:param name="context_condition" value="substring(normalize-space(/mets:mets/@PROFILE),0,44)='http://digitalpreservation.fi/mets-profiles'"/>
                <sch:param name="context_attribute" value="@OTHERMDTYPE"/>
                <sch:param name="valid_values" value="string('FiPreservationPlan')"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
	<sch:pattern id="mets_mdRef_LOCTYPE_values" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdRef"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@LOCTYPE"/>
		<sch:param name="valid_values" value="string('OTHER')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mdRef_OTHERLOCTYPE_values" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdRef"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@OTHERLOCTYPE"/>
		<sch:param name="valid_values" value="string('PreservationPlanID')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mdRef_type_values" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdRef"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@xlink:type"/>
		<sch:param name="valid_values" value="string('simple')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

        <!-- Known descriptive, rights, or technical metadata can not be used inside wrong section -->
        <sch:pattern id="digiprovmd_no_rights" is-a="disallowed_element_pattern">
                <sch:param name="context_element" value="mets:digiprovMD/mets:mdWrap/mets:xmlData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_element" value="premis:rights"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="digiprovmd_no_tech" is-a="disallowed_element_pattern">
                <sch:param name="context_element" value="mets:digiprovMD/mets:mdWrap/mets:xmlData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_element" value="addml:* or textmd:* or textmd_kdk:* or mix:* or audiomd:* or videomd:*"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="digiprovmd_only_representation" is-a="disallowed_element_pattern">
                <sch:param name="context_element" value="mets:digiprovMD/mets:mdWrap/mets:xmlData"/>
                <sch:param name="context_condition" value="not(normalize-space(premis:object/@xsi:type)='premis:representation')"/>
                <sch:param name="disallowed_element" value="premis:object"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="digiprovmd_no_descriptive" is-a="disallowed_element_pattern">
                <sch:param name="context_element" value="mets:digiprovMD/mets:mdWrap/mets:xmlData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_element" value="datacite:* or lido:* or ead:* or ead3:* or vra:* or mods:* or marc21:* or dc:* or dcterms:* or dcmitype:* or ddilc32:* or ddilc31:* or ddicb25:* or ddicb21:*"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>


	<!-- COMPATIBILITY WITH DEPRECATED VERSIONS -->

	<!-- PREMIS 2.1 in specification 1.5.0 -->
        <sch:pattern id="mets15_digiprovMD_MDTYPEVERSION_values_OBJECT" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:digiprovMD/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='PREMIS:OBJECT'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('2.1; 2.2; 2.3')"/>
                <sch:param name="specifications" value="string('1.5.0')"/>
        </sch:pattern>
        <sch:pattern id="mets15_digiprovMD_MDTYPEVERSION_values_EVENT" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:digiprovMD/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='PREMIS:EVENT'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('2.1; 2.2; 2.3')"/>
                <sch:param name="specifications" value="string('1.5.0')"/>
        </sch:pattern>
        <sch:pattern id="mets15_digiprovMD_MDTYPEVERSION_values_AGENT" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:digiprovMD/mets:mdWrap"/>
                <sch:param name="context_condition" value="normalize-space(@MDTYPE)='PREMIS:AGENT'"/>
                <sch:param name="context_attribute" value="@MDTYPEVERSION"/>
                <sch:param name="valid_values" value="string('2.1; 2.2; 2.3')"/>
                <sch:param name="specifications" value="string('1.5.0')"/>
        </sch:pattern>

	<!-- KDKPreservationPlan in old specifications -->
        <sch:pattern id="mets_mdRef_OTHERMDTYPE_values_old" is-a="required_values_attribute_pattern">
                <sch:param name="context_element" value="mets:digiprovMD/mets:mdRef"/>
                <sch:param name="context_condition" value="/mets:mets/@PROFILE='http://www.kdk.fi/kdk-mets-profile'"/>
                <sch:param name="context_attribute" value="@OTHERMDTYPE"/>
                <sch:param name="valid_values" value="string('KDKPreservationPlan')"/>
                <sch:param name="specifications" value="string('1.4.1; 1.4; 1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>
</sch:schema>
