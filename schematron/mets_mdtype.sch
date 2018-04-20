<?xml version="1.0" encoding="UTF-8"?>
<!--
     We are able to optimize validation by giving the element set to be used in validation.
     It is given as a comment, which must be located as direct preceiding sibling of <sch:schema> element.
     The comment must start with a keyword "context-filter:".
     The filter works only for elements. All the attributes in the filtered elements will be evaluated.
     Example: context-filter: mets:*
              skips everything else in validation, except elements in namespace prefixed as mets in this Schematron file.
-->
<!-- -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.7.0">
	<sch:title>METS external metadata type validation</sch:title>

<!--
Validates that the used metadata type inside mdWrap element is same as defined in MDTYPE or OTHERMDTYPE attribute.
-->

	<sch:ns prefix="mets" uri="http://www.loc.gov/METS/"/>
	<sch:ns prefix="fikdk" uri="http://www.kdk.fi/standards/mets/kdk-extensions"/>
	<sch:ns prefix="fi" uri="http://digitalpreservation.fi/schemas/mets/fi-extensions"/>
	<sch:ns prefix="premis" uri="info:lc/xmlns/premis-v2"/>
	<sch:ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
	<sch:ns prefix="mix" uri="http://www.loc.gov/mix/v20"/>
	<sch:ns prefix="textmd" uri="info:lc/xmlns/textMD-v3"/>
	<sch:ns prefix="textmd_kdk" uri="http://www.kdk.fi/standards/textmd"/>
	<sch:ns prefix="addml" uri="http://www.arkivverket.no/standarder/addml"/>
	<sch:ns prefix="audiomd" uri="http://www.loc.gov/audioMD/"/>
	<sch:ns prefix="videomd" uri="http://www.loc.gov/videoMD/"/>
	<sch:ns prefix="metsrights" uri="http://cosimo.stanford.edu/sdr/metsrights/"/>
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
	<sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
	<sch:ns prefix="exsl" uri="http://exslt.org/common"/>
	<sch:ns prefix="sets" uri="http://exslt.org/sets"/>
	<sch:ns prefix="str" uri="http://exslt.org/strings"/>

	<sch:include href="./abstracts/allowed_unsupported_metadata_pattern.incl"/>
	<sch:include href="./abstracts/disallowed_element_pattern.incl"/>
	<sch:include href="./abstracts/disallowed_unsupported_metadata_pattern.incl"/>
	<sch:include href="./abstracts/required_metadata_match_pattern.incl"/>
	<sch:include href="./abstracts/required_metadata_pattern.incl"/>
	<sch:include href="./abstracts/deprecated_element_pattern.incl"/>

	<sch:let name="addml_types" value="string('text/csv')"/>
	<sch:let name="textmd_types" value="string('application/xhtml+xml text/html text/xml text/plain')"/>
	<sch:let name="audiomd_types" value="string('audio/x-aiff audio/x-wave audio/flac audio/mp4 audio/x-wav audio/mpeg audio/x-ms-wma')"/>
	<sch:let name="videomd_types" value="string('video/jpeg2000 video/mp4 video/dv video/mpeg video/x-ms-wmv')"/>
	<sch:let name="mix_types" value="string('image/tiff image/jpeg image/jp2 image/png image/gif image/x-dpx')"/>

	<!-- Check metadata content in mdWrap -->
	<sch:pattern id="mets_mdtype_content" is-a="required_metadata_match_pattern">
		<sch:param name="context_condition" value="not(@OTHERMDTYPE)"/>
		<sch:param name="required_condition" value="(number(normalize-space(@MDTYPE)='PREMIS:OBJECT')*count(mets:xmlData/premis:object)*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='PREMIS:RIGHTS')*count(mets:xmlData/premis:rights)*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='PREMIS:EVENT')*count(mets:xmlData/premis:event)*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='PREMIS:AGENT')*count(mets:xmlData/premis:agent)*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='NISOIMG')*number(boolean(mets:xmlData/mix:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='MARC')*number(boolean(mets:xmlData/marc21:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='DC')*number(boolean(mets:xmlData/dc:* or mets:xmlData/dcterms:* or mets:xmlData/dcmitype:*))
			  + number(normalize-space(@MDTYPE)='MODS')*number(boolean(mets:xmlData/mods:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='EAD')*number(boolean(mets:xmlData/ead:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='EAC-CPF')*number(boolean(mets:xmlData/eac:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='LIDO')*number(boolean(mets:xmlData/lido:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='VRA')*number(boolean(mets:xmlData/vra:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='3.2')*number(boolean(mets:xmlData/ddilc32:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='3.1')*number(boolean(mets:xmlData/ddilc31:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='2.5')*number(boolean(mets:xmlData/ddicb25:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='2.5.1')*number(boolean(mets:xmlData/ddicb25:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='2.1')*number(boolean(mets:xmlData/ddicb21:*))*count(mets:xmlData/*)) = 1"/>
		<sch:param name="used_attribute" value="@MDTYPE"/>
		<sch:param name="specifications" value="string('not: 1.4; 1.4.1; 1.5.0; 1.6.0; 1.6.1')"/>
	</sch:pattern>
        <sch:pattern id="mets_othermdtype_content" is-a="required_metadata_match_pattern">
                <sch:param name="context_condition" value="@OTHERMDTYPE"/>
                <sch:param name="required_condition" value="(number(normalize-space(@OTHERMDTYPE)='ADDML')*number(boolean(mets:xmlData/addml:*))*count(mets:xmlData/*)
                          + number(normalize-space(@OTHERMDTYPE)='AudioMD')*number(boolean(mets:xmlData/audiomd:*))*count(mets:xmlData/*)
                          + number(normalize-space(@OTHERMDTYPE)='VideoMD')*number(boolean(mets:xmlData/videomd:*))*count(mets:xmlData/*)
                          + number(normalize-space(@OTHERMDTYPE)='EAD3')*number(boolean(mets:xmlData/ead3:*))*count(mets:xmlData/*)
			  + number(normalize-space(@OTHERMDTYPE)='DATACITE')*number(boolean(mets:xmlData/datacite:*))*count(mets:xmlData/*)
                          + number(normalize-space(@OTHERMDTYPE)!='ADDML' and normalize-space(@OTHERMDTYPE)!='AudioMD' and normalize-space(@OTHERMDTYPE)!='VideoMD' and normalize-space(@OTHERMDTYPE)!='EAD3' and normalize-space(@OTHERMDTYPE)!='DATACITE')*count(mets:xmlData/*)) = 1"/>
                <sch:param name="used_attribute" value="@OTHERMDTYPE"/>
                <sch:param name="specifications" value="string('not: 1.4; 1.4.1; 1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>

	<!-- Disallow supported EN15744 metadata. This is a temporary check.
	EN15744 metadata schema does not exist, and therefore it's not clear how to support it. -->
	<sch:pattern id="mets_EN15744" is-a="disallowed_unsupported_metadata_pattern">
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="unsupported_mdname" value="string('EN15744')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	
	<!-- Notify the existence of unsupported metadata -->
	<sch:pattern id="mets_allowedmd_unsupported" is-a="allowed_unsupported_metadata_pattern">
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_condition" value="@OTHERMDTYPE!='AudioMD' and @OTHERMDTYPE!='VideoMD' and @OTHERMDTYPE!='EN15744' and @OTHERMDTYPE!='EAD3' and @OTHERMDTYPE!='ADDML' and @OTHERMDTYPE!='DATACITE'"/>
		<sch:param name="specifications" value="string('not: 1.4; 1.4.1; 1.5.0; 1.6.0; 1.6.1')"/>
	</sch:pattern>

	<!-- Standard portfolio schemas -->
	<sch:pattern id="mets_object_exists" is-a="required_metadata_pattern">
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_metadata" value="mets:techMD/mets:mdWrap[@MDTYPE='PREMIS:OBJECT']"/>
		<sch:param name="metadata_name" value="string('PREMIS:OBJECT')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_event_exists" is-a="required_metadata_pattern">
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_metadata" value="mets:digiprovMD/mets:mdWrap[@MDTYPE='PREMIS:EVENT']"/>
		<sch:param name="metadata_name" value="string('PREMIS:EVENT')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_descriptive_exists" is-a="required_metadata_pattern">
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_metadata" value="mets:dmdSec/mets:mdWrap[@MDTYPE='LIDO' or @MDTYPE='EAC-CPF' or @MDTYPE='EAD' or @OTHERMDTYPE='EAD3'
		or @MDTYPE='VRA' or @MDTYPE='MODS' or @MDTYPE='MARC' or @MDTYPE='DC' or @MDTYPE='DDI' or @OTHERMDTYPE='EN15744' or @OTHERMDTYPE='DATACITE']"/>
		<sch:param name="metadata_name" value="string('Standard portfolio descriptive')"/>
		<sch:param name="specifications" value="string('not: 1.4; 1.4.1; 1.5.0; 1.6.0; 1.6.1')"/>
	</sch:pattern>

	<!-- Known descriptive, rights, technical, or provenance metadata can not be used inside wrong section -->
	<sch:pattern id="dmdsec_no_rights" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:dmdSec/mets:mdWrap/mets:xmlData"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="premis:rights"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern> 
	<sch:pattern id="techmd_no_rights" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="premis:rights"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern> 
	<sch:pattern id="digiprovmd_no_rights" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdWrap/mets:xmlData"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="premis:rights"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern> 
	<sch:pattern id="dmdsec_no_tech" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:dmdSec/mets:mdWrap/mets:xmlData"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="premis:object or addml:* or textmd:* or textmd_kdk:* or mix:* or audiomd:* or videomd:*"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern> 
	<sch:pattern id="rights_no_tech" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:rightsMD/mets:mdWrap/mets:xmlData"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="premis:object or addml:* or textmd:* or textmd_kdk:* or mix:* or audiomd:* or videomd:*"/>
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
		<sch:param name="context_condition" value="premis:object[not(normalize-space(@xsi:type)='premis:representation')]"/>
		<sch:param name="disallowed_element" value="premis:object"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="dmdsec_no_digiprov" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:dmdSec/mets:mdWrap/mets:xmlData"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="premis:agent or premis:event"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern> 
	<sch:pattern id="techmd_no_digiprov" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="premis:agent or premis:event"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern> 
	<sch:pattern id="rights_no_digiprov" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:rightsMD/mets:mdWrap/mets:xmlData"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="premis:agent or premis:event"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern> 
	<sch:pattern id="techmd_no_descriptive" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="datacite:* or lido:* or ead:* or ead3:* or vra:* or mods:* or marc21:* or dc:* or dcterms:* or dcmitype:* or ddilc32:* or ddilc31:* or ddicb25:* or ddicb21:*"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern> 
	<sch:pattern id="rights_no_descriptive" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:rightsMD/mets:mdWrap/mets:xmlData"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="datacite:* or lido:* or ead:* or ead3:* or vra:* or mods:* or marc21:* or dc:* or dcterms:* or dcmitype:* or ddilc32:* or ddilc31:* or ddicb25:* or ddicb21:*"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern> 
	<sch:pattern id="digiprovmd_no_descriptive" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdWrap/mets:xmlData"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="datacite:* or lido:* or ead:* or ead3:* or vra:* or mods:* or marc21:* or dc:* or dcterms:* or dcmitype:* or ddilc32:* or ddilc31:* or ddicb25:* or ddicb21:*"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern> 
	
	<!-- Require PREMIS:OBJECTs for files -->
	<sch:let name="premis_file_id" value="/mets:mets/mets:amdSec/mets:techMD[normalize-space(.//premis:object/@xsi:type)='premis:file']/@ID"/>
	<sch:let name="premis_file_count" value="count(sets:distinct(exsl:node-set($premis_file_id)))"/>
	<sch:pattern id="premis_file_requirement">
        <sch:rule context="mets:file">
			<sch:let name="admids" value="normalize-space(@ADMID)"/>
			<sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
			<sch:let name="countfilescomb" value="count(sets:distinct(exsl:node-set($premis_file_id) | str:tokenize($admids, ' ')))"/>
			<sch:assert test="($premis_file_count+$countadm) &gt; $countfilescomb">
				Linking between PREMIS:OBJECT metadata and file '<sch:value-of select="./mets:FLocat/@xlink:href"/>' is required.
			</sch:assert>
		</sch:rule>
    </sch:pattern>
	<sch:let name="premis_stream_id" value="/mets:mets/mets:amdSec/mets:techMD[normalize-space(.//premis:object/@xsi:type)='premis:bitstream']/@ID"/>
	<sch:let name="premis_stream_count" value="count(sets:distinct(exsl:node-set($premis_stream_id)))"/>
	<sch:pattern id="premis_stream_requirement">
        <sch:rule context="mets:stream">
			<sch:let name="admids" value="normalize-space(@ADMID)"/>
			<sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
			<sch:let name="countfilescomb" value="count(sets:distinct(exsl:node-set($premis_stream_id) | str:tokenize($admids, ' ')))"/>
			<sch:assert test="($premis_stream_count+$countadm) &gt; $countfilescomb">
				Linking between PREMIS:OBJECT metadata and stream in file '<sch:value-of select="../mets:FLocat/@xlink:href"/>' is required.
			</sch:assert>
		</sch:rule>
    </sch:pattern>
	

	<!-- File format specific technical metadata requirements -->
	<sch:let name="audiomd_fileid_stream" value="/mets:mets/mets:amdSec/mets:techMD[contains(concat(' ', $audiomd_types, ' '), concat(' ', normalize-space(.//premis:formatName), ' ')) and normalize-space(.//premis:object/@xsi:type)='premis:bitstream']/@ID"/>
	<sch:let name="audiomd_mdids" value="/mets:mets/mets:amdSec/mets:techMD[./mets:mdWrap/mets:xmlData/audiomd:*]/@ID"/>
	<sch:let name="audiomd_countfiles_stream" value="count(sets:distinct(exsl:node-set($audiomd_fileid_stream)))"/>
	<sch:let name="audiomd_countmd" value="count(sets:distinct(exsl:node-set($audiomd_mdids)))"/>
	<sch:pattern id="audiomd_requirement_stream">
        	<sch:rule context="mets:stream">
			<sch:let name="given_specification" value="substring-before(concat(normalize-space(concat(normalize-space(/mets:mets/@fi:CATALOG), ' ', normalize-space(/mets:mets/@fikdk:CATALOG), ' ', normalize-space(/mets:mets/@fi:SPECIFICATION), ' ', normalize-space(/mets:mets/@fikdk:SPECIFICATION))), ' '), ' ')"/>
			<sch:let name="admids" value="normalize-space(@ADMID)"/>
			<sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
			<sch:let name="countfilescomb" value="count(sets:distinct(exsl:node-set($audiomd_fileid_stream) | str:tokenize($admids, ' ')))"/>
			<sch:let name="countmdcomb" value="count(sets:distinct(exsl:node-set($audiomd_mdids) | str:tokenize($admids, ' ')))"/>
			<sch:assert test="(($audiomd_countfiles_stream+$countadm)=$countfilescomb) or not(($audiomd_countmd+$countadm)=$countmdcomb)
			or contains(' 1.4 1.4.1 1.5.0 ', concat(' ', $given_specification,' '))">
				Linking between AudioMD metadata and stream in file '<sch:value-of select="../mets:FLocat/@xlink:href"/>' is required.
			</sch:assert>
		</sch:rule>
	</sch:pattern>
	<sch:let name="videomd_fileid_stream" value="/mets:mets/mets:amdSec/mets:techMD[contains(concat(' ', $videomd_types, ' '), concat(' ', normalize-space(.//premis:formatName), ' ')) and normalize-space(.//premis:object/@xsi:type)='premis:bitstream']/@ID"/>
	<sch:let name="videomd_mdids" value="/mets:mets/mets:amdSec/mets:techMD[./mets:mdWrap/mets:xmlData/videomd:*]/@ID"/>
	<sch:let name="videomd_countfiles_stream" value="count(sets:distinct(exsl:node-set($videomd_fileid_stream)))"/>
	<sch:let name="videomd_countmd" value="count(sets:distinct(exsl:node-set($videomd_mdids)))"/>
	<sch:pattern id="videomd_requirement_stream">
        	<sch:rule context="mets:stream">
			<sch:let name="given_specification" value="substring-before(concat(normalize-space(concat(normalize-space(/mets:mets/@fi:CATALOG), ' ', normalize-space(/mets:mets/@fikdk:CATALOG), ' ', normalize-space(/mets:mets/@fi:SPECIFICATION), ' ', normalize-space(/mets:mets/@fikdk:SPECIFICATION))), ' '), ' ')"/>
			<sch:let name="admids" value="normalize-space(@ADMID)"/>
			<sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
			<sch:let name="countfilescomb" value="count(sets:distinct(exsl:node-set($videomd_fileid_stream) | str:tokenize($admids, ' ')))"/>
			<sch:let name="countmdcomb" value="count(sets:distinct(exsl:node-set($videomd_mdids) | str:tokenize($admids, ' ')))"/>
			<sch:assert test="(($videomd_countfiles_stream+$countadm)=$countfilescomb) or not(($videomd_countmd+$countadm)=$countmdcomb)
                        or contains(' 1.4 1.4.1 1.5.0 ', concat(' ', $given_specification,' '))">
				Linking between VideoMD metadata and stream in file '<sch:value-of select="../mets:FLocat/@xlink:href"/>' is required.
			</sch:assert>
		</sch:rule>
	</sch:pattern>
	<sch:let name="addml_fileid" value="/mets:mets/mets:amdSec/mets:techMD[contains(concat(' ', $addml_types, ' '), concat(' ', normalize-space(.//premis:formatName), ' ')) and normalize-space(.//premis:object/@xsi:type)='premis:file']/@ID"/>
	<sch:let name="addml_mdids" value="/mets:mets/mets:amdSec/mets:techMD[./mets:mdWrap/mets:xmlData/addml:*]/@ID"/>
	<sch:let name="addml_countfiles" value="count(sets:distinct(exsl:node-set($addml_fileid)))"/>
	<sch:let name="addml_countmd" value="count(sets:distinct(exsl:node-set($addml_mdids)))"/>
	<sch:pattern id="addml_requirement">
        	<sch:rule context="mets:file">
			<sch:let name="given_specification" value="substring-before(concat(normalize-space(concat(normalize-space(/mets:mets/@fi:CATALOG), ' ', normalize-space(/mets:mets/@fikdk:CATALOG), ' ', normalize-space(/mets:mets/@fi:SPECIFICATION), ' ', normalize-space(/mets:mets/@fikdk:SPECIFICATION))), ' '), ' ')"/>
			<sch:let name="admids" value="normalize-space(@ADMID)"/>
			<sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
			<sch:let name="countfilescomb" value="count(sets:distinct(exsl:node-set($addml_fileid) | str:tokenize($admids, ' ')))"/>
			<sch:let name="countmdcomb" value="count(sets:distinct(exsl:node-set($addml_mdids) | str:tokenize($admids, ' ')))"/>
			<sch:assert test="(($addml_countfiles+$countadm)=$countfilescomb) or not(($addml_countmd+$countadm)=$countmdcomb)
                        or contains(' 1.4 1.4.1 ', concat(' ', $given_specification,' '))">
				Linking between ADDML metadata and file '<sch:value-of select="./mets:FLocat/@xlink:href"/>' is required.
			</sch:assert>
		</sch:rule>
	</sch:pattern>
	<sch:let name="audiomd_fileid" value="/mets:mets/mets:amdSec/mets:techMD[contains(concat(' ', $audiomd_types, ' '), concat(' ', normalize-space(.//premis:formatName), ' ')) and normalize-space(.//premis:object/@xsi:type)='premis:file']/@ID"/>
	<sch:let name="audiomd_countfiles" value="count(sets:distinct(exsl:node-set($audiomd_fileid)))"/>
	<sch:pattern id="audiomd_requirement">
        	<sch:rule context="mets:file">
			<sch:let name="given_specification" value="substring-before(concat(normalize-space(concat(normalize-space(/mets:mets/@fi:CATALOG), ' ', normalize-space(/mets:mets/@fikdk:CATALOG), ' ', normalize-space(/mets:mets/@fi:SPECIFICATION), ' ', normalize-space(/mets:mets/@fikdk:SPECIFICATION))), ' '), ' ')"/>
			<sch:let name="admids" value="normalize-space(@ADMID)"/>
			<sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
			<sch:let name="countfilescomb" value="count(sets:distinct(exsl:node-set($audiomd_fileid) | str:tokenize($admids, ' ')))"/>
			<sch:let name="countmdcomb" value="count(sets:distinct(exsl:node-set($audiomd_mdids) | str:tokenize($admids, ' ')))"/>
			<sch:assert test="(($audiomd_countfiles+$countadm)=$countfilescomb) or not(($audiomd_countmd+$countadm)=$countmdcomb)
                        or contains(' 1.4 1.4.1 ', concat(' ', $given_specification,' '))">
				Linking between AudioMD metadata and file '<sch:value-of select="./mets:FLocat/@xlink:href"/>' is required.
			</sch:assert>
		</sch:rule>
	</sch:pattern>
    <!-- TODO MP4 -->
	<sch:let name="videomd_fileid" value="/mets:mets/mets:amdSec/mets:techMD[contains(concat(' ', $videomd_types, ' '), concat(' ', normalize-space(.//premis:formatName), ' ')) and normalize-space(.//premis:object/@xsi:type)='premis:file']/@ID"/>
	<sch:let name="videomd_countfiles" value="count(sets:distinct(exsl:node-set($videomd_fileid)))"/>
	<sch:pattern id="videomd_requirement">
        	<sch:rule context="mets:file">
			<sch:let name="given_specification" value="substring-before(concat(normalize-space(concat(normalize-space(/mets:mets/@fi:CATALOG), ' ', normalize-space(/mets:mets/@fikdk:CATALOG), ' ', normalize-space(/mets:mets/@fi:SPECIFICATION), ' ', normalize-space(/mets:mets/@fikdk:SPECIFICATION))), ' '), ' ')"/>
			<sch:let name="admids" value="normalize-space(@ADMID)"/>
			<sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
			<sch:let name="countfilescomb" value="count(sets:distinct(exsl:node-set($videomd_fileid) | str:tokenize($admids, ' ')))"/>
			<sch:let name="countmdcomb" value="count(sets:distinct(exsl:node-set($videomd_mdids) | str:tokenize($admids, ' ')))"/>
			<sch:assert test="(($videomd_countfiles+$countadm)=$countfilescomb) or not(($videomd_countmd+$countadm)=$countmdcomb)
                        or contains(' 1.4 1.4.1 ', concat(' ', $given_specification,' '))">
				Linking between VideoMD metadata and file '<sch:value-of select="./mets:FLocat/@xlink:href"/>' is required.
			</sch:assert>
		</sch:rule>
	</sch:pattern>
	<sch:let name="mix_fileid" value="/mets:mets/mets:amdSec/mets:techMD[contains(concat(' ', $mix_types, ' '), concat(' ', normalize-space(.//premis:formatName), ' ')) and normalize-space(.//premis:object/@xsi:type)='premis:file']/@ID"/>
	<sch:let name="mix_mdids" value="/mets:mets/mets:amdSec/mets:techMD[./mets:mdWrap/mets:xmlData/mix:*]/@ID"/>
	<sch:let name="mix_countfiles" value="count(sets:distinct(exsl:node-set($mix_fileid)))"/>
	<sch:let name="mix_countmd" value="count(sets:distinct(exsl:node-set($mix_mdids)))"/>
	<sch:pattern id="mix_requirement">
        	<sch:rule context="mets:file">
			<sch:let name="given_specification" value="substring-before(concat(normalize-space(concat(normalize-space(/mets:mets/@fi:CATALOG), ' ', normalize-space(/mets:mets/@fikdk:CATALOG), ' ', normalize-space(/mets:mets/@fi:SPECIFICATION), ' ', normalize-space(/mets:mets/@fikdk:SPECIFICATION))), ' '), ' ')"/>
			<sch:let name="admids" value="normalize-space(@ADMID)"/>
			<sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
			<sch:let name="countfilescomb" value="count(sets:distinct(exsl:node-set($mix_fileid) | str:tokenize($admids, ' ')))"/>
			<sch:let name="countmdcomb" value="count(sets:distinct(exsl:node-set($mix_mdids) | str:tokenize($admids, ' ')))"/>
			<sch:assert test="(($mix_countfiles+$countadm)=$countfilescomb) or not(($mix_countmd+$countadm)=$countmdcomb)
                        or contains(' 1.4 1.4.1 ', concat(' ', $given_specification,' '))">
				Linking between NISOIMG (MIX) metadata and file '<sch:value-of select="./mets:FLocat/@xlink:href"/>' is required.
			</sch:assert>
		</sch:rule>
	</sch:pattern>



	<!-- COMPATIBILITY WITH DEPRECATED VERSIONS -->

	<!-- Check metadata content in mdWrap with old specifications -->
        <sch:pattern id="mets16_mdtype_content" is-a="required_metadata_match_pattern">
                <sch:param name="context_condition" value="not(@OTHERMDTYPE)"/>
                <sch:param name="required_condition" value="(number(normalize-space(@MDTYPE)='PREMIS:OBJECT')*count(mets:xmlData/premis:object)*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='PREMIS:RIGHTS')*count(mets:xmlData/premis:rights)*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='PREMIS:EVENT')*count(mets:xmlData/premis:event)*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='PREMIS:AGENT')*count(mets:xmlData/premis:agent)*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='NISOIMG')*number(boolean(mets:xmlData/mix:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='MARC')*number(boolean(mets:xmlData/marc21:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DC')*number(boolean(mets:xmlData/dc:* or mets:xmlData/dcterms:* or mets:xmlData/dcmitype:*))
                          + number(normalize-space(@MDTYPE)='MODS')*number(boolean(mets:xmlData/mods:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='EAD')*number(boolean(mets:xmlData/ead:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='EAC-CPF')*number(boolean(mets:xmlData/eac:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='LIDO')*number(boolean(mets:xmlData/lido:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='VRA')*number(boolean(mets:xmlData/vra:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='3.2')*number(boolean(mets:xmlData/ddilc32:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='3.1')*number(boolean(mets:xmlData/ddilc31:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='2.5')*number(boolean(mets:xmlData/ddicb25:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='2.5.1')*number(boolean(mets:xmlData/ddicb25:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='2.1')*number(boolean(mets:xmlData/ddicb21:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='TEXTMD')*number(boolean(mets:xmlData/textmd:*))*count(mets:xmlData/*)) = 1"/>
                <sch:param name="used_attribute" value="@MDTYPE"/>
                <sch:param name="specifications" value="string('1.6.0; 1.6.1')"/>
        </sch:pattern>
        <sch:pattern id="mets15_mdtype_content" is-a="required_metadata_match_pattern">
                <sch:param name="context_condition" value="not(@OTHERMDTYPE)"/>
                <sch:param name="required_condition" value="(number(normalize-space(@MDTYPE)='PREMIS:OBJECT')*count(mets:xmlData/premis:object)*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='PREMIS:RIGHTS')*count(mets:xmlData/premis:rights)*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='PREMIS:RIGHTS')*count(mets:xmlData/premis:rightsStatement)*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='PREMIS:EVENT')*count(mets:xmlData/premis:event)*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='PREMIS:AGENT')*count(mets:xmlData/premis:agent)*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='NISOIMG')*number(boolean(mets:xmlData/mix:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='MARC')*number(boolean(mets:xmlData/marc21:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DC')*number(boolean(mets:xmlData/dc:* or mets:xmlData/dcterms:* or mets:xmlData/dcmitype:*))
                          + number(normalize-space(@MDTYPE)='MODS')*number(boolean(mets:xmlData/mods:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='EAD')*number(boolean(mets:xmlData/ead:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='EAC-CPF')*number(boolean(mets:xmlData/eac:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='LIDO')*number(boolean(mets:xmlData/lido:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='VRA')*number(boolean(mets:xmlData/vra:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='3.2')*number(boolean(mets:xmlData/ddilc32:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='3.1')*number(boolean(mets:xmlData/ddilc31:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='2.5')*number(boolean(mets:xmlData/ddicb25:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='2.5.1')*number(boolean(mets:xmlData/ddicb25:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='2.1')*number(boolean(mets:xmlData/ddicb21:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='TEXTMD')*number(boolean(mets:xmlData/textmd:*))*count(mets:xmlData/*)) = 1"/>
                <sch:param name="used_attribute" value="@MDTYPE"/>
                <sch:param name="specifications" value="string('1.5.0')"/>
        </sch:pattern>
        <sch:pattern id="mets14_mdtype_content" is-a="required_metadata_match_pattern">
                <sch:param name="context_condition" value="not(@OTHERMDTYPE)"/>
                <sch:param name="required_condition" value="(number(normalize-space(@MDTYPE)='PREMIS:OBJECT')*count(mets:xmlData/premis:object)*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='PREMIS:RIGHTS')*count(mets:xmlData/premis:rights)*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='PREMIS:EVENT')*count(mets:xmlData/premis:event)*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='PREMIS:AGENT')*count(mets:xmlData/premis:agent)*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='METSRIGHTS')*number(boolean(mets:xmlData/metsrights:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='NISOIMG')*number(boolean(mets:xmlData/mix:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='MARC')*number(boolean(mets:xmlData/marc21:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DC')*number(boolean(mets:xmlData/dc:* or mets:xmlData/dcterms:* or mets:xmlData/dcmitype:*))
                          + number(normalize-space(@MDTYPE)='MODS')*number(boolean(mets:xmlData/mods:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='EAD')*number(boolean(mets:xmlData/ead:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='EAC-CPF')*number(boolean(mets:xmlData/eac:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='LIDO')*number(boolean(mets:xmlData/lido:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='VRA')*number(boolean(mets:xmlData/vra:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='DDI')*number(boolean(mets:xmlData/ddilc32:* or mets:xmlData/ddilc31:* or mets:xmlData/ddicb25:* or mets:xmlData/ddicb21:*))*count(mets:xmlData/*)
                          + number(normalize-space(@MDTYPE)='TEXTMD')*number(boolean(mets:xmlData/textmd_kdk:*))*count(mets:xmlData/*)) = 1"/>
                <sch:param name="used_attribute" value="@MDTYPE"/>
                <sch:param name="specifications" value="string('1.4.1; 1.4')"/>
        </sch:pattern>
        <sch:pattern id="mets_othermdtype_content_old" is-a="required_metadata_match_pattern">
                <sch:param name="context_condition" value="@OTHERMDTYPE"/>
                <sch:param name="required_condition" value="(number(normalize-space(@OTHERMDTYPE)='ADDML')*number(boolean(mets:xmlData/addml:*))*count(mets:xmlData/*)
                          + number(normalize-space(@OTHERMDTYPE)='AudioMD')*number(boolean(mets:xmlData/audiomd:*))*count(mets:xmlData/*)
                          + number(normalize-space(@OTHERMDTYPE)='VideoMD')*number(boolean(mets:xmlData/videomd:*))*count(mets:xmlData/*)
                          + number(normalize-space(@OTHERMDTYPE)='EAD3')*number(boolean(mets:xmlData/ead3:*))*count(mets:xmlData/*)
                          + number(normalize-space(@OTHERMDTYPE)!='ADDML' and normalize-space(@OTHERMDTYPE)!='AudioMD' and normalize-space(@OTHERMDTYPE)!='VideoMD' and normalize-space(@OTHERMDTYPE)!='EAD3')*count(mets:xmlData/*)) = 1"/>
                <sch:param name="used_attribute" value="@OTHERMDTYPE"/>
                <sch:param name="specifications" value="string('1.4; 1.4.1; 1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>
        <sch:pattern id="mets_allowedmd_unsupported_old" is-a="allowed_unsupported_metadata_pattern">
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_condition" value="@OTHERMDTYPE!='AudioMD' and @OTHERMDTYPE!='VideoMD' and @OTHERMDTYPE!='EN15744' and @OTHERMDTYPE!='EAD3' and @OTHERMDTYPE!='ADDML'"/>
                <sch:param name="specifications" value="string('1.4; 1.4.1; 1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>

        <!-- Notify deprecation of using rightsStatement as root element in rightsMD, in specification 1.5.0 -->
        <sch:pattern id="mets_deprecated_rightsStatement" is-a="deprecated_element_pattern">
                <sch:param name="context_element" value="mets:xmlData"/>
                <sch:param name="context_condition" value="../@MDTYPE='PREMIS:RIGHTS'"/>
                <sch:param name="deprecated_element" value="premis:rightsStatement"/>
                <sch:param name="specifications" value="string('1.5.0')"/>
        </sch:pattern>

	<!-- Standard portfolio descriptive metadata formats with old specifications -->
        <sch:pattern id="mets_descriptive_exists_old" is-a="required_metadata_pattern">
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_metadata" value="mets:dmdSec/mets:mdWrap[@MDTYPE='LIDO' or @MDTYPE='EAC-CPF' or @MDTYPE='EAD' or @OTHERMDTYPE='EAD3'
                or @MDTYPE='VRA' or @MDTYPE='MODS' or @MDTYPE='MARC' or @MDTYPE='DC' or @MDTYPE='DDI' or @OTHERMDTYPE='EN15744']"/>
                <sch:param name="metadata_name" value="string('Standard portfolio descriptive')"/>
                <sch:param name="specifications" value="string('1.4; 1.4.1; 1.5.0; 1.6.0; 1.6.1')"/>
        </sch:pattern>



	<!-- File format specific technical metadata requirements with specifications 1.4 -->
	<sch:let name="textmd_fileid" value="/mets:mets/mets:amdSec/mets:techMD[contains(concat(' ', $textmd_types, ' '), concat(' ', normalize-space(.//premis:formatName), ' '))]/@ID"/>
	<sch:let name="textmd14_mdids" value="/mets:mets/mets:amdSec/mets:techMD[.//textmd_kdk:*]/@ID"/>
	<sch:let name="textmd_countfiles" value="count(sets:distinct(exsl:node-set($textmd_fileid)))"/>
	<sch:let name="textmd14_countmd" value="count(sets:distinct(exsl:node-set($textmd14_mdids)))"/>
	<sch:pattern id="textmd_requirement14">
        	<sch:rule context="mets:file">
			<sch:let name="given_specification" value="substring-before(concat(normalize-space(concat(normalize-space(/mets:mets/@fi:CATALOG), ' ', normalize-space(/mets:mets/@fikdk:CATALOG), ' ', normalize-space(/mets:mets/@fi:SPECIFICATION), ' ', normalize-space(/mets:mets/@fikdk:SPECIFICATION))), ' '), ' ')"/>
			<sch:let name="admids" value="normalize-space(@ADMID)"/>
			<sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
			<sch:let name="countfilescomb" value="count(sets:distinct(exsl:node-set($textmd_fileid) | str:tokenize($admids, ' ')))"/>
			<sch:let name="countmdcomb" value="count(sets:distinct(exsl:node-set($textmd14_mdids) | str:tokenize($admids, ' ')))"/>
			<sch:assert test="(($textmd_countfiles+$countadm)=$countfilescomb) or not(($textmd14_countmd+$countadm)=$countmdcomb)
                        or not(contains(' 1.4 1.4.1 ', concat(' ', $given_specification,' ')))">
				Linking between TextMD metadata and file '<sch:value-of select="./mets:FLocat/@xlink:href"/>' is required.
			</sch:assert>
		</sch:rule>
	</sch:pattern>
	<sch:let name="addml14_mdids" value="/mets:mets/mets:amdSec/mets:techMD[.//addml:*]/@ID"/>
	<sch:let name="addml14_countmd" value="count(sets:distinct(exsl:node-set($addml14_mdids)))"/>
	<sch:pattern id="addml_requirement14">
        	<sch:rule context="mets:file">
			<sch:let name="given_specification" value="substring-before(concat(normalize-space(concat(normalize-space(/mets:mets/@fi:CATALOG), ' ', normalize-space(/mets:mets/@fikdk:CATALOG), ' ', normalize-space(/mets:mets/@fi:SPECIFICATION), ' ', normalize-space(/mets:mets/@fikdk:SPECIFICATION))), ' '), ' ')"/>
			<sch:let name="admids" value="normalize-space(@ADMID)"/>
			<sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
			<sch:let name="countfilescomb" value="count(sets:distinct(exsl:node-set($addml_fileid) | str:tokenize($admids, ' ')))"/>
			<sch:let name="countmdcomb" value="count(sets:distinct(exsl:node-set($addml14_mdids) | str:tokenize($admids, ' ')))"/>
			<sch:assert test="(($addml_countfiles+$countadm)=$countfilescomb) or not(($addml14_countmd+$countadm)=$countmdcomb)
                        or not(contains(' 1.4 1.4.1 ', concat(' ', $given_specification,' ')))">
				Linking between ADDML metadata and file '<sch:value-of select="./mets:FLocat/@xlink:href"/>' is required.
			</sch:assert>
		</sch:rule>
	</sch:pattern>
	<sch:let name="audiomd14_mdids" value="/mets:mets/mets:amdSec/mets:techMD[.//audiomd:*]/@ID"/>
	<sch:let name="audiomd14_countmd" value="count(sets:distinct(exsl:node-set($audiomd14_mdids)))"/>
	<sch:pattern id="audiomd_requirement14">
        	<sch:rule context="mets:file">
			<sch:let name="given_specification" value="substring-before(concat(normalize-space(concat(normalize-space(/mets:mets/@fi:CATALOG), ' ', normalize-space(/mets:mets/@fikdk:CATALOG), ' ', normalize-space(/mets:mets/@fi:SPECIFICATION), ' ', normalize-space(/mets:mets/@fikdk:SPECIFICATION))), ' '), ' ')"/>
			<sch:let name="admids" value="normalize-space(@ADMID)"/>
			<sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
			<sch:let name="countfilescomb" value="count(sets:distinct(exsl:node-set($audiomd_fileid) | str:tokenize($admids, ' ')))"/>
			<sch:let name="countmdcomb" value="count(sets:distinct(exsl:node-set($audiomd14_mdids) | str:tokenize($admids, ' ')))"/>
			<sch:assert test="(($audiomd_countfiles+$countadm)=$countfilescomb) or not(($audiomd14_countmd+$countadm)=$countmdcomb)
                        or not(contains(' 1.4 1.4.1 ', concat(' ', $given_specification,' ')))">
				Linking between AudioMD metadata and file '<sch:value-of select="./mets:FLocat/@xlink:href"/>' is required.
			</sch:assert>
		</sch:rule>
	</sch:pattern>
	<sch:let name="videomd14_mdids" value="/mets:mets/mets:amdSec/mets:techMD[.//videomd:*]/@ID"/>
	<sch:let name="videomd14_countmd" value="count(sets:distinct(exsl:node-set($videomd14_mdids)))"/>
	<sch:pattern id="videomd_requirement14">
        	<sch:rule context="mets:file">
			<sch:let name="admids" value="normalize-space(@ADMID)"/>
			<sch:let name="given_specification" value="substring-before(concat(normalize-space(concat(normalize-space(/mets:mets/@fi:CATALOG), ' ', normalize-space(/mets:mets/@fikdk:CATALOG), ' ', normalize-space(/mets:mets/@fi:SPECIFICATION), ' ', normalize-space(/mets:mets/@fikdk:SPECIFICATION))), ' '), ' ')"/>
			<sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
			<sch:let name="countfilescomb" value="count(sets:distinct(exsl:node-set($videomd_fileid) | str:tokenize($admids, ' ')))"/>
			<sch:let name="countmdcomb" value="count(sets:distinct(exsl:node-set($videomd14_mdids) | str:tokenize($admids, ' ')))"/>
			<sch:assert test="(($videomd_countfiles+$countadm)=$countfilescomb) or not(($videomd14_countmd+$countadm)=$countmdcomb)
                        or not(contains(' 1.4 1.4.1 ', concat(' ', $given_specification,' ')))">
				Linking between VideoMD metadata and file '<sch:value-of select="./mets:FLocat/@xlink:href"/>' is required.
			</sch:assert>
		</sch:rule>
	</sch:pattern>
	<sch:let name="mix14_mdids" value="/mets:mets/mets:amdSec/mets:techMD[.//mix:*]/@ID"/>
	<sch:let name="mix14_countmd" value="count(sets:distinct(exsl:node-set($mix14_mdids)))"/>
	<sch:pattern id="mix_requirement14">
		<sch:rule context="mets:file">
			<sch:let name="admids" value="normalize-space(@ADMID)"/>
			<sch:let name="given_specification" value="substring-before(concat(normalize-space(concat(normalize-space(/mets:mets/@fi:CATALOG), ' ', normalize-space(/mets:mets/@fikdk:CATALOG), ' ', normalize-space(/mets:mets/@fi:SPECIFICATION), ' ', normalize-space(/mets:mets/@fikdk:SPECIFICATION))), ' '), ' ')"/>
			<sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
			<sch:let name="countfilescomb" value="count(sets:distinct(exsl:node-set($mix_fileid) | str:tokenize($admids, ' ')))"/>
			<sch:let name="countmdcomb" value="count(sets:distinct(exsl:node-set($mix14_mdids) | str:tokenize($admids, ' ')))"/>
			<sch:assert test="(($mix_countfiles+$countadm)=$countfilescomb) or not(($mix14_countmd+$countadm)=$countmdcomb)
                        or not(contains(' 1.4 1.4.1 ', concat(' ', $given_specification,' ')))">
				Linking between NISOIMG (MIX) metadata and file '<sch:value-of select="./mets:FLocat/@xlink:href"/>' is required.
			</sch:assert>
		</sch:rule>
	</sch:pattern>



</sch:schema>
