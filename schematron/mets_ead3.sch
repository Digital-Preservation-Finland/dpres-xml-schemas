<?xml version="1.0" encoding="UTF-8"?>

<!-- pass-filter: /mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/ead3:ead -->
<!-- context-filter: ead3:* -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.7.0">
	<sch:title>EAD3 metadata validation</sch:title>

<!--
Validates EAD3 metadata.
-->

	<sch:ns prefix="mets" uri="http://www.loc.gov/METS/"/>
	<sch:ns prefix="fikdk" uri="http://www.kdk.fi/standards/mets/kdk-extensions"/>
        <sch:ns prefix="fi" uri="http://digitalpreservation.fi/schemas/mets/fi-extensions"/>
	<sch:ns prefix="ead3" uri="http://ead3.archivists.org/schema/"/>
	<sch:ns prefix="exsl" uri="http://exslt.org/common"/>
	<sch:ns prefix="sets" uri="http://exslt.org/sets"/>
	<sch:ns prefix="str" uri="http://exslt.org/strings"/>

	<sch:include href="./abstracts/disallowed_element_pattern.incl"/>
	<sch:include href="./abstracts/disallowed_attribute_pattern.incl"/>


        <!-- EAD3 checks for EAD3 1.0.0  -->
        <sch:pattern id="ead3_100_control_rightsdeclaration" is-a="disallowed_element_pattern">
                <sch:param name="context_element" value="ead3:control"/>
                <sch:param name="context_condition" value="ancestor::mets:mdWrap/@MDTYPEVERSION='1.0.0'"/>
                <sch:param name="disallowed_element" value="ead3:rightsdeclaration"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="ead3_100_part_date" is-a="disallowed_element_pattern">
                <sch:param name="context_element" value="ead3:part"/>
                <sch:param name="context_condition" value="ancestor::mets:mdWrap/@MDTYPEVERSION='1.0.0'"/>
                <sch:param name="disallowed_element" value="ead3:date"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="ead3_100_quote_render" is-a="disallowed_attribute_pattern">
                <sch:param name="context_element" value="ead3:quote"/>
                <sch:param name="context_condition" value="ancestor::mets:mdWrap/@MDTYPEVERSION='1.0.0'"/>
                <sch:param name="disallowed_attribute" value="@render"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="ead3_100_conventiondeclaration_localtype" is-a="disallowed_attribute_pattern">
                <sch:param name="context_element" value="ead3:conventiondeclaration"/>
                <sch:param name="context_condition" value="ancestor::mets:mdWrap/@MDTYPEVERSION='1.0.0'"/>
                <sch:param name="disallowed_attribute" value="@localtype"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="ead3_container_containerid_values">
                <sch:rule context="ead3:container[@containerid and ancestor::mets:mdWrap/@MDTYPEVERSION='1.0.0']">
                        <sch:let name="charset" value="string('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890.-_:')"/>
			<sch:let name="section_context" value="ancestor-or-self::*[self::mets:dmdSec or self::mets:techMD or self::mets:rightsMD or self::mets:sourceMD or self::mets:digiprovMD]"/>
			<sch:let name="section_string" value="concat('(ID of the metadata section ', name($section_context), ' is ', $section_context/@ID, ')')"/>
                        <sch:assert test="string-length(translate(normalize-space(@containerid), $charset, string('')))=0">
                                Value '<sch:value-of select="@containerid"/>' is not allowed in attribute '<sch:value-of select="name(@containerid)"/>' in element '<sch:name/>'. <sch:value-of select="substring($section_string,1,number($section_context)*string-length($section_string))"/> The value may contain only letters, digits, periods (.), hyphens (-), underscores (_), and colons (:).
                        </sch:assert>
                </sch:rule>
        </sch:pattern>


	<!-- 
	Some schema validators refuse to choose between ##other and ##local namespaces.
        This was used in EAD3 1.0.0. The EAD3 schema was changed so that it allows ##any namespace,
        allowing also EAD3 metadata. This validation disallows the EAD3 metadata from EAD3 1.0.0.
	-->
	<sch:pattern id="ead3_external" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="ead3:objectxmlwrap"/>
		<sch:param name="context_condition" value="ancestor::mets:mdWrap/@MDTYPEVERSION='1.0.0'"/>
		<sch:param name="disallowed_element" value="ead3:*"/>	
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

</sch:schema>
