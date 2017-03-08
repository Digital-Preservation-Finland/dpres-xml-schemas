<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.6.0">
	<sch:title>PREMIS metadata validation</sch:title>

<!--
Validates PREMIS metadata.
-->

	<sch:ns prefix="mets" uri="http://www.loc.gov/METS/"/>
	<sch:ns prefix="fi" uri="http://www.kdk.fi/standards/mets/kdk-extensions"/>
	<sch:ns prefix="premis" uri="info:lc/xmlns/premis-v2"/>
	<sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
	<sch:ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
	<sch:ns prefix="exsl" uri="http://exslt.org/common"/>
	<sch:ns prefix="sets" uri="http://exslt.org/sets"/>
	<sch:ns prefix="str" uri="http://exslt.org/strings"/>

	<!-- Supported MIME types -->
	<sch:let name="supported_mime_types" value="concat(
		'text/csv', '; ',
		'application/epub+zip', '; ',
		'application/xhtml+xml', '; ',
		'text/xml', '; ',
		'text/html', '; ',
		'application/vnd.oasis.opendocument.text', '; ',
		'application/vnd.oasis.opendocument.spreadsheet', '; ',
		'application/vnd.oasis.opendocument.presentation', '; ',
		'application/vnd.oasis.opendocument.graphics', '; ',
		'application/vnd.oasis.opendocument.formula', '; ',
		'application/pdf', '; ',
		'text/plain', '; ',
		'audio/x-aiff', '; ',
		'audio/x-wav', '; ',
		'audio/flac', '; ',
		'audio/mp4', '; ',
		'video/jpeg2000', '; ',
		'video/mp4', '; ',
		'image/jpeg', '; ',
		'image/jp2', '; ',
		'image/tiff', '; ',
		'image/png', '; ',
		'application/warc', '; ',
		'application/msword', '; ',
		'application/vnd.ms-excel', '; ',
		'application/vnd.ms-powerpoint', '; ',
		'audio/mpeg', '; ',
		'audio/x-ms-wma', '; ',
		'video/dv', '; ',
		'video/mpeg', '; ',
		'video/x-ms-wmv', '; ',
		'application/postscript', '; ',
		'image/gif', '; ',
		'application/x-internet-archive', '; ',
		'application/vnd.openxmlformats-officedocument.wordprocessingml.document', '; ',
		'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', '; ',
		'application/vnd.openxmlformats-officedocument.presentationml.presentation', '; ',
		'image/x-dpx', '; ',
		'application/gml+xml', '; ',
		'application/vnd.google-earth.kml+xml', '; ',
		'application/x-spss-por', '; ',
		'video/x-ms-asf', '; ',
		'video/avi', '; ',
		'video/MP1S', '; ',
		'video/MP2P', '; ',
		'video/MP2T', '; ',
		'video/mp4', '; ',
		'application/mxf', '; ',
		'video/mj2', '; ',
		'video/quicktime')"/>

	<!--
	Supported PRONOM registry key versions, grouped by file format, keys in a group divided with a space character.
	The number and ordering of the groups must be same as formats in MIME type list.
	-->
	<sch:let name="supported_pronom_codes" value="
		exsl:node-set('x-fmt/18')
		| exsl:node-set('fmt/483')
		| exsl:node-set('fmt/102 fmt/103')
		| exsl:node-set('fmt/101')
		| exsl:node-set('fmt/100 fmt/471')
		| exsl:node-set('fmt/136')
		| exsl:node-set('fmt/137')
		| exsl:node-set('fmt/138')
		| exsl:node-set('fmt/139')
		| exsl:node-set('')
		| exsl:node-set('fmt/95 fmt/354 fmt/476 fmt/477 fmt/478 fmt/16 fmt/17 fmt/18 fmt/19 fmt/20 fmt/276')
		| exsl:node-set('x-fmt/111')
		| exsl:node-set('x-fmt/135')
		| exsl:node-set('fmt/527 fmt/141') 
		| exsl:node-set('fmt/279')
		| exsl:node-set('fmt/199')
		| exsl:node-set('x-fmt/392') 
		| exsl:node-set('fmt/199') 
		| exsl:node-set('fmt/42 fmt/43 fmt/44')
		| exsl:node-set('x-fmt/392')
		| exsl:node-set('fmt/353 fmt/438 fmt/730 fmt/155')
		| exsl:node-set('fmt/13')
		| exsl:node-set('fmt/289')
		| exsl:node-set('fmt/40')
		| exsl:node-set('fmt/61 fmt/62')
		| exsl:node-set('fmt/126')
		| exsl:node-set('fmt/134')
		| exsl:node-set('fmt/132')
		| exsl:node-set('x-fmt/152')
		| exsl:node-set('fmt/649 fmt/640')
		| exsl:node-set('fmt/133')
		| exsl:node-set('fmt/124')
		| exsl:node-set('fmt/3 fmt/4')
		| exsl:node-set('x-fmt/219 fmt/410')
		| exsl:node-set('fmt/412')
		| exsl:node-set('fmt/214')
		| exsl:node-set('fmt/215')
		| exsl:node-set('fmt/541')
		| exsl:node-set('x-fmt/227')
		| exsl:node-set('fmt/224')
		| exsl:node-set('')
		| exsl:node-set('fmt/131')
		| exsl:node-set('fmt/5')
		| exsl:node-set('x-fmt/385')
		| exsl:node-set('x-fmt/386')
		| exsl:node-set('fmt/585')
		| exsl:node-set('fmt/199')
		| exsl:node-set('')
		| exsl:node-set('fmt/337')
		| exsl:node-set('x-fmt/384')"/>

	<!-- Supported checksum types divided with a space+semicolon characters -->
	<sch:let name="supported_checksum_algorithms" value="string('MD5; SHA-1; SHA-224; SHA-256; SHA-384; SHA-512; md5; sha-1; sha-224; sha-256; sha-384; sha-512')"/>
	
	<!-- Supported character encodings divided with a space character -->
	<sch:let name="supported_charsets" value="string('ISO-8859-15 UTF-8 UTF-16 UTF-32 iso-8859-15 utf-8 utf-16 utf-32')"/>

	<!-- MIME types that require charset -->
	<sch:let name="mimes_require_charset" value="string('application/xhtml+xml text/xml text/html text/csv text/plain application/gml+xml application/vnd.google-earth.kml+xml')"/>

	<!-- Container formats divided with a space character -->
	<sch:let name="container_formats" value="string('video/x-ms-asf video/avi video/MP1S video/MP2P video/MP2T video/mp4 application/mxf video/mj2 video/quicktime')"/>


	<sch:include href="./abstracts/disallowed_attribute_smaller_version_pattern.incl"/>
	<sch:include href="./abstracts/disallowed_element_smaller_version_pattern.incl"/>
	<sch:include href="./abstracts/disallowed_value_attribute_smaller_version_pattern.incl"/>
	<sch:include href="./abstracts/disallowed_value_element_smaller_version_pattern.incl"/>
	<sch:include href="./abstracts/required_element_pattern.incl"/>
	<sch:include href="./abstracts/required_values_element_pattern.incl"/>
	<sch:include href="./abstracts/unique_value_element_pattern.incl"/>
	<sch:include href="./abstracts/required_value_premis_formatname_pattern.incl"/>
	<sch:include href="./abstracts/required_parameters_premis_formatname_pattern.incl"/>
	<sch:include href="./abstracts/required_nonempty_element_pattern.incl"/>

	<!-- Version specific checks until smaller than 2.3 -->
	<sch:pattern id="premis23_object_authority" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="premis:object//*"/>
		<sch:param name="context_condition" value="@authority"/>
		<sch:param name="disallowed_attribute" value="@authority"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:OBJECT')"/>		
		<sch:param name="mdtype_version" value="string('2.3')"/>
	</sch:pattern>
	<sch:pattern id="premis23_rights_authority" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="premis:rightsStatement//*"/>
		<sch:param name="context_condition" value="@authority"/>
		<sch:param name="disallowed_attribute" value="@authority"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>		
		<sch:param name="mdtype_version" value="string('2.3')"/>
	</sch:pattern>
	<sch:pattern id="premis23_event_authority" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="premis:event//*"/>
		<sch:param name="context_condition" value="@authority"/>
		<sch:param name="disallowed_attribute" value="@authority"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:EVENT')"/>		
		<sch:param name="mdtype_version" value="string('2.3')"/>
	</sch:pattern>
	<sch:pattern id="premis23_agent_authority" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="premis:agent//*"/>
		<sch:param name="context_condition" value="@authority"/>
		<sch:param name="disallowed_attribute" value="@authority"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:AGENT')"/>		
		<sch:param name="mdtype_version" value="string('2.3')"/>
	</sch:pattern>
	<sch:pattern id="premis23_object_authorityURI" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="premis:object//*"/>
		<sch:param name="context_condition" value="@authorityURI"/>
		<sch:param name="disallowed_attribute" value="@authorityURI"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:OBJECT')"/>		
		<sch:param name="mdtype_version" value="string('2.3')"/>
	</sch:pattern>
	<sch:pattern id="premis23_rights_authorityURI" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="premis:rightsStatement//*"/>
		<sch:param name="context_condition" value="@authorityURI"/>
		<sch:param name="disallowed_attribute" value="@authorityURI"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>		
		<sch:param name="mdtype_version" value="string('2.3')"/>
	</sch:pattern>
	<sch:pattern id="premis23_event_authorityURI" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="premis:event//*"/>
		<sch:param name="context_condition" value="@authorityURI"/>
		<sch:param name="disallowed_attribute" value="@authorityURI"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:EVENT')"/>		
		<sch:param name="mdtype_version" value="string('2.3')"/>
	</sch:pattern>
	<sch:pattern id="premis23_agent_authorityURI" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="premis:agent//*"/>
		<sch:param name="context_condition" value="@authorityURI"/>
		<sch:param name="disallowed_attribute" value="@authorityURI"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:AGENT')"/>		
		<sch:param name="mdtype_version" value="string('2.3')"/>
	</sch:pattern>
	<sch:pattern id="premis23_object_valueURI" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="premis:object//*"/>
		<sch:param name="context_condition" value="@valueURI"/>
		<sch:param name="disallowed_attribute" value="@valueURI"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:OBJECT')"/>		
		<sch:param name="mdtype_version" value="string('2.3')"/>
	</sch:pattern>
	<sch:pattern id="premis23_rights_valueURI" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="premis:rightsStatement//*"/>
		<sch:param name="context_condition" value="@valueURI"/>
		<sch:param name="disallowed_attribute" value="@valueURI"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>		
		<sch:param name="mdtype_version" value="string('2.3')"/>
	</sch:pattern>
	<sch:pattern id="premis23_event_valueURI" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="premis:event//*"/>
		<sch:param name="context_condition" value="@valueURI"/>
		<sch:param name="disallowed_attribute" value="@valueURI"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:EVENT')"/>		
		<sch:param name="mdtype_version" value="string('2.3')"/>
	</sch:pattern>
	<sch:pattern id="premis23_agent_valueURI" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="premis:agent//*"/>
		<sch:param name="context_condition" value="@valueURI"/>
		<sch:param name="disallowed_attribute" value="@valueURI"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:AGENT')"/>		
		<sch:param name="mdtype_version" value="string('2.3')"/>
	</sch:pattern>

	<!-- Version specific checks until smaller than 2.2 -->
	<sch:pattern id="premis22_copyrightDocumentationIdentifier" is-a="disallowed_element_smaller_version_pattern">
		<sch:param name="context_element" value="premis:copyrightInformation"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="premis:copyrightDocumentationIdentifier"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>		
		<sch:param name="mdtype_version" value="string('2.2')"/>
	</sch:pattern>
	<sch:pattern id="premis22_copyrightApplicableDates" is-a="disallowed_element_smaller_version_pattern">
		<sch:param name="context_element" value="premis:copyrightInformation"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="premis:copyrightApplicableDates"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>		
		<sch:param name="mdtype_version" value="string('2.2')"/>
	</sch:pattern>
	<sch:pattern id="premis22_licenseDocumentationIdentifier" is-a="disallowed_element_smaller_version_pattern">
		<sch:param name="context_element" value="premis:licenseInformation"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="premis:licenseDocumentationIdentifier"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>		
		<sch:param name="mdtype_version" value="string('2.2')"/>
	</sch:pattern>
	<sch:pattern id="premis22_licenseApplicableDates" is-a="disallowed_element_smaller_version_pattern">
		<sch:param name="context_element" value="premis:licenseInformation"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="premis:licenseApplicableDates"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>		
		<sch:param name="mdtype_version" value="string('2.2')"/>
	</sch:pattern>
	<sch:pattern id="premis22_statuteDocumentationIdentifier" is-a="disallowed_element_smaller_version_pattern">
		<sch:param name="context_element" value="premis:statuteInformation"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="premis:statuteDocumentationIdentifier"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>		
		<sch:param name="mdtype_version" value="string('2.2')"/>
	</sch:pattern>
	<sch:pattern id="premis22_otherRightsInformation" is-a="disallowed_element_smaller_version_pattern">
		<sch:param name="context_element" value="premis:rightsStatement"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="premis:otherRightsInformation"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>		
		<sch:param name="mdtype_version" value="string('2.2')"/>
	</sch:pattern>
	<sch:pattern id="premis22_termOfRestriction" is-a="disallowed_element_smaller_version_pattern">
		<sch:param name="context_element" value="premis:rightsGranted"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="premis:termOfRestriction"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>		
		<sch:param name="mdtype_version" value="string('2.2')"/>
	</sch:pattern>
	<sch:pattern id="premis22_termOfGrant" is-a="disallowed_element_smaller_version_pattern">
		<sch:param name="context_element" value="premis:rightsGranted"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="premis:termOfGrant"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>		
		<sch:param name="mdtype_version" value="string('2.2')"/>
	</sch:pattern>
	<sch:pattern id="premis22_startDate_values" is-a="disallowed_value_element_smaller_version_pattern">
		<sch:param name="context_element" value="premis:startDate"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_value" value="string('OPEN')"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>		
		<sch:param name="mdtype_version" value="string('2.2')"/>
	</sch:pattern>
	<sch:pattern id="premis22_endDate_values" is-a="disallowed_value_element_smaller_version_pattern">
		<sch:param name="context_element" value="premis:endDate"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_value" value="string('OPEN')"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>		
		<sch:param name="mdtype_version" value="string('2.2')"/>
	</sch:pattern>
	<sch:pattern id="premis22_copyrightStatusDeterminationDate_values" is-a="disallowed_value_element_smaller_version_pattern">
		<sch:param name="context_element" value="premis:copyrightStatusDeterminationDate"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_value" value="string('OPEN')"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>		
		<sch:param name="mdtype_version" value="string('2.2')"/>
	</sch:pattern>
	<sch:pattern id="premis22_statuteInformationDeterminationDate_values" is-a="disallowed_value_element_smaller_version_pattern">
		<sch:param name="context_element" value="premis:statuteInformationDeterminationDate"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_value" value="string('OPEN')"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>		
		<sch:param name="mdtype_version" value="string('2.2')"/>
	</sch:pattern>
	<sch:pattern id="premis22_dateCreatedByApplication_values" is-a="disallowed_value_element_smaller_version_pattern">
		<sch:param name="context_element" value="premis:dateCreatedByApplication"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_value" value="string('OPEN')"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:OBJECT')"/>		
		<sch:param name="mdtype_version" value="string('2.2')"/>
	</sch:pattern>
	<sch:pattern id="premis22_preservationLevelDateAssigned_values" is-a="disallowed_value_element_smaller_version_pattern">
		<sch:param name="context_element" value="premis:preservationLevelDateAssigned"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_value" value="string('OPEN')"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:OBJECT')"/>		
		<sch:param name="mdtype_version" value="string('2.2')"/>
	</sch:pattern>
	<sch:pattern id="premis22_eventDateTime_values" is-a="disallowed_value_element_smaller_version_pattern">
		<sch:param name="context_element" value="premis:eventDateTime"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_value" value="string('OPEN')"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:EVENT')"/>		
		<sch:param name="mdtype_version" value="string('2.2')"/>
	</sch:pattern>
	<sch:pattern id="premis22_object_CREATED_values" is-a="disallowed_value_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="premis:mdSec"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@CREATED"/>
		<sch:param name="disallowed_value" value="string('OPEN')"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:OBJECT')"/>		
		<sch:param name="mdtype_version" value="string('2.2')"/>
	</sch:pattern>
	<sch:pattern id="premis22_rights_CREATED_values" is-a="disallowed_value_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="premis:mdSec"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@CREATED"/>
		<sch:param name="disallowed_value" value="string('OPEN')"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>		
		<sch:param name="mdtype_version" value="string('2.2')"/>
	</sch:pattern>
	<sch:pattern id="premis22_event_CREATED_values" is-a="disallowed_value_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="premis:mdSec"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@CREATED"/>
		<sch:param name="disallowed_value" value="string('OPEN')"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:EVENT')"/>		
		<sch:param name="mdtype_version" value="string('2.2')"/>
	</sch:pattern>
	<sch:pattern id="premis22_agent_CREATED_values" is-a="disallowed_value_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="premis:mdSec"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@CREATED"/>
		<sch:param name="disallowed_value" value="string('OPEN')"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('PREMIS:AGENT')"/>		
		<sch:param name="mdtype_version" value="string('2.2')"/>
	</sch:pattern>
	
	
	<!-- PREMIS mandatory elements -->
	<sch:pattern id="premis_fixity" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/premis:object[normalize-space(@xsi:type)='premis:file']//premis:objectCharacteristics"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="premis:fixity"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="premis_creatingApplication" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/premis:object[normalize-space(@xsi:type)='premis:file']//premis:objectCharacteristics"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="premis:creatingApplication"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="premis_dateCreatedByApplication" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/premis:object[normalize-space(@xsi:type)='premis:file']//premis:creatingApplication"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="premis:dateCreatedByApplication"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="premis_formatDesignation" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/premis:object[not(normalize-space(@xsi:type)='premis:representation')]//premis:format"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="premis:formatDesignation"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	
	<!-- Registy key check. -->
	<sch:pattern id="premis_formatName_values" is-a="required_value_premis_formatname_pattern">
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="mime_types" value="$supported_mime_types"/>
		<sch:param name="pronom_codes" value="$supported_pronom_codes"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<sch:pattern id="premis_formatName_parameters" is-a="required_parameters_premis_formatname_pattern">
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="charset_mimes" value="$mimes_require_charset"/>
		<sch:param name="charset" value="$supported_charsets"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>

	<!-- Message digest algorithm check -->
	<sch:pattern id="premis_messageDigestAlgorithm_values" is-a="required_values_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/premis:object[normalize-space(@xsi:type)='premis:file']//premis:messageDigestAlgorithm"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="valid_values" value="$supported_checksum_algorithms"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- Identifier value not empty -->
	<sch:pattern id="premis_objectIdentifierType_value" is-a="required_nonempty_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/premis:object//premis:objectIdentifierType"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="premis_objectIdentifierValue_value" is-a="required_nonempty_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/premis:object//premis:objectIdentifierValue"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="premis_rightsStatementIdentifierType_value" is-a="required_nonempty_element_pattern">
		<sch:param name="context_element" value="mets:rightsMD/mets:mdWrap/mets:xmlData/premis:rights//premis:rightsStatementIdentifierType"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="premis_rightsStatementIdentifierValue_value" is-a="required_nonempty_element_pattern">
		<sch:param name="context_element" value="mets:rightsMD/mets:mdWrap/mets:xmlData/premis:rights//premis:rightsStatementIdentifierValue"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="premis_eventIdentifierType_value" is-a="required_nonempty_element_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdWrap/mets:xmlData/premis:event//premis:eventIdentifierType"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="premis_eventIdentifierValue_value" is-a="required_nonempty_element_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdWrap/mets:xmlData/premis:event//premis:eventIdentifierValue"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="premis_agentIdentifierType_value" is-a="required_nonempty_element_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdWrap/mets:xmlData/premis:agent//premis:agentIdentifierType"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="premis_agentIdentifierValue_value" is-a="required_nonempty_element_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdWrap/mets:xmlData/premis:agent//premis:agentIdentifierValue"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- Check that identifiers of PREMIS sections are unique between the sections -->
	<sch:pattern id="premis_identifierValue_unique" is-a="unique_value_element_pattern">
		<sch:param name="unique_elements" value=".//premis:objectIdentifierValue | .//premis:eventIdentifierValue | .//premis:agentIdentifierValue | .//premis:rightsStatementIdentifierValue"/>
		<sch:param name="name_elements" value="string('premis:objectIdentifierValue; premis:eventIdentifierValue; premis:agentIdentifierValue; premis:rightsStatementIdentifierValue')"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>
	
	<!-- Premis linking check -->
	<sch:let name="objectid" value="/mets:mets/mets:amdSec/mets:*/mets:mdWrap/mets:xmlData/premis:object//premis:objectIdentifierValue"/>
	<sch:let name="eventid" value="/mets:mets/mets:amdSec/mets:*/mets:mdWrap/mets:xmlData/premis:event//premis:eventIdentifierValue"/>
	<sch:let name="agentid" value="/mets:mets/mets:amdSec/mets:*/mets:mdWrap/mets:xmlData/premis:agent//premis:agentIdentifierValue"/>
	<sch:let name="rightsid" value="/mets:mets/mets:amdSec/mets:*/mets:mdWrap/mets:xmlData/premis:rights//premis:rightsStatementIdentifierValue"/>
	<sch:pattern id="link_premis_element">
		<sch:rule context="premis:linkingObjectIdentifierValue">
			<sch:let name="id_value" value="normalize-space(.)"/>
			<sch:assert test="(count($objectid[normalize-space(.) = $id_value]) = 1)
			or contains(' 1.4 1.4.1 ', concat(' ',normalize-space(ancestor-or-self::mets:mets/@fi:CATALOG),' ')) or contains(' 1.4 1.4.1 ', concat(' ',normalize-space(ancestor-or-self::mets:mets/@fi:SPECIFICATION),' '))">
				Value '<sch:value-of select="."/>' in element '<sch:name/>' is a link to nowhere. The corresponding target element 'objectIdentifierValue' with the same value was not found.
			</sch:assert>
		</sch:rule>
		<sch:rule context="premis:linkingEventIdentifierValue">
			<sch:let name="id_value" value="normalize-space(.)"/>
			<sch:assert test="(count($eventid[normalize-space(.) = $id_value]) = 1)
			or contains(' 1.4 1.4.1 ', concat(' ',normalize-space(ancestor-or-self::mets:mets/@fi:CATALOG),' ')) or contains(' 1.4 1.4.1 ', concat(' ',normalize-space(ancestor-or-self::mets:mets/@fi:SPECIFICATION),' '))">
				Value '<sch:value-of select="."/>' in element '<sch:name/>' is a link to nowhere. The corresponding target element 'eventIdentifierValue' with the same value was not found.
			</sch:assert>
		</sch:rule>
		<sch:rule context="premis:linkingAgentIdentifierValue">
			<sch:let name="id_value" value="normalize-space(.)"/>
			<sch:assert test="(count($agentid[normalize-space(.) = $id_value]) = 1)
			or contains(' 1.4 1.4.1 ', concat(' ',normalize-space(ancestor-or-self::mets:mets/@fi:CATALOG),' ')) or contains(' 1.4 1.4.1 ', concat(' ',normalize-space(ancestor-or-self::mets:mets/@fi:SPECIFICATION),' '))">
				Value '<sch:value-of select="."/>' in element '<sch:name/>' is a link to nowhere. The corresponding target element 'agentIdentifierValue' with the same value was not found.
			</sch:assert>
		</sch:rule>
		<sch:rule context="premis:linkingRightsStatementIdentifierValue">
			<sch:let name="id_value" value="normalize-space(.)"/>
			<sch:assert test="(count($rightsid[normalize-space(.) = $id_value]) = 1)
			or contains(' 1.4 1.4.1 ', concat(' ',normalize-space(ancestor-or-self::mets:mets/@fi:CATALOG),' ')) or contains(' 1.4 1.4.1 ', concat(' ',normalize-space(ancestor-or-self::mets:mets/@fi:SPECIFICATION),' '))">
				Value '<sch:value-of select="."/>' in element '<sch:name/>' is a link to nowhere. The corresponding target element 'rightsStatementIdentifierValue' with the same value was not found.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- Native file check -->
	<sch:let name="techmd" value="exsl:node-set(/mets:mets/mets:amdSec/mets:techMD)"/>
	<sch:let name="digiprovmd_migration" value="exsl:node-set(/mets:mets/mets:amdSec/mets:digiprovMD[normalize-space(.//premis:event/premis:eventType)='migration' and normalize-space(.//premis:event//premis:eventOutcome)='success'])"/>
	<sch:pattern id="required_features_native">
		<sch:rule context="mets:file[(normalize-space(@USE)='no-file-format-validation')]">
			<sch:let name="admid" value="normalize-space(@ADMID)"/> 
			<sch:let name="source_techmd_id" value="normalize-space($techmd/@ID[contains(concat(' ', $admid, ' '), concat(' ', normalize-space(.), ' ')) and ..//premis:object//premis:formatName])"/> 
			<sch:let name="source_object_id" value="normalize-space($techmd[normalize-space(@ID) = $source_techmd_id]//premis:objectIdentifierValue)"/> 
			<sch:let name="event_source_link" value="exsl:node-set($digiprovmd_migration//premis:linkingObjectIdentifier[normalize-space(./premis:linkingObjectRole)='source' and normalize-space(./premis:linkingObjectIdentifierValue)=$source_object_id]/..)"/>
			<sch:let name="event_not_outcome_link" value="exsl:node-set($digiprovmd_migration//premis:linkingObjectIdentifier[normalize-space(./premis:linkingObjectRole)='outcome' and not(normalize-space(./premis:linkingObjectIdentifierValue)=$source_object_id)]/..)"/>
			<sch:let name="event_links_source_ok" value="sets:intersection($event_source_link, $event_not_outcome_link)"/>

			<sch:assert test="count($digiprovmd_migration) &gt; 0
			or contains(' 1.4 1.4.1 ', concat(' ',normalize-space(ancestor-or-self::mets:mets/@fi:CATALOG),' ')) or contains(' 1.4 1.4.1 ', concat(' ',normalize-space(ancestor-or-self::mets:mets/@fi:SPECIFICATION),' '))">
				Value '<sch:value-of select="@USE"/>' in attribute '<sch:value-of select="name(@USE)"/>' found for file '<sch:value-of select="./mets:FLocat/@xlink:href"/>'. Succeeded PREMIS event for migration is required.
			</sch:assert>
			<sch:assert test="count($digiprovmd_migration) = 0 or count($event_links_source_ok) &gt; 0
			or contains(' 1.4 1.4.1 ', concat(' ',normalize-space(ancestor-or-self::mets:mets/@fi:CATALOG),' ')) or contains(' 1.4 1.4.1 ', concat(' ',normalize-space(ancestor-or-self::mets:mets/@fi:SPECIFICATION),' '))">
				Value '<sch:value-of select="@USE"/>' in attribute '<sch:value-of select="name(@USE)"/>' found for file '<sch:value-of select="./mets:FLocat/@xlink:href"/>'. PREMIS event for migration contains ambiguous links to object identifiers.
			</sch:assert>
			<sch:report test="count($digiprovmd_migration) &gt; 0 and count($event_links_source_ok) &gt; 0
			and not(contains(' 1.4 1.4.1 ', concat(' ',normalize-space(ancestor-or-self::mets:mets/@fi:CATALOG),' '))) and not(contains(' 1.4 1.4.1 ', concat(' ',normalize-space(ancestor-or-self::mets:mets/@fi:SPECIFICATION),' ')))">
				INFO: Value '<sch:value-of select="@USE"/>' in attribute '<sch:value-of select="name(@USE)"/>' found for file '<sch:value-of select="./mets:FLocat/@xlink:href"/>'. No file format validation is executed for this file.
			</sch:report>
		</sch:rule>
	</sch:pattern>

    <!-- Container and stream checks -->
	<sch:pattern id="container_with streams">
		<sch:rule context="mets:techMD[.//premis:formatName and ancestor-or-self::mets:mets/mets:fileSec]">
			<sch:let name="tech_id" value="normalize-space(@ID)"/>
			<sch:let name="premis_format" value="normalize-space(.//premis:formatName)"/>
			<sch:let name="container_file" value="ancestor-or-self::mets:mets/mets:fileSec/mets:fileGrp/mets:file[contains(concat(' ', @ADMID, ' '), concat(' ', $tech_id, ' '))]"/>
			<sch:assert test="$container_file/mets:stream or not(contains(concat(' ', $container_formats, ' '), concat(' ', $premis_format, ' '))) or $premis_format='video/mp4'">
				Streams missing for container file '<sch:value-of select="$container_file/mets:FLocat/@xlink:href"/>'.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="linking_match_for_streams">
		<sch:rule context="mets:stream">
			<sch:let name="stream_admid" value="normalize-space(@ADMID)"/> 
			<sch:let name="container_admid" value="normalize-space(../@ADMID)"/>
			<sch:let name="container_techmd" value="$techmd[contains(concat(' ', $container_admid, ' '), concat(' ', normalize-space(@ID), ' ')) and normalize-space(.//premis:object/@xsi:type)='premis:file' and .//premis:object//premis:relatedObjectIdentifierValue]"/> 
			<sch:let name="stream_techmd" value="$techmd[contains(concat(' ', $stream_admid, ' '), concat(' ', normalize-space(@ID), ' ')) and normalize-space(.//premis:object/@xsi:type)='premis:bitstream']"/> 
			<sch:assert test="$container_techmd//premis:relatedObjectIdentifierValue = $stream_techmd//premis:objectIdentifierValue">
				Container or stream mismatch between METS fileSec and PREMIS linkings for file '<sch:value-of select="../mets:FLocat/@xlink:href"/>'.
			</sch:assert>
		</sch:rule>
	</sch:pattern>
</sch:schema>
