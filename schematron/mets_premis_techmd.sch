<?xml version="1.0" encoding="UTF-8"?>

<!-- pass-filter: /mets:mets/mets:amdSec/mets:techMD/mets:mdWrap/mets:xmlData/premis:* -->
<!-- context-filter: premis:* -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.7.7">
        <sch:title>PREMIS metadata validation</sch:title>

<!--
Validates PREMIS metadata
-->

        <sch:ns prefix="mets" uri="http://www.loc.gov/METS/"/>
        <sch:ns prefix="fikdk" uri="http://www.kdk.fi/standards/mets/kdk-extensions"/>
        <sch:ns prefix="fi" uri="http://digitalpreservation.fi/schemas/mets/fi-extensions"/>
        <sch:ns prefix="premis" uri="info:lc/xmlns/premis-v2"/>
        <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
        <sch:ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
        <sch:ns prefix="exsl" uri="http://exslt.org/common"/>
        <sch:ns prefix="sets" uri="http://exslt.org/sets"/>
        <sch:ns prefix="str" uri="http://exslt.org/strings"/>

        <sch:include href="./abstracts/disallowed_value_element_smaller_version_pattern.incl"/>
        <sch:include href="./abstracts/required_element_pattern.incl"/>
        <sch:include href="./abstracts/required_values_element_pattern.incl"/>
        <sch:include href="./abstracts/required_value_premis_formatname_pattern.incl"/>
        <sch:include href="./abstracts/required_parameters_premis_formatname_pattern.incl"/>
        <sch:include href="./abstracts/required_nonempty_element_pattern.incl"/>

        <!-- Supported MIME types -->
        <sch:let name="supported_mime_types" value="concat(
                'application/epub+zip; ',
                'application/geopackage+sqlite3; ',
                'application/gml+xml; ',
                'application/matlab; ',
                'application/msword; ',
                'application/mxf; ',
                'application/pdf; ',
                'application/postscript; ',
                'application/vnd.google-earth.kml+xml; ',
                'application/vnd.ms-excel; ',
                'application/vnd.ms-powerpoint; ',
                'application/vnd.oasis.opendocument.formula; ',
                'application/vnd.oasis.opendocument.graphics; ',
                'application/vnd.oasis.opendocument.presentation; ',
                'application/vnd.oasis.opendocument.spreadsheet; ',
                'application/vnd.oasis.opendocument.text; ',
                'application/vnd.openxmlformats-officedocument.presentationml.presentation; ',
                'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet; ',
                'application/vnd.openxmlformats-officedocument.wordprocessingml.document; ',
                'application/warc; ',
                'application/x-hdf5; ',
                'application/x-siard; ',
                'application/x-spss-por; ',
                'application/xhtml+xml; ',
                'audio/aac; ',
                'audio/flac; ',
                'audio/L8; ',
                'audio/L16; ',
                'audio/L20; ',
                'audio/L24; ',
                'audio/mp4; ',
                'audio/mpeg; ',
                'audio/x-aiff; ',
                'audio/x-ms-wma; ',
                'audio/x-wav; ',
                'image/gif; ',
                'image/jp2; ',
                'image/jpeg; ',
                'image/png; ',
                'image/svg+xml; ',
                'image/tiff; ',
                'image/webp; ',
                'image/x-adobe-dng; ',
                'image/x-dpx; ',
                'model/step; ',
                'text/csv; ',
                'text/html; ',
                'text/plain; ',
                'text/xml; ',
                'video/avi; ',
                'video/dv; ',
                'video/h264; ',
                'video/h265; ',
                'video/jpeg2000; ',
                'video/mj2; ',
                'video/MP1S; ',
                'video/MP2P; ',
                'video/MP2T; ',
                'video/mp4; ',
                'video/mpeg; ',
                'video/quicktime; ',
                'video/x-ffv; ',
                'video/x-matroska; ',
                'video/x-ms-asf; ',
                'video/x-ms-wmv; ')"/>

        <!--
        Supported PRONOM registry key versions, grouped by file format, keys in a group divided with a space character.
        The number and ordering of the groups must be same as formats in MIME type list.
        -->
        <sch:let name="supported_pronom_codes" value="
                exsl:node-set('fmt/483')
                | exsl:node-set('fmt/1700')
                | exsl:node-set('fmt/1047')
                | exsl:node-set('fmt/806 fmt/828')
                | exsl:node-set('fmt/40')
                | exsl:node-set('')
                | exsl:node-set('fmt/95 fmt/354 fmt/476 fmt/477 fmt/478 fmt/479 fmt/480 fmt/481 fmt/16 fmt/17 fmt/18 fmt/19 fmt/20 fmt/276')
                | exsl:node-set('fmt/124')
                | exsl:node-set('fmt/244')
                | exsl:node-set('fmt/61 fmt/62')
                | exsl:node-set('fmt/126')
                | exsl:node-set('')
                | exsl:node-set('fmt/139 fmt/296 fmt/297 fmt/1753')
                | exsl:node-set('fmt/138 fmt/292 fmt/293 fmt/1754')
                | exsl:node-set('fmt/137 fmt/294 fmt/295 fmt/1755')
                | exsl:node-set('fmt/136 fmt/290 fmt/291 fmt/1756')
                | exsl:node-set('fmt/215')
                | exsl:node-set('fmt/214')
                | exsl:node-set('fmt/412')
                | exsl:node-set('fmt/1281 fmt/1355')
                | exsl:node-set('fmt/807 fmt/286 fmt/287')
                | exsl:node-set('fmt/1777')
                | exsl:node-set('fmt/997')
                | exsl:node-set('fmt/102 fmt/103 fmt/471')
                | exsl:node-set('fmt/199')
                | exsl:node-set('fmt/279')
                | exsl:node-set('')
                | exsl:node-set('')
                | exsl:node-set('')
                | exsl:node-set('')
                | exsl:node-set('fmt/199')
                | exsl:node-set('fmt/134')
                | exsl:node-set('x-fmt/135 x-fmt/136')
                | exsl:node-set('fmt/132')
                | exsl:node-set('fmt/527 fmt/141')
                | exsl:node-set('fmt/3 fmt/4')
                | exsl:node-set('x-fmt/392')
                | exsl:node-set('fmt/42 fmt/43 fmt/44 x-fmt/398 x-fmt/390 x-fmt/391 fmt/645 fmt/1507')
                | exsl:node-set('fmt/13')
                | exsl:node-set('fmt/92')
                | exsl:node-set('fmt/353 fmt/155')
                | exsl:node-set('fmt/556 fmt/567 fmt/568')
                | exsl:node-set('fmt/152 fmt/437 fmt/438 fmt/730 fmt/1841')
                | exsl:node-set('fmt/541')
                | exsl:node-set('fmt/700')
                | exsl:node-set('x-fmt/18')
                | exsl:node-set('fmt/100 fmt/471')
                | exsl:node-set('x-fmt/111')
                | exsl:node-set('fmt/101 fmt/1776')
                | exsl:node-set('fmt/5')
                | exsl:node-set('x-fmt/152')
                | exsl:node-set('fmt/199')
                | exsl:node-set('')
                | exsl:node-set('x-fmt/392')
                | exsl:node-set('fmt/337')
                | exsl:node-set('x-fmt/385')
                | exsl:node-set('x-fmt/386')
                | exsl:node-set('fmt/585')
                | exsl:node-set('fmt/199')
                | exsl:node-set('fmt/649 fmt/640')
                | exsl:node-set('x-fmt/384')
                | exsl:node-set('')
                | exsl:node-set('fmt/569')
                | exsl:node-set('fmt/131')
                | exsl:node-set('fmt/133')"/>

        <!-- Supported checksum types divided with a space+semicolon characters -->
        <sch:let name="supported_checksum_algorithms" value="string('MD5; SHA-1; SHA-224; SHA-256; SHA-384; SHA-512; md5; sha-1; sha-224; sha-256; sha-384; sha-512')"/>

        <!-- Supported character encodings divided with a space character -->
        <sch:let name="supported_charsets" value="string('ISO-8859-15 UTF-8 UTF-16 UTF-32 iso-8859-15 utf-8 utf-16 utf-32')"/>

        <!-- MIME types that require charset -->
        <sch:let name="mimes_require_charset" value="string('application/xhtml+xml text/xml text/html text/csv text/plain application/gml+xml application/vnd.google-earth.kml+xml')"/>

        <!-- PREMIS mandatory elements -->
        <sch:pattern id="premis_fixity" is-a="required_element_pattern">
                <sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/premis:object[normalize-space(@xsi:type)='premis:file']/premis:objectCharacteristics"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="premis:fixity"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="premis_creatingApplication" is-a="required_element_pattern">
                <sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/premis:object[normalize-space(@xsi:type)='premis:file']/premis:objectCharacteristics"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="premis:creatingApplication"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="premis_dateCreatedByApplication" is-a="required_element_pattern">
                <sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/premis:object[normalize-space(@xsi:type)='premis:file']/premis:objectCharacteristics/premis:creatingApplication"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="premis:dateCreatedByApplication"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="premis_formatDesignation" is-a="required_element_pattern">
                <sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/premis:object[not(normalize-space(@xsi:type)='premis:representation')]/premis:objectCharacteristics/premis:format"/>
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
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

        <!-- Message digest algorithm check -->
        <sch:pattern id="premis_messageDigestAlgorithm_values" is-a="required_values_element_pattern">
                <sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/premis:object[normalize-space(@xsi:type)='premis:file']/premis:objectCharacteristics/premis:fixity/premis:messageDigestAlgorithm"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="valid_values" value="$supported_checksum_algorithms"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

        <!-- Identifier value not empty -->
        <sch:pattern id="premis_objectIdentifierType_value" is-a="required_nonempty_element_pattern">
                <sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/premis:object/premis:objectIdentifier/premis:objectIdentifierType"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="premis_objectIdentifierValue_value" is-a="required_nonempty_element_pattern">
                <sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/premis:object/premis:objectIdentifier/premis:objectIdentifierValue"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>


        <!-- COMPATIBILITY WITH OLDER SPECIFICATIONS -->

        <sch:pattern id="premis22_dateCreatedByApplication_values" is-a="disallowed_value_element_smaller_version_pattern">
                <sch:param name="context_element" value="premis:dateCreatedByApplication"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_value" value="string('OPEN')"/>
                <sch:param name="mdattribute" value="@MDTYPE"/>
                <sch:param name="mdtype_name" value="string('PREMIS:OBJECT')"/>
                <sch:param name="mdtype_version" value="string('2.2')"/>
        </sch:pattern>

</sch:schema>
