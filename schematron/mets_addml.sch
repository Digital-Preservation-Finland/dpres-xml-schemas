<?xml version="1.0" encoding="UTF-8"?>

<!--
     We are able to optimize validation by giving the element set to be used in validation.
     It is given as a comment, which must be located as direct preceding sibling of <sch:schema> element.
     The comment must start with a keyword "context-filter:".
     The filter works only for elements. All the attributes in the filtered elements will be evaluated.
     Example: context-filter: mets:*
              skips everything else in validation, except elements in METS namespace.
-->
<!-- context-filter: addml:*|mets:mets|mets:amdSec|mets:techMD|mets:mdWrap|mets:xmlData|mets:fileSec|mets:fileGrp|mets:file -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.7.0">
	<sch:title>ADDML metadata validation</sch:title>

<!--
Validates ADDML metadata.
-->
	
	<sch:ns prefix="mets" uri="http://www.loc.gov/METS/"/>
	<sch:ns prefix="fikdk" uri="http://www.kdk.fi/standards/mets/kdk-extensions"/>
        <sch:ns prefix="fi" uri="http://digitalpreservation.fi/schemas/mets/fi-extensions"/>
	<sch:ns prefix="addml" uri="http://www.arkivverket.no/standarder/addml"/>
	<sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
	<sch:ns prefix="premis" uri="info:lc/xmlns/premis-v2"/>
	<sch:ns prefix="exsl" uri="http://exslt.org/common"/>
	<sch:ns prefix="sets" uri="http://exslt.org/sets"/>
	<sch:ns prefix="str" uri="http://exslt.org/strings"/>
	
	<sch:include href="./abstracts/required_element_smaller_version_pattern.incl"/>
	<sch:include href="./abstracts/disallowed_element_smaller_version_pattern.incl"/>

	<!-- Version differences check -->
	<sch:pattern id="addml_reference" is-a="required_element_smaller_version_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/addml:addml/addml:dataset"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="addml:reference"/>
		<sch:param name="mdattribute" value="@OTHERMDTYPE"/>
		<sch:param name="mdtype_name" value="string('ADDML')"/>		
		<sch:param name="mdtype_version" value="string('8.3')"/>
	</sch:pattern>
	<sch:pattern id="addml_headerLevel" is-a="disallowed_element_smaller_version_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/addml:addml/addml:dataset/addml:flatFiles/addml:flatFileDefinitions/addml:flatFileDefinition/addml:recordDefinitions/addml:recordDefinition"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="addml:headerLevel"/>
		<sch:param name="mdattribute" value="@OTHERMDTYPE"/>
		<sch:param name="mdtype_name" value="string('ADDML')"/>		
		<sch:param name="mdtype_version" value="string('8.3')"/>
	</sch:pattern>

	<sch:let name="csv_fileid" value="/mets:mets/mets:amdSec/mets:techMD[./mets:mdWrap/mets:xmlData/premis:object/premis:objectCharacteristics/premis:format/premis:formatDesignation/premis:formatName='text/csv']/@ID"/>
	<sch:let name="csv_addmlrsids" value="/mets:mets/mets:amdSec/mets:techMD[./mets:mdWrap/mets:xmlData/addml:addml/addml:dataset/addml:flatFiles/addml:structureTypes/addml:flatFileTypes/addml:flatFileType/addml:delimFileFormat/addml:recordSeparator]/@ID"/>
	<sch:let name="csv_addmlfscids" value="/mets:mets/mets:amdSec/mets:techMD[./mets:mdWrap/mets:xmlData/addml:addml/addml:dataset/addml:flatFiles/addml:structureTypes/addml:flatFileTypes/addml:flatFileType/addml:delimFileFormat/addml:fieldSeparatingChar]/@ID"/>
	<sch:let name="csv_countfiles" value="count(sets:distinct(exsl:node-set($csv_fileid)))"/>
	<sch:let name="csv_countaddmlrs" value="count(sets:distinct(exsl:node-set($csv_addmlrsids)))"/>
	<sch:let name="csv_countaddmlfsc" value="count(sets:distinct(exsl:node-set($csv_addmlfscids)))"/>
	<sch:pattern id="csv_addml_requirements">
        	<sch:rule context="mets:file">
			<sch:let name="given_specification" value="substring-before(concat(normalize-space(concat(normalize-space(/mets:mets/@fi:CATALOG), ' ', normalize-space(/mets:mets/@fikdk:CATALOG), ' ', normalize-space(/mets:mets/@fi:SPECIFICATION), ' ', normalize-space(/mets:mets/@fikdk:SPECIFICATION))), ' '), ' ')"/>
			<sch:let name="admids" value="normalize-space(@ADMID)"/>
			<sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
			<sch:let name="countfilescomb" value="count(sets:distinct(exsl:node-set($csv_fileid) | str:tokenize($admids, ' ')))"/>
			<sch:let name="countaddmlrscomb" value="count(sets:distinct(exsl:node-set($csv_addmlrsids) | str:tokenize($admids, ' ')))"/>
			<sch:let name="countaddmlfsccomb" value="count(sets:distinct(exsl:node-set($csv_addmlfscids) | str:tokenize($admids, ' ')))"/>
			<sch:assert test="(($csv_countfiles+$countadm)=$countfilescomb) or not(($csv_countaddmlrs+$countadm)=$countaddmlrscomb)
                        or contains(' 1.4 1.4.1 ', concat(' ', $given_specification,' '))">
				Element 'recordSeparator' is required in ADDML metadata for file '<sch:value-of select="./mets:FLocat/@xlink:href"/>'.
			</sch:assert>
			<sch:assert test="(($csv_countfiles+$countadm)=$countfilescomb) or not(($csv_countaddmlfsc+$countadm)=$countaddmlfsccomb)
                        or contains(' 1.4 1.4.1 ', concat(' ', $given_specification,' '))">
				Element 'fieldSeparatingChar' is required in ADDML metadata for file '<sch:value-of select="./mets:FLocat/@xlink:href"/>'.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

</sch:schema>
