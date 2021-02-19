<?xml version="1.0" encoding="UTF-8"?>

<!-- pass-filter: /mets:mets/mets:fileSec -->
<!-- context-filter: mets:fileSec|mets:fileGrp|mets:file|mets:FLocat|mets:stream -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.7.3">
	<sch:title>METS fileSec validation</sch:title>

<!--
Validates METS fileSec.
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
        <sch:ns prefix="mix" uri="http://www.loc.gov/mix/v20"/>
        <sch:ns prefix="addml" uri="http://www.arkivverket.no/standarder/addml"/>
        <sch:ns prefix="audiomd" uri="http://www.loc.gov/audioMD/"/>
        <sch:ns prefix="videomd" uri="http://www.loc.gov/videoMD/"/>
        <sch:ns prefix="premis" uri="info:lc/xmlns/premis-v2"/>

        <sch:include href="./abstracts/allowed_attribute_list_pattern.incl"/>
	<sch:include href="./abstracts/disallowed_attribute_pattern.incl"/>
	<sch:include href="./abstracts/disallowed_element_pattern.incl"/>
	<sch:include href="./abstracts/required_attribute_pattern.incl"/>
	<sch:include href="./abstracts/required_element_pattern.incl"/>
	<sch:include href="./abstracts/required_max_elements_pattern.incl"/>
	<sch:include href="./abstracts/required_values_attribute_pattern.incl"/>

	<!-- File formats of metadata types -->
        <sch:let name="addml_types" value="string('text/csv')"/>
        <sch:let name="audiomd_types" value="string('audio/x-aiff audio/x-wave audio/flac audio/mp4 audio/x-wav audio/mpeg audio/x-ms-wma')"/>
        <sch:let name="mix_types" value="string('image/tiff image/jpeg image/jp2 image/png image/gif image/x-dpx')"/>
        <sch:let name="videomd_types" value="string('video/jpeg2000 video/mp4 video/dv video/mpeg video/x-ms-wmv video/x-ffv')"/>

        <!-- techmd elements -->
        <sch:let name="techmd" value="/mets:mets/mets:amdSec/mets:techMD"/>

        <!-- techMd section ids of different metadata -->
        <sch:let name="premis_file_id" value="$techmd[normalize-space(./mets:mdWrap/@MDTYPE)='PREMIS:OBJECT' and normalize-space(./mets:mdWrap/mets:xmlData/premis:object/@xsi:type)='premis:file']/@ID"/>
        <sch:let name="premis_stream_id" value="$techmd[normalize-space(./mets:mdWrap/@MDTYPE)='PREMIS:OBJECT' and normalize-space(./mets:mdWrap/mets:xmlData/premis:object/@xsi:type)='premis:bitstream']/@ID"/>
        <sch:let name="addml_mdids" value="$techmd[normalize-space(./mets:mdWrap/@OTHERMDTYPE)='ADDML' and ./mets:mdWrap/mets:xmlData/addml:*]/@ID"/>
        <sch:let name="audiomd_mdids" value="$techmd[normalize-space(./mets:mdWrap/@OTHERMDTYPE)='AudioMD' and ./mets:mdWrap/mets:xmlData/audiomd:*]/@ID"/>
        <sch:let name="mix_mdids" value="$techmd[normalize-space(./mets:mdWrap/@MDTYPE)='NISOIMG' and ./mets:mdWrap/mets:xmlData/mix:*]/@ID"/>
        <sch:let name="videomd_mdids" value="$techmd[normalize-space(./mets:mdWrap/@OTHERMDTYPE)='VideoMD' and ./mets:mdWrap/mets:xmlData/videomd:*]/@ID"/>

	<!-- PREMIS object ids of different file format types -->
        <sch:let name="addml_fileid" value="$premis_file_id[contains(concat(' ', $addml_types, ' '), concat(' ', normalize-space(../mets:mdWrap/mets:xmlData/premis:object/premis:objectCharacteristics/premis:format/premis:formatDesignation/premis:formatName), ' '))]"/>
        <sch:let name="audiomd_fileid" value="$premis_file_id[contains(concat(' ', $audiomd_types, ' '), concat(' ', normalize-space(../mets:mdWrap/mets:xmlData/premis:object/premis:objectCharacteristics/premis:format/premis:formatDesignation/premis:formatName), ' '))]"/>
        <sch:let name="audiomd_fileid_stream" value="$premis_stream_id[contains(concat(' ', $audiomd_types, ' '), concat(' ', normalize-space(../mets:mdWrap/mets:xmlData/premis:object/premis:objectCharacteristics/premis:format/premis:formatDesignation/premis:formatName), ' '))]"/>
        <sch:let name="mix_fileid" value="$premis_file_id[contains(concat(' ', $mix_types, ' '), concat(' ', normalize-space(../mets:mdWrap/mets:xmlData/premis:object/premis:objectCharacteristics/premis:format/premis:formatDesignation/premis:formatName), ' '))]"/>
        <sch:let name="videomd_fileid" value="$premis_file_id[contains(concat(' ', $videomd_types, ' '), concat(' ', normalize-space(../mets:mdWrap/mets:xmlData/premis:object/premis:objectCharacteristics/premis:format/premis:formatDesignation/premis:formatName), ' '))]"/>
        <sch:let name="videomd_fileid_stream" value="$premis_stream_id[contains(concat(' ', $videomd_types, ' '), concat(' ', normalize-space(../mets:mdWrap/mets:xmlData/premis:object/premis:objectCharacteristics/premis:format/premis:formatDesignation/premis:formatName), ' '))]"/>

	<!-- Section ids of different requirements -->
        <sch:let name="csv_fileid" value="$addml_fileid[../mets:mdWrap/mets:xmlData/premis:object/premis:objectCharacteristics/premis:format/premis:formatDesignation/premis:formatName='text/csv']"/>
        <sch:let name="jp2_fileid" value="$mix_fileid[../mets:mdWrap/mets:xmlData/premis:object/premis:objectCharacteristics/premis:format/premis:formatDesignation/premis:formatName='image/jp2']"/>
        <sch:let name="not_jp2_fileid" value="$premis_file_id[../mets:mdWrap/mets:xmlData/premis:object/premis:objectCharacteristics/premis:format/premis:formatDesignation/premis:formatName!='image/jp2']"/>
        <sch:let name="tiff_fileid" value="$mix_fileid[../mets:mdWrap/mets:xmlData/premis:object/premis:objectCharacteristics/premis:format/premis:formatDesignation/premis:formatName='image/tiff' or ../mets:mdWrap/mets:xmlData/premis:object/premis:objectCharacteristics/premis:format/premis:formatDesignation/premis:formatName='image/x-dpx']"/>

	<!-- ID count -->
        <sch:let name="addml_countfiles" value="count($addml_fileid)"/>
        <sch:let name="addml_countmd" value="count($addml_mdids)"/>
        <sch:let name="audiomd_countfiles" value="count($audiomd_fileid)"/>
        <sch:let name="audiomd_countfiles_stream" value="count($audiomd_fileid_stream)"/>
        <sch:let name="audiomd_countmd" value="count($audiomd_mdids)"/>
        <sch:let name="csv_countaddmlfsc" value="count($csv_addmlfscids)"/>
        <sch:let name="csv_countaddmlrs" value="count($csv_addmlrsids)"/>
        <sch:let name="csv_countfiles" value="count($csv_fileid)"/>
        <sch:let name="jp2_countfiles" value="count($jp2_fileid)"/>
        <sch:let name="jp2_countmixjp2" value="count($jp2_mixjp2ids)"/>
        <sch:let name="jp2_countmixsfc" value="count($jp2_mixsfcids)"/>
        <sch:let name="mix_countfiles" value="count($mix_fileid)"/>
        <sch:let name="mix_countmd" value="count($mix_mdids)"/>
        <sch:let name="not_jp2_countfiles" value="count($not_jp2_fileid)"/>
        <sch:let name="premis_file_count" value="count($premis_file_id)"/>
        <sch:let name="premis_stream_count" value="count($premis_stream_id)"/>
        <sch:let name="tiff_countfiles" value="count($tiff_fileid)"/>
        <sch:let name="tiff_countmix" value="count($tiff_mixids)"/>
        <sch:let name="videomd_countfiles" value="count($videomd_fileid)"/>
        <sch:let name="videomd_countfiles_stream" value="count($videomd_fileid_stream)"/>
        <sch:let name="videomd_countmd" value="count($videomd_mdids)"/>

	<!-- Required special elements -->
        <sch:let name="csv_addmlfscids" value="$addml_mdids[../mets:mdWrap/mets:xmlData/addml:addml/addml:dataset/addml:flatFiles/addml:structureTypes/addml:flatFileTypes/addml:flatFileType/addml:delimFileFormat/addml:fieldSeparatingChar]"/>
        <sch:let name="csv_addmlrsids" value="$addml_mdids[../mets:mdWrap/mets:xmlData/addml:addml/addml:dataset/addml:flatFiles/addml:structureTypes/addml:flatFileTypes/addml:flatFileType/addml:delimFileFormat/addml:recordSeparator]"/>
        <sch:let name="jp2_mixjp2ids" value="$mix_mdids[../mets:mdWrap/mets:xmlData/mix:mix/mix:BasicImageInformation/mix:SpecialFormatCharacteristics/mix:JPEG2000]"/>
        <sch:let name="jp2_mixsfcids" value="$mix_mdids[../mets:mdWrap/mets:xmlData/mix:mix/mix:BasicImageInformation/mix:SpecialFormatCharacteristics]"/>
        <sch:let name="tiff_mixids" value="$mix_mdids[../mets:mdWrap/mets:xmlData/mix:mix/mix:BasicDigitalObjectInformation/mix:byteOrder]"/>
        <sch:let name="digiprovmd_migration" value="exsl:node-set(/mets:mets/mets:amdSec/mets:digiprovMD[(normalize-space(./mets:mdWrap/mets:xmlData/premis:event/premis:eventType)='migration' or normalize-space(./mets:mdWrap/mets:xmlData/premis:event/premis:eventType)='normalization') and normalize-space(./mets:mdWrap/mets:xmlData/premis:event/premis:eventOutcomeInformation/premis:eventOutcome)='success'])"/>

        <!-- METS internal linking, cross-check part 1: From link to target -->
        <sch:let name="admids_targets" value="/mets:mets/mets:amdSec/*/@ID"/>
        <sch:let name="admids_target_count" value="count($admids_targets)"/>

	<!-- METS internal linking, cross-check part 2: From target to link -->
	<sch:let name="fileidfptrlinks" value="/mets:mets/mets:structMap//mets:fptr"/>
	<sch:let name="fileidarealinks" value="/mets:mets/mets:structMap//mets:area"/>

	<!-- Allow only given attributes -->
        <sch:pattern id="mets_fileSec_attribute_list" is-a="allowed_attribute_list_pattern">
                <sch:param name="context_element" value="mets:fileSec"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="allowed_attributes" value="@ID"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="mets_fileGrp_attribute_list" is-a="allowed_attribute_list_pattern">
                <sch:param name="context_element" value="mets:fileGrp"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="allowed_attributes" value="@ID | @USE | @ADMID | @VERSDATE"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="mets_file_attribute_list" is-a="allowed_attribute_list_pattern">
                <sch:param name="context_element" value="mets:file"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="allowed_attributes" value="@ID | @GROUPID | @OWNERID | @USE | @ADMID | @MIMETYPE | @SIZE | @CREATED | @CHECKSUM | @CHECKSUMTYPE | @SEQ | @DMDID | @BEGIN | @END | @BETYPE"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

	<!-- Elements and attributes inside fileSec -->
	<sch:pattern id="mets_fileGrp_file" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:fileGrp"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mets:file"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_file_ADMID" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:fileGrp/mets:file"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@ADMID"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_file_CHECKSUM" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:fileGrp/mets:file"/>
		<sch:param name="context_condition" value="@CHECKSUMTYPE"/>
		<sch:param name="required_attribute" value="@CHECKSUM"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_file_CHECKSUMTYPE" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:fileGrp/mets:file"/>
		<sch:param name="context_condition" value="@CHECKSUM"/>
		<sch:param name="required_attribute" value="@CHECKSUMTYPE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_file_FLocat" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:fileGrp/mets:file"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mets:FLocat"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_file_FLocat_max" is-a="required_max_elements_pattern">
		<sch:param name="context_element" value="mets:fileGrp/mets:file"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mets:FLocat"/>
		<sch:param name="num" value="1"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_file_FContent" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:fileGrp/mets:file"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mets:FContent"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_file_file" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:fileGrp/mets:file"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mets:file"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_file_transformFile" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:fileGrp/mets:file"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mets:transformFile"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- FLocat attributes -->
	<sch:pattern id="mets_FLocat_href" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:FLocat"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@xlink:href"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_FLocat_type" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:FLocat"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@xlink:type"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_FLocat_OTHERLOCTYPE" is-a="disallowed_attribute_pattern">
		<sch:param name="context_element" value="mets:FLocat"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@OTHERLOCTYPE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_FLocat_LOCTYPE" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:FLocat"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@LOCTYPE"/>
		<sch:param name="valid_values" value="string('URL')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_FLocat_type_values" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:FLocat"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@xlink:type"/>
		<sch:param name="valid_values" value="string('simple')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

        <!-- METS internal linking, cross-check part 1: From link to target -->
        <sch:pattern id="link_file_admid">
                <sch:rule context="mets:fileGrp/mets:file[@ADMID]">
                        <sch:assert test="count(sets:distinct(str:tokenize(normalize-space(@ADMID),' ') | exsl:node-set($admids_targets))) = $admids_target_count">
                                Value '<sch:value-of select="@ADMID"/>' in attribute '<sch:value-of select="name(@ADMID)"/>' in element '<sch:name/>' contains a link to nowhere. The corresponding target attribute '@ID' with the same value was not found.
                        </sch:assert>
                </sch:rule>
        </sch:pattern>
        <sch:pattern id="link_stream_admid">
                <sch:rule context="mets:stream[@ADMID]">
                        <sch:assert test="count(sets:distinct(str:tokenize(normalize-space(@ADMID),' ') | exsl:node-set($admids_targets))) = $admids_target_count">
                                Value '<sch:value-of select="@ADMID"/>' in attribute '<sch:value-of select="name(@ADMID)"/>' in element '<sch:name/>' contains a link to nowhere. The corresponding target attribute '@ID' with the same value was not found.
                        </sch:assert>
                </sch:rule>
        </sch:pattern>

	<!-- METS internal linking, cross-check part 2: From target to link -->
	<sch:pattern id="id_references_file">
        <sch:rule context="mets:fileGrp/mets:file">
			<sch:let name="id" value="normalize-space(@ID)"/>
			<sch:assert test="count($fileidfptrlinks[contains(concat(' ', normalize-space(@FILEID), ' '), concat(' ', $id, ' '))]) &gt; 0
			or count($fileidarealinks[contains(concat(' ', normalize-space(@FILEID), ' '), concat(' ', $id, ' '))]) &gt; 0">
				Section containing value '<sch:value-of select="@ID"/>' in attribute '<sch:value-of select="name(@ID)"/>' in element '<sch:value-of select="name(.)"/>' requires a reference from attribute '@FILEID'.
			</sch:assert>
        </sch:rule>
	</sch:pattern>

        <!-- Require PREMIS:OBJECTs for files -->
        <sch:pattern id="premis_file_requirement">
        	<sch:rule context="mets:fileGrp/mets:file">
                        <sch:let name="admids" value="normalize-space(@ADMID)"/>
                        <sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
                        <sch:let name="countfilescomb_premis" value="count(sets:distinct(exsl:node-set($premis_file_id) | str:tokenize($admids, ' ')))"/>
                        <sch:assert test="($premis_file_count+$countadm) &gt; $countfilescomb_premis">
                                Linking between PREMIS:OBJECT metadata and file '<sch:value-of select="./mets:FLocat/@xlink:href"/>' is required.
                        </sch:assert>
                </sch:rule>
    	</sch:pattern>
        <sch:pattern id="premis_stream_requirement">
        <sch:rule context="mets:stream">
                        <sch:let name="given_specification" value="substring-before(concat(normalize-space(concat(normalize-space(/mets:mets/@fi:CATALOG), ' ', normalize-space(/mets:mets/@fikdk:CATALOG), ' ', normalize-space(/mets:mets/@fi:SPECIFICATION), ' ', normalize-space(/mets:mets/@fikdk:SPECIFICATION))), ' '), ' ')"/>
                        <sch:let name="admids" value="normalize-space(@ADMID)"/>
                        <sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
                        <sch:let name="countfilescomb_premis_stream" value="count(sets:distinct(exsl:node-set($premis_stream_id) | str:tokenize($admids, ' ')))"/>
                        <sch:assert test="(($premis_stream_count+$countadm) &gt; $countfilescomb_premis_stream)
			or contains(' 1.5.0 ', concat(' ', $given_specification,' '))">
                                Linking between PREMIS:OBJECT metadata and stream in file '<sch:value-of select="../mets:FLocat/@xlink:href"/>' is required.
                        </sch:assert>
                </sch:rule>
    	</sch:pattern>

        <!-- File format specific technical metadata requirements -->
        <sch:pattern id="audiomd_requirement_stream">
                <sch:rule context="mets:stream">
                        <sch:let name="given_specification" value="substring-before(concat(normalize-space(concat(normalize-space(/mets:mets/@fi:CATALOG), ' ', normalize-space(/mets:mets/@fikdk:CATALOG), ' ', normalize-space(/mets:mets/@fi:SPECIFICATION), ' ', normalize-space(/mets:mets/@fikdk:SPECIFICATION))), ' '), ' ')"/>
                        <sch:let name="admids" value="normalize-space(@ADMID)"/>
                        <sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
                        <sch:let name="countfilescomb_audio_stream" value="count(sets:distinct(exsl:node-set($audiomd_fileid_stream) | str:tokenize($admids, ' ')))"/>
                        <sch:let name="countmdcomb_audio_stream" value="count(sets:distinct(exsl:node-set($audiomd_mdids) | str:tokenize($admids, ' ')))"/>
                        <sch:assert test="(($audiomd_countfiles_stream+$countadm)=$countfilescomb_audio_stream) or not(($audiomd_countmd+$countadm)=$countmdcomb_audio_stream)
                        or contains(' 1.5.0 ', concat(' ', $given_specification,' '))">
                                Linking between AudioMD metadata and stream in file '<sch:value-of select="../mets:FLocat/@xlink:href"/>' is required.
                        </sch:assert>
                </sch:rule>
        </sch:pattern>
        <sch:pattern id="videomd_requirement_stream">
                <sch:rule context="mets:stream">
                        <sch:let name="given_specification" value="substring-before(concat(normalize-space(concat(normalize-space(/mets:mets/@fi:CATALOG), ' ', normalize-space(/mets:mets/@fikdk:CATALOG), ' ', normalize-space(/mets:mets/@fi:SPECIFICATION), ' ', normalize-space(/mets:mets/@fikdk:SPECIFICATION))), ' '), ' ')"/>
                        <sch:let name="admids" value="normalize-space(@ADMID)"/>
                        <sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
                        <sch:let name="countfilescomb_video_stream" value="count(sets:distinct(exsl:node-set($videomd_fileid_stream) | str:tokenize($admids, ' ')))"/>
                        <sch:let name="countmdcomb_video_stream" value="count(sets:distinct(exsl:node-set($videomd_mdids) | str:tokenize($admids, ' ')))"/>
                        <sch:assert test="(($videomd_countfiles_stream+$countadm)=$countfilescomb_video_stream) or not(($videomd_countmd+$countadm)=$countmdcomb_video_stream)
                        or contains(' 1.5.0 ', concat(' ', $given_specification,' '))">
                                Linking between VideoMD metadata and stream in file '<sch:value-of select="../mets:FLocat/@xlink:href"/>' is required.
                        </sch:assert>
                </sch:rule>
        </sch:pattern>
        <sch:pattern id="addml_requirement">
                <sch:rule context="mets:fileGrp/mets:file">
                        <sch:let name="admids" value="normalize-space(@ADMID)"/>
                        <sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
                        <sch:let name="countfilescomb_addml" value="count(sets:distinct(exsl:node-set($addml_fileid) | str:tokenize($admids, ' ')))"/>
                        <sch:let name="countmdcomb_addml" value="count(sets:distinct(exsl:node-set($addml_mdids) | str:tokenize($admids, ' ')))"/>
                        <sch:assert test="(($addml_countfiles+$countadm)=$countfilescomb_addml) or not(($addml_countmd+$countadm)=$countmdcomb_addml)">
                                Linking between ADDML metadata and file '<sch:value-of select="./mets:FLocat/@xlink:href"/>' is required.
                        </sch:assert>
                </sch:rule>
        </sch:pattern>
        <sch:pattern id="audiomd_requirement">
                <sch:rule context="mets:fileGrp/mets:file">
                        <sch:let name="admids" value="normalize-space(@ADMID)"/>
                        <sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
                        <sch:let name="countfilescomb_audiomd" value="count(sets:distinct(exsl:node-set($audiomd_fileid) | str:tokenize($admids, ' ')))"/>
                        <sch:let name="countmdcomb_audiomd" value="count(sets:distinct(exsl:node-set($audiomd_mdids) | str:tokenize($admids, ' ')))"/>
                        <sch:assert test="(($audiomd_countfiles+$countadm)=$countfilescomb_audiomd) or not(($audiomd_countmd+$countadm)=$countmdcomb_audiomd)">
                                Linking between AudioMD metadata and file '<sch:value-of select="./mets:FLocat/@xlink:href"/>' is required.
                        </sch:assert>
                </sch:rule>
        </sch:pattern>
        <sch:pattern id="videomd_requirement">
                <sch:rule context="mets:fileGrp/mets:file[not(mets:stream)]">
                        <sch:let name="admids" value="normalize-space(@ADMID)"/>
                        <sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
                        <sch:let name="countfilescomb_videomd" value="count(sets:distinct(exsl:node-set($videomd_fileid) | str:tokenize($admids, ' ')))"/>
                        <sch:let name="countmdcomb_videomd" value="count(sets:distinct(exsl:node-set($videomd_mdids) | str:tokenize($admids, ' ')))"/>
                        <sch:assert test="(($videomd_countfiles+$countadm)=$countfilescomb_videomd) or not(($videomd_countmd+$countadm)=$countmdcomb_videomd)">
                                Linking between VideoMD metadata and file '<sch:value-of select="./mets:FLocat/@xlink:href"/>' is required.
                        </sch:assert>
                </sch:rule>
        </sch:pattern>
        <sch:pattern id="mix_requirement">
                <sch:rule context="mets:fileGrp/mets:file">
                        <sch:let name="admids" value="normalize-space(@ADMID)"/>
                        <sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
                        <sch:let name="countfilescomb_mix" value="count(sets:distinct(exsl:node-set($mix_fileid) | str:tokenize($admids, ' ')))"/>
                        <sch:let name="countmdcomb_mix" value="count(sets:distinct(exsl:node-set($mix_mdids) | str:tokenize($admids, ' ')))"/>
                        <sch:assert test="(($mix_countfiles+$countadm)=$countfilescomb_mix) or not(($mix_countmd+$countadm)=$countmdcomb_mix)">
                                Linking between NISOIMG (MIX) metadata and file '<sch:value-of select="./mets:FLocat/@xlink:href"/>' is required.
                        </sch:assert>
                </sch:rule>
        </sch:pattern>

        <sch:pattern id="csv_addml_requirements">
                <sch:rule context="mets:fileGrp/mets:file">
                        <sch:let name="admids" value="normalize-space(@ADMID)"/>
                        <sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
                        <sch:let name="countfilescomb_csv" value="count(sets:distinct(exsl:node-set($csv_fileid) | str:tokenize($admids, ' ')))"/>
                        <sch:let name="countaddmlrscomb" value="count(sets:distinct(exsl:node-set($csv_addmlrsids) | str:tokenize($admids, ' ')))"/>
                        <sch:let name="countaddmlfsccomb" value="count(sets:distinct(exsl:node-set($csv_addmlfscids) | str:tokenize($admids, ' ')))"/>
                        <sch:assert test="(($csv_countfiles+$countadm)=$countfilescomb_csv) or not(($csv_countaddmlrs+$countadm)=$countaddmlrscomb)">
                                Element 'recordSeparator' is required in ADDML metadata for file '<sch:value-of select="./mets:FLocat/@xlink:href"/>'.
                        </sch:assert>
                        <sch:assert test="(($csv_countfiles+$countadm)=$countfilescomb_csv) or not(($csv_countaddmlfsc+$countadm)=$countaddmlfsccomb)">
                                Element 'fieldSeparatingChar' is required in ADDML metadata for file '<sch:value-of select="./mets:FLocat/@xlink:href"/>'.
                        </sch:assert>
                </sch:rule>
        </sch:pattern>

        <!-- JPEG2000 specific check -->
        <sch:pattern id="jpeg2000_requirements">
        	<sch:rule context="mets:fileGrp/mets:file">
                        <sch:let name="admids" value="normalize-space(@ADMID)"/>
                        <sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
                        <sch:let name="countfilescomb_jpeg2000" value="count(sets:distinct(exsl:node-set($jp2_fileid) | str:tokenize($admids, ' ')))"/>
                        <sch:let name="countmixsfccomb" value="count(sets:distinct(exsl:node-set($jp2_mixsfcids) | str:tokenize($admids, ' ')))"/>
                        <sch:let name="countmixjp2comb" value="count(sets:distinct(exsl:node-set($jp2_mixjp2ids) | str:tokenize($admids, ' ')))"/>
                        <sch:assert test="(($jp2_countfiles+$countadm)=$countfilescomb_jpeg2000) or not(($jp2_countmixsfc+$countadm)=$countmixsfccomb)">
                                Element 'SpecialFormatCharacteristics' is required in NISOIMG (MIX) metadata for file '<sch:value-of select="./mets:FLocat/@xlink:href"/>'.
                        </sch:assert>
                        <sch:assert test="(($jp2_countfiles+$countadm)=$countfilescomb_jpeg2000) or not(($jp2_countmixjp2+$countadm)=$countmixjp2comb)">
                                Element 'JPEG2000' is required in NISOIMG (MIX) metadata for file '<sch:value-of select="./mets:FLocat/@xlink:href"/>'.
                        </sch:assert>
                </sch:rule>
        </sch:pattern>

        <!-- Not JPEG2000 file - specific check -->
        <sch:pattern id="jpeg2000_disallowed">
        	<sch:rule context="mets:fileGrp/mets:file">
                        <sch:let name="admids" value="normalize-space(@ADMID)"/>
                        <sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
                        <sch:let name="countfilescomb_jpeg2000_not" value="count(sets:distinct(exsl:node-set($not_jp2_fileid) | str:tokenize($admids, ' ')))"/>
                        <sch:let name="countmixjp2comb" value="count(sets:distinct(exsl:node-set($jp2_mixjp2ids) | str:tokenize($admids, ' ')))"/>
                        <sch:assert test="(($not_jp2_countfiles+$countadm)=$countfilescomb_jpeg2000_not) or (($jp2_countmixjp2+$countadm)=$countmixjp2comb)">
                                Element 'JPEG2000' is not allowed in NISOIMG (MIX) metadata for file '<sch:value-of select="./mets:FLocat/@xlink:href"/>'.
                        </sch:assert>
                </sch:rule>
        </sch:pattern>

        <!-- TIFF and DPX specific check -->
        <sch:pattern id="tiff_byteorder">
                <sch:rule context="mets:fileGrp/mets:file">
                        <sch:let name="admids" value="normalize-space(@ADMID)"/>
                        <sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
                        <sch:let name="countfilescomb_byteorder" value="count(sets:distinct(exsl:node-set($tiff_fileid) | str:tokenize($admids, ' ')))"/>
                        <sch:let name="countmixcomb" value="count(sets:distinct(exsl:node-set($tiff_mixids) | str:tokenize($admids, ' ')))"/>
                        <sch:assert test="(($tiff_countfiles+$countadm)=$countfilescomb_byteorder) or not(($tiff_countmix+$countadm)=$countmixcomb)">
                                Element 'byteOrder' is required in NISOIMG (MIX) metadata for file '<sch:value-of select="./mets:FLocat/@xlink:href"/>'.
                        </sch:assert>
                </sch:rule>
        </sch:pattern>

        <!-- Native file check -->
        <sch:pattern id="required_features_native">
                <sch:rule context="mets:fileGrp/mets:file[(normalize-space(@USE)='fi-preservation-no-file-format-validation')]">
                        <sch:let name="admid" value="normalize-space(@ADMID)"/>
                        <sch:let name="source_techmd_id" value="normalize-space($techmd/@ID[contains(concat(' ', $admid, ' '), concat(' ', normalize-space(.), ' ')) and ../mets:mdWrap/mets:xmlData/premis:object/premis:objectCharacteristics/premis:format/premis:formatDesignation/premis:formatName])"/>
                        <sch:let name="source_object_id" value="normalize-space($techmd[normalize-space(@ID) = $source_techmd_id]/mets:mdWrap/mets:xmlData/premis:object/premis:objectIdentifier/premis:objectIdentifierValue)"/>
                        <sch:let name="event_source_link" value="exsl:node-set($digiprovmd_migration/mets:mdWrap/mets:xmlData/premis:event/premis:linkingObjectIdentifier[normalize-space(./premis:linkingObjectRole)='source' and normalize-space(./premis:linkingObjectIdentifierValue)=$source_object_id]/..)"/>
                        <sch:let name="event_not_outcome_link" value="exsl:node-set($digiprovmd_migration/mets:mdWrap/mets:xmlData/premis:event/premis:linkingObjectIdentifier[normalize-space(./premis:linkingObjectRole)='outcome' and not(normalize-space(./premis:linkingObjectIdentifierValue)=$source_object_id)]/..)"/>
                        <sch:let name="event_links_source_ok" value="sets:intersection($event_source_link, $event_not_outcome_link)"/>

                        <sch:assert test="(count($digiprovmd_migration) &gt; 0 and count($digiprovmd_migration/@ID[contains(concat(' ', $admid, ' '), concat(' ', normalize-space(.), ' '))]) &gt; 0)">
                                Value '<sch:value-of select="@USE"/>' in attribute '<sch:value-of select="name(@USE)"/>' found for file '<sch:value-of select="./mets:FLocat/@xlink:href"/>'. Succeeded PREMIS event for migration/normalization is required.
                        </sch:assert>
                        <sch:assert test="(count($digiprovmd_migration) = 0 or count($event_links_source_ok) &gt; 0)">
                                Value '<sch:value-of select="@USE"/>' in attribute '<sch:value-of select="name(@USE)"/>' found for file '<sch:value-of select="./mets:FLocat/@xlink:href"/>'. PREMIS event for migration/normalization contains ambiguous links to object identifiers.
                        </sch:assert>
                        <sch:report test="(count($digiprovmd_migration) &gt; 0 and count($digiprovmd_migration/@ID[contains(concat(' ', $admid, ' '), concat(' ', normalize-space(.), ' '))]) &gt; 0 and count($event_links_source_ok) &gt; 0)">
                                INFO: Value '<sch:value-of select="@USE"/>' in attribute '<sch:value-of select="name(@USE)"/>' found for file '<sch:value-of select="./mets:FLocat/@xlink:href"/>'. No file format validation is executed for this file.
                        </sch:report>
                </sch:rule>
        </sch:pattern>

        <sch:pattern id="linking_match_for_streams">
                <sch:rule context="mets:stream">
                        <sch:let name="given_specification" value="substring-before(concat(normalize-space(concat(normalize-space(/mets:mets/@fi:CATALOG), ' ', normalize-space(/mets:mets/@fikdk:CATALOG), ' ', normalize-space(/mets:mets/@fi:SPECIFICATION), ' ', normalize-space(/mets:mets/@fikdk:SPECIFICATION))), ' '), ' ')"/>
                        <sch:let name="stream_admid" value="normalize-space(@ADMID)"/>
                        <sch:let name="container_admid" value="normalize-space(../@ADMID)"/>
                        <sch:let name="container_techmd" value="$techmd[contains(concat(' ', $container_admid, ' '), concat(' ', normalize-space(@ID), ' ')) and normalize-space(./mets:mdWrap/mets:xmlData/premis:object/@xsi:type)='premis:file' and ./mets:mdWrap/mets:xmlData/premis:object/premis:relationship/premis:relatedObjectIdentification/premis:relatedObjectIdentifierValue]"/>
                        <sch:let name="stream_techmd" value="$techmd[contains(concat(' ', $stream_admid, ' '), concat(' ', normalize-space(@ID), ' ')) and normalize-space(./mets:mdWrap/mets:xmlData/premis:object/@xsi:type)='premis:bitstream']"/>
                        <sch:assert test="($container_techmd/mets:mdWrap/mets:xmlData/premis:object/premis:relationship/premis:relatedObjectIdentification/premis:relatedObjectIdentifierValue = $stream_techmd/mets:mdWrap/mets:xmlData/premis:object/premis:objectIdentifier/premis:objectIdentifierValue) or contains(' 1.5.0 ', concat(' ', $given_specification,' '))">
                                Container or stream mismatch between METS fileSec and PREMIS linkings for file '<sch:value-of select="../mets:FLocat/@xlink:href"/>'.
                        </sch:assert>
                </sch:rule>
        </sch:pattern>


	<!-- COMPATIBILITY WITH DEPRECATED VERSIONS -->

	<!-- Disallow streams in secifications older than 1.6.0 -->
        <sch:pattern id="mets_file_stream" is-a="disallowed_element_pattern">
                <sch:param name="context_element" value="mets:fileGrp/mets:file"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_element" value="mets:stream"/>
                <sch:param name="specifications" value="string('1.5.0')"/>
        </sch:pattern>

</sch:schema>
