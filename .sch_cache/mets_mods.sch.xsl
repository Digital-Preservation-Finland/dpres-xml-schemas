<axsl:stylesheet xmlns:axsl="http://www.w3.org/1999/XSL/Transform" xmlns:sch="http://www.ascc.net/xml/schematron" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:mets="http://www.loc.gov/METS/" xmlns:fi="http://www.kdk.fi/standards/mets/kdk-extensions" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
<axsl:param name="archiveDirParameter"/><axsl:param name="archiveNameParameter"/><axsl:param name="fileNameParameter"/><axsl:param name="fileDirParameter"/>

<!--PHASES-->


<!--PROLOG-->
<axsl:output xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:saxon="http://icl.com/saxon" method="xml" omit-xml-declaration="yes" standalone="yes" indent="yes"/>

<!--KEYS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<axsl:template match="*" mode="schematron-select-full-path"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<axsl:template match="*" mode="schematron-get-full-path"><axsl:apply-templates select="parent::*" mode="schematron-get-full-path"/><axsl:text>/</axsl:text><axsl:choose><axsl:when test="namespace-uri()=''"><axsl:value-of select="name()"/><axsl:variable name="p_1" select="1+    count(preceding-sibling::*[name()=name(current())])"/><axsl:if test="$p_1&gt;1 or following-sibling::*[name()=name(current())]">[<axsl:value-of select="$p_1"/>]</axsl:if></axsl:when><axsl:otherwise><axsl:text>*[local-name()='</axsl:text><axsl:value-of select="local-name()"/><axsl:text>' and namespace-uri()='</axsl:text><axsl:value-of select="namespace-uri()"/><axsl:text>']</axsl:text><axsl:variable name="p_2" select="1+   count(preceding-sibling::*[local-name()=local-name(current())])"/><axsl:if test="$p_2&gt;1 or following-sibling::*[local-name()=local-name(current())]">[<axsl:value-of select="$p_2"/>]</axsl:if></axsl:otherwise></axsl:choose></axsl:template><axsl:template match="@*" mode="schematron-get-full-path"><axsl:text>/</axsl:text><axsl:choose><axsl:when test="namespace-uri()=''">@<axsl:value-of select="name()"/></axsl:when><axsl:otherwise><axsl:text>@*[local-name()='</axsl:text><axsl:value-of select="local-name()"/><axsl:text>' and namespace-uri()='</axsl:text><axsl:value-of select="namespace-uri()"/><axsl:text>']</axsl:text></axsl:otherwise></axsl:choose></axsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<axsl:template match="node() | @*" mode="schematron-get-full-path-2"><axsl:for-each select="ancestor-or-self::*"><axsl:text>/</axsl:text><axsl:value-of select="name(.)"/><axsl:if test="preceding-sibling::*[name(.)=name(current())]"><axsl:text>[</axsl:text><axsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/><axsl:text>]</axsl:text></axsl:if></axsl:for-each><axsl:if test="not(self::*)"><axsl:text/>/@<axsl:value-of select="name(.)"/></axsl:if></axsl:template>

<!--MODE: GENERATE-ID-FROM-PATH -->
<axsl:template match="/" mode="generate-id-from-path"/><axsl:template match="text()" mode="generate-id-from-path"><axsl:apply-templates select="parent::*" mode="generate-id-from-path"/><axsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/></axsl:template><axsl:template match="comment()" mode="generate-id-from-path"><axsl:apply-templates select="parent::*" mode="generate-id-from-path"/><axsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/></axsl:template><axsl:template match="processing-instruction()" mode="generate-id-from-path"><axsl:apply-templates select="parent::*" mode="generate-id-from-path"/><axsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/></axsl:template><axsl:template match="@*" mode="generate-id-from-path"><axsl:apply-templates select="parent::*" mode="generate-id-from-path"/><axsl:value-of select="concat('.@', name())"/></axsl:template><axsl:template match="*" mode="generate-id-from-path" priority="-0.5"><axsl:apply-templates select="parent::*" mode="generate-id-from-path"/><axsl:text>.</axsl:text><axsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/></axsl:template><!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
<axsl:template match="node() | @*" mode="schematron-get-full-path-3"><axsl:for-each select="ancestor-or-self::*"><axsl:text>/</axsl:text><axsl:value-of select="name(.)"/><axsl:if test="parent::*"><axsl:text>[</axsl:text><axsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/><axsl:text>]</axsl:text></axsl:if></axsl:for-each><axsl:if test="not(self::*)"><axsl:text/>/@<axsl:value-of select="name(.)"/></axsl:if></axsl:template>

<!--MODE: GENERATE-ID-2 -->
<axsl:template match="/" mode="generate-id-2">U</axsl:template><axsl:template match="*" mode="generate-id-2" priority="2"><axsl:text>U</axsl:text><axsl:number level="multiple" count="*"/></axsl:template><axsl:template match="node()" mode="generate-id-2"><axsl:text>U.</axsl:text><axsl:number level="multiple" count="*"/><axsl:text>n</axsl:text><axsl:number count="node()"/></axsl:template><axsl:template match="@*" mode="generate-id-2"><axsl:text>U.</axsl:text><axsl:number level="multiple" count="*"/><axsl:text>_</axsl:text><axsl:value-of select="string-length(local-name(.))"/><axsl:text>_</axsl:text><axsl:value-of select="translate(name(),':','.')"/></axsl:template><!--Strip characters--><axsl:template match="text()" priority="-1"/>

<!--SCHEMA METADATA-->
<axsl:template match="/"><svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" title="MODS metadata validation" schemaVersion="1.6.0"><axsl:comment><axsl:value-of select="$archiveDirParameter"/>   
		 <axsl:value-of select="$archiveNameParameter"/>  
		 <axsl:value-of select="$fileNameParameter"/>  
		 <axsl:value-of select="$fileDirParameter"/></axsl:comment><svrl:ns-prefix-in-attribute-values uri="http://www.loc.gov/METS/" prefix="mets"/><svrl:ns-prefix-in-attribute-values uri="http://www.kdk.fi/standards/mets/kdk-extensions" prefix="fi"/><svrl:ns-prefix-in-attribute-values uri="http://www.loc.gov/mods/v3" prefix="mods"/><svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/1999/xlink" prefix="xlink"/><svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/XML/1998/namespace" prefix="xml"/><svrl:active-pattern><axsl:attribute name="id">mods36_extraterrestrialArea</axsl:attribute><axsl:attribute name="name">mods36_extraterrestrialArea</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M6"/><svrl:active-pattern><axsl:attribute name="id">mods36_province</axsl:attribute><axsl:attribute name="name">mods36_province</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M7"/><svrl:active-pattern><axsl:attribute name="id">mods36_extraTerrestrialArea</axsl:attribute><axsl:attribute name="name">mods36_extraTerrestrialArea</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M8"/><svrl:active-pattern><axsl:attribute name="id">mods36_itemIdentifier</axsl:attribute><axsl:attribute name="name">mods36_itemIdentifier</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M9"/><svrl:active-pattern><axsl:attribute name="id">mods36_nameIdentifier</axsl:attribute><axsl:attribute name="name">mods36_nameIdentifier</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M10"/><svrl:active-pattern><axsl:attribute name="id">mods36_recordInfoNote</axsl:attribute><axsl:attribute name="name">mods36_recordInfoNote</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M11"/><svrl:active-pattern><axsl:attribute name="id">mods36_cartographicExtension</axsl:attribute><axsl:attribute name="name">mods36_cartographicExtension</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M12"/><svrl:active-pattern><axsl:attribute name="id">mods36_otherType</axsl:attribute><axsl:attribute name="name">mods36_otherType</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M13"/><svrl:active-pattern><axsl:attribute name="id">mods36_otherTypeAuth</axsl:attribute><axsl:attribute name="name">mods36_otherTypeAuth</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M14"/><svrl:active-pattern><axsl:attribute name="id">mods36_otherTypeAuthURI</axsl:attribute><axsl:attribute name="name">mods36_otherTypeAuthURI</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M15"/><svrl:active-pattern><axsl:attribute name="id">mods36_otherTypeURI</axsl:attribute><axsl:attribute name="name">mods36_otherTypeURI</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M16"/><svrl:active-pattern><axsl:attribute name="id">mods36_space</axsl:attribute><axsl:attribute name="name">mods36_space</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M17"/><svrl:active-pattern><axsl:attribute name="id">mods36_level</axsl:attribute><axsl:attribute name="name">mods36_level</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M18"/><svrl:active-pattern><axsl:attribute name="id">mods36_period</axsl:attribute><axsl:attribute name="name">mods36_period</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M19"/><svrl:active-pattern><axsl:attribute name="id">mods36_authority</axsl:attribute><axsl:attribute name="name">mods36_authority</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M20"/><svrl:active-pattern><axsl:attribute name="id">mods36_authorityURI</axsl:attribute><axsl:attribute name="name">mods36_authorityURI</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M21"/><svrl:active-pattern><axsl:attribute name="id">mods36_valueURI</axsl:attribute><axsl:attribute name="name">mods36_valueURI</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M22"/><svrl:active-pattern><axsl:attribute name="id">mods35_altFormat</axsl:attribute><axsl:attribute name="name">mods35_altFormat</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M23"/><svrl:active-pattern><axsl:attribute name="id">mods35_contentType</axsl:attribute><axsl:attribute name="name">mods35_contentType</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M24"/><svrl:active-pattern><axsl:attribute name="id">mods35_generator</axsl:attribute><axsl:attribute name="name">mods35_generator</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M25"/><svrl:active-pattern><axsl:attribute name="id">mods35_typeURI</axsl:attribute><axsl:attribute name="name">mods35_typeURI</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M26"/><svrl:active-pattern><axsl:attribute name="id">mods35_typeURI_note</axsl:attribute><axsl:attribute name="name">mods35_typeURI_note</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M27"/><svrl:active-pattern><axsl:attribute name="id">mods35_eventType</axsl:attribute><axsl:attribute name="name">mods35_eventType</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M28"/><svrl:active-pattern><axsl:attribute name="id">mods35_unit</axsl:attribute><axsl:attribute name="name">mods35_unit</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M29"/><svrl:active-pattern><axsl:attribute name="id">mods35_otherType</axsl:attribute><axsl:attribute name="name">mods35_otherType</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M30"/><svrl:active-pattern><axsl:attribute name="id">mods35_authority_values</axsl:attribute><axsl:attribute name="name">mods35_authority_values</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M31"/><svrl:active-pattern><axsl:attribute name="id">mods34_usage_values_deprecated</axsl:attribute><axsl:attribute name="name">mods34_usage_values_deprecated</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M32"/><svrl:active-pattern><axsl:attribute name="id">mods34_shareable</axsl:attribute><axsl:attribute name="name">mods34_shareable</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M33"/><svrl:active-pattern><axsl:attribute name="id">mods34_altRepGroup</axsl:attribute><axsl:attribute name="name">mods34_altRepGroup</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M34"/><svrl:active-pattern><axsl:attribute name="id">mods34_authorityURI</axsl:attribute><axsl:attribute name="name">mods34_authorityURI</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M35"/><svrl:active-pattern><axsl:attribute name="id">mods34_valueURI</axsl:attribute><axsl:attribute name="name">mods34_valueURI</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M36"/><svrl:active-pattern><axsl:attribute name="id">mods34_supplied</axsl:attribute><axsl:attribute name="name">mods34_supplied</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M37"/><svrl:active-pattern><axsl:attribute name="id">mods34_usage</axsl:attribute><axsl:attribute name="name">mods34_usage</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M38"/><svrl:active-pattern><axsl:attribute name="id">mods34_languageOfCataloging_usage</axsl:attribute><axsl:attribute name="name">mods34_languageOfCataloging_usage</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M39"/><svrl:active-pattern><axsl:attribute name="id">mods34_genre_usage</axsl:attribute><axsl:attribute name="name">mods34_genre_usage</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M40"/><svrl:active-pattern><axsl:attribute name="id">mods34_displayLabel</axsl:attribute><axsl:attribute name="name">mods34_displayLabel</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M41"/><svrl:active-pattern><axsl:attribute name="id">mods34_genre_displayLabel</axsl:attribute><axsl:attribute name="name">mods34_genre_displayLabel</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M42"/><svrl:active-pattern><axsl:attribute name="id">mods34_languageOfCataloging_displayLabel</axsl:attribute><axsl:attribute name="name">mods34_languageOfCataloging_displayLabel</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M43"/><svrl:active-pattern><axsl:attribute name="id">mods34_name_displayLabel</axsl:attribute><axsl:attribute name="name">mods34_name_displayLabel</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M44"/><svrl:active-pattern><axsl:attribute name="id">mods34_language</axsl:attribute><axsl:attribute name="name">mods34_language</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M45"/><svrl:active-pattern><axsl:attribute name="id">mods34_languageOfCataloging_language</axsl:attribute><axsl:attribute name="name">mods34_languageOfCataloging_language</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M46"/><svrl:active-pattern><axsl:attribute name="id">mods34_language_scriptTerm</axsl:attribute><axsl:attribute name="name">mods34_language_scriptTerm</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M47"/><svrl:active-pattern><axsl:attribute name="id">mods34_languageOfCataloging_scriptTerm</axsl:attribute><axsl:attribute name="name">mods34_languageOfCataloging_scriptTerm</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M48"/><svrl:active-pattern><axsl:attribute name="id">mods34_nameTitleGroup</axsl:attribute><axsl:attribute name="name">mods34_nameTitleGroup</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M49"/><svrl:active-pattern><axsl:attribute name="id">mods34_cartographics_authority</axsl:attribute><axsl:attribute name="name">mods34_cartographics_authority</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M50"/><svrl:active-pattern><axsl:attribute name="id">mods34_hierarchicalGeographic_authority</axsl:attribute><axsl:attribute name="name">mods34_hierarchicalGeographic_authority</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M51"/><svrl:active-pattern><axsl:attribute name="id">mods34_temporal_authority</axsl:attribute><axsl:attribute name="name">mods34_temporal_authority</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M52"/><svrl:active-pattern><axsl:attribute name="id">mods34_lang</axsl:attribute><axsl:attribute name="name">mods34_lang</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M53"/><svrl:active-pattern><axsl:attribute name="id">mods34_name_lang</axsl:attribute><axsl:attribute name="name">mods34_name_lang</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M54"/><svrl:active-pattern><axsl:attribute name="id">mods34_genre_lang</axsl:attribute><axsl:attribute name="name">mods34_genre_lang</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M55"/><svrl:active-pattern><axsl:attribute name="id">mods34_recordContentSource_lang</axsl:attribute><axsl:attribute name="name">mods34_recordContentSource_lang</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M56"/><svrl:active-pattern><axsl:attribute name="id">mods34_physicalLocation_lang</axsl:attribute><axsl:attribute name="name">mods34_physicalLocation_lang</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M57"/><svrl:active-pattern><axsl:attribute name="id">mods34_xml_lang</axsl:attribute><axsl:attribute name="name">mods34_xml_lang</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M58"/><svrl:active-pattern><axsl:attribute name="id">mods34_name_xml_lang</axsl:attribute><axsl:attribute name="name">mods34_name_xml_lang</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M59"/><svrl:active-pattern><axsl:attribute name="id">mods34_genre_xml_lang</axsl:attribute><axsl:attribute name="name">mods34_genre_xml_lang</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M60"/><svrl:active-pattern><axsl:attribute name="id">mods34_recordContentSource_xml_lang</axsl:attribute><axsl:attribute name="name">mods34_recordContentSource_xml_lang</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M61"/><svrl:active-pattern><axsl:attribute name="id">mods34_physicalLocation_xml_lang</axsl:attribute><axsl:attribute name="name">mods34_physicalLocation_xml_lang</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M62"/><svrl:active-pattern><axsl:attribute name="id">mods34_script</axsl:attribute><axsl:attribute name="name">mods34_script</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M63"/><svrl:active-pattern><axsl:attribute name="id">mods34_name_script</axsl:attribute><axsl:attribute name="name">mods34_name_script</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M64"/><svrl:active-pattern><axsl:attribute name="id">mods34_genre_script</axsl:attribute><axsl:attribute name="name">mods34_genre_script</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M65"/><svrl:active-pattern><axsl:attribute name="id">mods34_recordContentSource_script</axsl:attribute><axsl:attribute name="name">mods34_recordContentSource_script</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M66"/><svrl:active-pattern><axsl:attribute name="id">mods34_physicalLocation_script</axsl:attribute><axsl:attribute name="name">mods34_physicalLocation_script</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M67"/><svrl:active-pattern><axsl:attribute name="id">mods34_transliteration</axsl:attribute><axsl:attribute name="name">mods34_transliteration</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M68"/><svrl:active-pattern><axsl:attribute name="id">mods34_name_transliteration</axsl:attribute><axsl:attribute name="name">mods34_name_transliteration</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M69"/><svrl:active-pattern><axsl:attribute name="id">mods34_genre_transliteration</axsl:attribute><axsl:attribute name="name">mods34_genre_transliteration</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M70"/><svrl:active-pattern><axsl:attribute name="id">mods34_recordContentSource_transliteration</axsl:attribute><axsl:attribute name="name">mods34_recordContentSource_transliteration</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M71"/><svrl:active-pattern><axsl:attribute name="id">mods34_physicalLocation_transliteration</axsl:attribute><axsl:attribute name="name">mods34_physicalLocation_transliteration</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M72"/><svrl:active-pattern><axsl:attribute name="id">mods34_issuance_values1</axsl:attribute><axsl:attribute name="name">mods34_issuance_values1</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M73"/><svrl:active-pattern><axsl:attribute name="id">mods34_issuance_values2</axsl:attribute><axsl:attribute name="name">mods34_issuance_values2</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M74"/><svrl:active-pattern><axsl:attribute name="id">mods34_issuance_values3</axsl:attribute><axsl:attribute name="name">mods34_issuance_values3</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M75"/><svrl:active-pattern><axsl:attribute name="id">mods34_issuance_values4</axsl:attribute><axsl:attribute name="name">mods34_issuance_values4</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M76"/><svrl:active-pattern><axsl:attribute name="id">mods34_encoding_values1</axsl:attribute><axsl:attribute name="name">mods34_encoding_values1</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M77"/><svrl:active-pattern><axsl:attribute name="id">mods34_encoding_values2</axsl:attribute><axsl:attribute name="name">mods34_encoding_values2</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M78"/><svrl:active-pattern><axsl:attribute name="id">mods34_name_type_values</axsl:attribute><axsl:attribute name="name">mods34_name_type_values</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M79"/><svrl:active-pattern><axsl:attribute name="id">mods34_relatedItem_type_values1</axsl:attribute><axsl:attribute name="name">mods34_relatedItem_type_values1</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M80"/><svrl:active-pattern><axsl:attribute name="id">mods34_relatedItem_type_values2</axsl:attribute><axsl:attribute name="name">mods34_relatedItem_type_values2</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M81"/><svrl:active-pattern><axsl:attribute name="id">mods34_usage_values</axsl:attribute><axsl:attribute name="name">mods34_usage_values</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M82"/><svrl:active-pattern><axsl:attribute name="id">mods33_authority</axsl:attribute><axsl:attribute name="name">mods33_authority</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M83"/><svrl:active-pattern><axsl:attribute name="id">mods33_physicalLocation_xlink_type</axsl:attribute><axsl:attribute name="name">mods33_physicalLocation_xlink_type</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M84"/><svrl:active-pattern><axsl:attribute name="id">mods33_physicalLocation_xlink_href</axsl:attribute><axsl:attribute name="name">mods33_physicalLocation_xlink_href</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M85"/><svrl:active-pattern><axsl:attribute name="id">mods33_physicalLocation_xlink_role</axsl:attribute><axsl:attribute name="name">mods33_physicalLocation_xlink_role</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M86"/><svrl:active-pattern><axsl:attribute name="id">mods33_physicalLocation_xlink_arcrole</axsl:attribute><axsl:attribute name="name">mods33_physicalLocation_xlink_arcrole</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M87"/><svrl:active-pattern><axsl:attribute name="id">mods33_physicalLocation_xlink_title</axsl:attribute><axsl:attribute name="name">mods33_physicalLocation_xlink_title</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M88"/><svrl:active-pattern><axsl:attribute name="id">mods33_physicalLocation_xlink_show</axsl:attribute><axsl:attribute name="name">mods33_physicalLocation_xlink_show</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M89"/><svrl:active-pattern><axsl:attribute name="id">mods33_physicalLocation_xlink_actuate</axsl:attribute><axsl:attribute name="name">mods33_physicalLocation_xlink_actuate</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M90"/><svrl:active-pattern><axsl:attribute name="id">mods33_extraterrestrialArea</axsl:attribute><axsl:attribute name="name">mods33_extraterrestrialArea</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M91"/><svrl:active-pattern><axsl:attribute name="id">mods33_citySection</axsl:attribute><axsl:attribute name="name">mods33_citySection</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M92"/><svrl:active-pattern><axsl:attribute name="id">mods33_shelfLocator</axsl:attribute><axsl:attribute name="name">mods33_shelfLocator</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M93"/><svrl:active-pattern><axsl:attribute name="id">mods33_holdingSimple</axsl:attribute><axsl:attribute name="name">mods33_holdingSimple</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M94"/><svrl:active-pattern><axsl:attribute name="id">mods33_location_holdingExternal</axsl:attribute><axsl:attribute name="name">mods33_location_holdingExternal</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M95"/><svrl:active-pattern><axsl:attribute name="id">mods33_recordInfo_holdingExternal</axsl:attribute><axsl:attribute name="name">mods33_recordInfo_holdingExternal</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M96"/><svrl:active-pattern><axsl:attribute name="id">mods33_languageTerm_authority_values</axsl:attribute><axsl:attribute name="name">mods33_languageTerm_authority_values</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M97"/><svrl:active-pattern><axsl:attribute name="id">mods33_typeOfResource_values</axsl:attribute><axsl:attribute name="name">mods33_typeOfResource_values</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M98"/><svrl:active-pattern><axsl:attribute name="id">mods33_extension</axsl:attribute><axsl:attribute name="name">mods33_extension</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M99"/><svrl:active-pattern><axsl:attribute name="id">mods33_accessCondition</axsl:attribute><axsl:attribute name="name">mods33_accessCondition</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M100"/><svrl:active-pattern><axsl:attribute name="id">mods32_ID</axsl:attribute><axsl:attribute name="name">mods32_ID</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M101"/><svrl:active-pattern><axsl:attribute name="id">mods32_note_ID</axsl:attribute><axsl:attribute name="name">mods32_note_ID</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M102"/><svrl:active-pattern><axsl:attribute name="id">mods32_note</axsl:attribute><axsl:attribute name="name">mods32_note</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M103"/><svrl:active-pattern><axsl:attribute name="id">mods32_access</axsl:attribute><axsl:attribute name="name">mods32_access</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M104"/><svrl:active-pattern><axsl:attribute name="id">mods32_usage</axsl:attribute><axsl:attribute name="name">mods32_usage</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M105"/><svrl:active-pattern><axsl:attribute name="id">mods32_type</axsl:attribute><axsl:attribute name="name">mods32_type</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M106"/><svrl:active-pattern><axsl:attribute name="id">mods32_order</axsl:attribute><axsl:attribute name="name">mods32_order</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M107"/><svrl:active-pattern><axsl:attribute name="id">mods32_genre</axsl:attribute><axsl:attribute name="name">mods32_genre</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M108"/><svrl:active-pattern><axsl:attribute name="id">mods32_digitalOrigin_values1</axsl:attribute><axsl:attribute name="name">mods32_digitalOrigin_values1</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M109"/><svrl:active-pattern><axsl:attribute name="id">mods32_digitalOrigin_values2</axsl:attribute><axsl:attribute name="name">mods32_digitalOrigin_values2</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M110"/><svrl:active-pattern><axsl:attribute name="id">mods31_genre_type</axsl:attribute><axsl:attribute name="name">mods31_genre_type</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M111"/><svrl:active-pattern><axsl:attribute name="id">mods31_dateOther_type</axsl:attribute><axsl:attribute name="name">mods31_dateOther_type</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M112"/><svrl:active-pattern><axsl:attribute name="id">mods31_form_type</axsl:attribute><axsl:attribute name="name">mods31_form_type</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M113"/><svrl:active-pattern><axsl:attribute name="id">mods31_physicalLocation_type</axsl:attribute><axsl:attribute name="name">mods31_physicalLocation_type</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M114"/><svrl:active-pattern><axsl:attribute name="id">mods31_language_objectPart</axsl:attribute><axsl:attribute name="name">mods31_language_objectPart</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M115"/><svrl:active-pattern><axsl:attribute name="id">mods31_languageOfCataloging_objectPart</axsl:attribute><axsl:attribute name="name">mods31_languageOfCataloging_objectPart</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M116"/><svrl:active-pattern><axsl:attribute name="id">mods31_displayLabel</axsl:attribute><axsl:attribute name="name">mods31_displayLabel</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M117"/><svrl:active-pattern><axsl:attribute name="id">mods31_part</axsl:attribute><axsl:attribute name="name">mods31_part</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M118"/><svrl:active-pattern><axsl:attribute name="id">mods31_coordinates</axsl:attribute><axsl:attribute name="name">mods31_coordinates</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M119"/><svrl:active-pattern><axsl:attribute name="id">mods31_titleInfo</axsl:attribute><axsl:attribute name="name">mods31_titleInfo</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M120"/><svrl:active-pattern><axsl:attribute name="id">mods31_name</axsl:attribute><axsl:attribute name="name">mods31_name</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M121"/><svrl:active-pattern><axsl:attribute name="id">mods31_subject</axsl:attribute><axsl:attribute name="name">mods31_subject</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M122"/></svrl:schematron-output></axsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon">MODS metadata validation</svrl:text>

<!--PATTERN mods36_extraterrestrialArea-->


	<!--RULE -->
<axsl:template match="mods:hierarchicalGeographic[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &gt;= number(string('3.6'))]" priority="1000" mode="M6"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:hierarchicalGeographic[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &gt;= number(string('3.6'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(./mods:extraterrestrialArea)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(./mods:extraterrestrialArea)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Element '<axsl:text/><axsl:value-of select="name(mods:extraterrestrialArea)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version <axsl:text/><axsl:value-of select="string('3.6')"/><axsl:text/> or newer. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M6"/></axsl:template><axsl:template match="text()" priority="-1" mode="M6"/><axsl:template match="@*|node()" priority="-2" mode="M6"><axsl:apply-templates select="@*|*" mode="M6"/></axsl:template>

<!--PATTERN mods36_province-->


	<!--RULE -->
<axsl:template match="mods:hierarchicalGeographic[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &gt;= number(string('3.6'))]" priority="1000" mode="M7"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:hierarchicalGeographic[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &gt;= number(string('3.6'))]"/>

		<!--REPORT -->
<axsl:if test="./mods:province"><svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="./mods:province"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:text>
				INFO: Element '<axsl:text/><axsl:value-of select="name(mods:province)"/><axsl:text/>' is deprecated in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version <axsl:text/><axsl:value-of select="string('3.6')"/><axsl:text/> or newer. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:successful-report></axsl:if><axsl:apply-templates select="@*|*" mode="M7"/></axsl:template><axsl:template match="text()" priority="-1" mode="M7"/><axsl:template match="@*|node()" priority="-2" mode="M7"><axsl:apply-templates select="@*|*" mode="M7"/></axsl:template>

<!--PATTERN mods36_extraTerrestrialArea-->


	<!--RULE -->
<axsl:template match="mods:hierarchicalGeographic[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]" priority="1000" mode="M8"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:hierarchicalGeographic[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(./mods:extraTerrestrialArea)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(./mods:extraTerrestrialArea)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Element '<axsl:text/><axsl:value-of select="name(mods:extraTerrestrialArea)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.6')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M8"/></axsl:template><axsl:template match="text()" priority="-1" mode="M8"/><axsl:template match="@*|node()" priority="-2" mode="M8"><axsl:apply-templates select="@*|*" mode="M8"/></axsl:template>

<!--PATTERN mods36_itemIdentifier-->


	<!--RULE -->
<axsl:template match="mods:copyInformation[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]" priority="1000" mode="M9"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:copyInformation[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(./mods:itemIdentifier)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(./mods:itemIdentifier)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Element '<axsl:text/><axsl:value-of select="name(mods:itemIdentifier)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.6')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M9"/></axsl:template><axsl:template match="text()" priority="-1" mode="M9"/><axsl:template match="@*|node()" priority="-2" mode="M9"><axsl:apply-templates select="@*|*" mode="M9"/></axsl:template>

<!--PATTERN mods36_nameIdentifier-->


	<!--RULE -->
<axsl:template match="mods:name[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]" priority="1000" mode="M10"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:name[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(./mods:nameIdentifier)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(./mods:nameIdentifier)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Element '<axsl:text/><axsl:value-of select="name(mods:nameIdentifier)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.6')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M10"/></axsl:template><axsl:template match="text()" priority="-1" mode="M10"/><axsl:template match="@*|node()" priority="-2" mode="M10"><axsl:apply-templates select="@*|*" mode="M10"/></axsl:template>

<!--PATTERN mods36_recordInfoNote-->


	<!--RULE -->
<axsl:template match="mods:recordInfo[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]" priority="1000" mode="M11"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:recordInfo[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(./mods:recordInfoNote)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(./mods:recordInfoNote)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Element '<axsl:text/><axsl:value-of select="name(mods:recordInfoNote)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.6')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M11"/></axsl:template><axsl:template match="text()" priority="-1" mode="M11"/><axsl:template match="@*|node()" priority="-2" mode="M11"><axsl:apply-templates select="@*|*" mode="M11"/></axsl:template>

<!--PATTERN mods36_cartographicExtension-->


	<!--RULE -->
<axsl:template match="mods:cartographics[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]" priority="1000" mode="M12"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:cartographics[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(./mods:cartographicExtension)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(./mods:cartographicExtension)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Element '<axsl:text/><axsl:value-of select="name(mods:cartographicExtension)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.6')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M12"/></axsl:template><axsl:template match="text()" priority="-1" mode="M12"/><axsl:template match="@*|node()" priority="-2" mode="M12"><axsl:apply-templates select="@*|*" mode="M12"/></axsl:template>

<!--PATTERN mods36_otherType-->


	<!--RULE -->
<axsl:template match="mods:relatedItem[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]" priority="1000" mode="M13"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:relatedItem[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@otherType)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@otherType)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@otherType)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.6')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M13"/></axsl:template><axsl:template match="text()" priority="-1" mode="M13"/><axsl:template match="@*|node()" priority="-2" mode="M13"><axsl:apply-templates select="@*|*" mode="M13"/></axsl:template>

<!--PATTERN mods36_otherTypeAuth-->


	<!--RULE -->
<axsl:template match="mods:relatedItem[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]" priority="1000" mode="M14"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:relatedItem[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@otherTypeAuth)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@otherTypeAuth)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@otherTypeAuth)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.6')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M14"/></axsl:template><axsl:template match="text()" priority="-1" mode="M14"/><axsl:template match="@*|node()" priority="-2" mode="M14"><axsl:apply-templates select="@*|*" mode="M14"/></axsl:template>

<!--PATTERN mods36_otherTypeAuthURI-->


	<!--RULE -->
<axsl:template match="mods:relatedItem[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]" priority="1000" mode="M15"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:relatedItem[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@otherTypeAuthURI)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@otherTypeAuthURI)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@otherTypeAuthURI)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.6')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M15"/></axsl:template><axsl:template match="text()" priority="-1" mode="M15"/><axsl:template match="@*|node()" priority="-2" mode="M15"><axsl:apply-templates select="@*|*" mode="M15"/></axsl:template>

<!--PATTERN mods36_otherTypeURI-->


	<!--RULE -->
<axsl:template match="mods:relatedItem[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]" priority="1000" mode="M16"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:relatedItem[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@otherTypeURI)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@otherTypeURI)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@otherTypeURI)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.6')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M16"/></axsl:template><axsl:template match="text()" priority="-1" mode="M16"/><axsl:template match="@*|node()" priority="-2" mode="M16"><axsl:apply-templates select="@*|*" mode="M16"/></axsl:template>

<!--PATTERN mods36_space-->


	<!--RULE -->
<axsl:template match="mods:nonSort[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]" priority="1000" mode="M17"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:nonSort[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@xml:space)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@xml:space)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@xml:space)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.6')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M17"/></axsl:template><axsl:template match="text()" priority="-1" mode="M17"/><axsl:template match="@*|node()" priority="-2" mode="M17"><axsl:apply-templates select="@*|*" mode="M17"/></axsl:template>

<!--PATTERN mods36_level-->


	<!--RULE -->
<axsl:template match="mods:hierarchicalGeographic/*[(not(self::mods:province)) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]" priority="1000" mode="M18"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:hierarchicalGeographic/*[(not(self::mods:province)) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@level)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@level)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@level)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.6')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M18"/></axsl:template><axsl:template match="text()" priority="-1" mode="M18"/><axsl:template match="@*|node()" priority="-2" mode="M18"><axsl:apply-templates select="@*|*" mode="M18"/></axsl:template>

<!--PATTERN mods36_period-->


	<!--RULE -->
<axsl:template match="mods:hierarchicalGeographic/*[(not(self::mods:province)) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]" priority="1000" mode="M19"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:hierarchicalGeographic/*[(not(self::mods:province)) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@period)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@period)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@period)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.6')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M19"/></axsl:template><axsl:template match="text()" priority="-1" mode="M19"/><axsl:template match="@*|node()" priority="-2" mode="M19"><axsl:apply-templates select="@*|*" mode="M19"/></axsl:template>

<!--PATTERN mods36_authority-->


	<!--RULE -->
<axsl:template match="mods:hierarchicalGeographic/*[(not(self::mods:province)) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]" priority="1000" mode="M20"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:hierarchicalGeographic/*[(not(self::mods:province)) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@authority)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@authority)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@authority)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.6')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M20"/></axsl:template><axsl:template match="text()" priority="-1" mode="M20"/><axsl:template match="@*|node()" priority="-2" mode="M20"><axsl:apply-templates select="@*|*" mode="M20"/></axsl:template>

<!--PATTERN mods36_authorityURI-->


	<!--RULE -->
<axsl:template match="mods:hierarchicalGeographic/*[(not(self::mods:province)) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]" priority="1000" mode="M21"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:hierarchicalGeographic/*[(not(self::mods:province)) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@authorityURI)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@authorityURI)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@authorityURI)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.6')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M21"/></axsl:template><axsl:template match="text()" priority="-1" mode="M21"/><axsl:template match="@*|node()" priority="-2" mode="M21"><axsl:apply-templates select="@*|*" mode="M21"/></axsl:template>

<!--PATTERN mods36_valueURI-->


	<!--RULE -->
<axsl:template match="mods:hierarchicalGeographic/*[(not(self::mods:province)) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]" priority="1000" mode="M22"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:hierarchicalGeographic/*[(not(self::mods:province)) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.6'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@valueURI)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@valueURI)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@valueURI)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.6')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M22"/></axsl:template><axsl:template match="text()" priority="-1" mode="M22"/><axsl:template match="@*|node()" priority="-2" mode="M22"><axsl:apply-templates select="@*|*" mode="M22"/></axsl:template>

<!--PATTERN mods35_altFormat-->


	<!--RULE -->
<axsl:template match="mods:mods/*[(self::mods:abstract or self::mods:accessCondition or self::mods:tableOfContents or self::mods:titleInfo) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.5'))]" priority="1000" mode="M23"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:mods/*[(self::mods:abstract or self::mods:accessCondition or self::mods:tableOfContents or self::mods:titleInfo) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.5'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@altFormat)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@altFormat)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@altFormat)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.5')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M23"/></axsl:template><axsl:template match="text()" priority="-1" mode="M23"/><axsl:template match="@*|node()" priority="-2" mode="M23"><axsl:apply-templates select="@*|*" mode="M23"/></axsl:template>

<!--PATTERN mods35_contentType-->


	<!--RULE -->
<axsl:template match="mods:mods/*[(self::mods:abstract or self::mods:accessCondition or self::mods:tableOfContents or self::mods:titleInfo) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.5'))]" priority="1000" mode="M24"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:mods/*[(self::mods:abstract or self::mods:accessCondition or self::mods:tableOfContents or self::mods:titleInfo) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.5'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@contentType)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@contentType)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@contentType)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.5')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M24"/></axsl:template><axsl:template match="text()" priority="-1" mode="M24"/><axsl:template match="@*|node()" priority="-2" mode="M24"><axsl:apply-templates select="@*|*" mode="M24"/></axsl:template>

<!--PATTERN mods35_generator-->


	<!--RULE -->
<axsl:template match="mods:classification[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.5'))]" priority="1000" mode="M25"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:classification[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.5'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@generator)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@generator)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@generator)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.5')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M25"/></axsl:template><axsl:template match="text()" priority="-1" mode="M25"/><axsl:template match="@*|node()" priority="-2" mode="M25"><axsl:apply-templates select="@*|*" mode="M25"/></axsl:template>

<!--PATTERN mods35_typeURI-->


	<!--RULE -->
<axsl:template match="mods:mods/*[(self::mods:identifier or self::mods:note) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.5'))]" priority="1000" mode="M26"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:mods/*[(self::mods:identifier or self::mods:note) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.5'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@typeURI)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@typeURI)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@typeURI)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.5')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M26"/></axsl:template><axsl:template match="text()" priority="-1" mode="M26"/><axsl:template match="@*|node()" priority="-2" mode="M26"><axsl:apply-templates select="@*|*" mode="M26"/></axsl:template>

<!--PATTERN mods35_typeURI_note-->


	<!--RULE -->
<axsl:template match="mods:physicalDescription/mods:note[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.5'))]" priority="1000" mode="M27"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:physicalDescription/mods:note[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.5'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@typeURI)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@typeURI)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@typeURI)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.5')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M27"/></axsl:template><axsl:template match="text()" priority="-1" mode="M27"/><axsl:template match="@*|node()" priority="-2" mode="M27"><axsl:apply-templates select="@*|*" mode="M27"/></axsl:template>

<!--PATTERN mods35_eventType-->


	<!--RULE -->
<axsl:template match="mods:originInfo[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.5'))]" priority="1000" mode="M28"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:originInfo[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.5'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@eventType)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@eventType)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@eventType)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.5')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M28"/></axsl:template><axsl:template match="text()" priority="-1" mode="M28"/><axsl:template match="@*|node()" priority="-2" mode="M28"><axsl:apply-templates select="@*|*" mode="M28"/></axsl:template>

<!--PATTERN mods35_unit-->


	<!--RULE -->
<axsl:template match="mods:physicalDescription/mods:extent[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.5'))]" priority="1000" mode="M29"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:physicalDescription/mods:extent[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.5'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@unit)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@unit)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@unit)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.5')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M29"/></axsl:template><axsl:template match="text()" priority="-1" mode="M29"/><axsl:template match="@*|node()" priority="-2" mode="M29"><axsl:apply-templates select="@*|*" mode="M29"/></axsl:template>

<!--PATTERN mods35_otherType-->


	<!--RULE -->
<axsl:template match="mods:mods/mods:titleInfo[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.5'))]" priority="1000" mode="M30"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:mods/mods:titleInfo[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.5'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@otherType)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@otherType)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@otherType)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.5')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M30"/></axsl:template><axsl:template match="text()" priority="-1" mode="M30"/><axsl:template match="@*|node()" priority="-2" mode="M30"><axsl:apply-templates select="@*|*" mode="M30"/></axsl:template>

<!--PATTERN mods35_authority_values-->


	<!--RULE -->
<axsl:template match="mods:languageTerm[@authority and (true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.5'))]" priority="1000" mode="M31"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:languageTerm[@authority and (true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.5'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="normalize-space(@authority)!=string('rfc5646')"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="normalize-space(@authority)!=string('rfc5646')"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Value '<axsl:text/><axsl:value-of select="@authority"/><axsl:text/>' is not allowed in attribute '<axsl:text/><axsl:value-of select="name(@authority)"/><axsl:text/>' in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.5')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>').
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M31"/></axsl:template><axsl:template match="text()" priority="-1" mode="M31"/><axsl:template match="@*|node()" priority="-2" mode="M31"><axsl:apply-templates select="@*|*" mode="M31"/></axsl:template>

<!--PATTERN mods34_usage_values_deprecated-->


	<!--RULE -->
<axsl:template match="mods:url[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &gt;= number(string('3.4'))]" priority="1000" mode="M32"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:url[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &gt;= number(string('3.4'))]"/>

		<!--REPORT -->
<axsl:if test="normalize-space(@usage)=string('primary display')"><svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="normalize-space(@usage)=string('primary display')"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:text>
				INFO: Value '<axsl:text/><axsl:value-of select="@usage"/><axsl:text/>' is deprecated in attribute '<axsl:text/><axsl:value-of select="name(@usage)"/><axsl:text/>' in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/> or newer. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>'). Valid values are: <axsl:text/><axsl:value-of select="string('primary')"/><axsl:text/>
			</svrl:text></svrl:successful-report></axsl:if><axsl:apply-templates select="@*|*" mode="M32"/></axsl:template><axsl:template match="text()" priority="-1" mode="M32"/><axsl:template match="@*|node()" priority="-2" mode="M32"><axsl:apply-templates select="@*|*" mode="M32"/></axsl:template>

<!--PATTERN mods34_shareable-->


	<!--RULE -->
<axsl:template match="mods:mods//*[(@shareable) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M33"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:mods//*[(@shareable) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@shareable)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@shareable)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@shareable)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M33"/></axsl:template><axsl:template match="text()" priority="-1" mode="M33"/><axsl:template match="@*|node()" priority="-2" mode="M33"><axsl:apply-templates select="@*|*" mode="M33"/></axsl:template>

<!--PATTERN mods34_altRepGroup-->


	<!--RULE -->
<axsl:template match="mods:mods//*[(@altRepGroup) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M34"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:mods//*[(@altRepGroup) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@altRepGroup)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@altRepGroup)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@altRepGroup)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M34"/></axsl:template><axsl:template match="text()" priority="-1" mode="M34"/><axsl:template match="@*|node()" priority="-2" mode="M34"><axsl:apply-templates select="@*|*" mode="M34"/></axsl:template>

<!--PATTERN mods34_authorityURI-->


	<!--RULE -->
<axsl:template match="mods:mods//*[(@authorityURI) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M35"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:mods//*[(@authorityURI) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@authorityURI)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@authorityURI)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@authorityURI)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M35"/></axsl:template><axsl:template match="text()" priority="-1" mode="M35"/><axsl:template match="@*|node()" priority="-2" mode="M35"><axsl:apply-templates select="@*|*" mode="M35"/></axsl:template>

<!--PATTERN mods34_valueURI-->


	<!--RULE -->
<axsl:template match="mods:mods//*[(@valueURI) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M36"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:mods//*[(@valueURI) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@valueURI)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@valueURI)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@valueURI)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M36"/></axsl:template><axsl:template match="text()" priority="-1" mode="M36"/><axsl:template match="@*|node()" priority="-2" mode="M36"><axsl:apply-templates select="@*|*" mode="M36"/></axsl:template>

<!--PATTERN mods34_supplied-->


	<!--RULE -->
<axsl:template match="mods:mods//*[(@supplied) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M37"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:mods//*[(@supplied) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@supplied)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@supplied)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@supplied)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M37"/></axsl:template><axsl:template match="text()" priority="-1" mode="M37"/><axsl:template match="@*|node()" priority="-2" mode="M37"><axsl:apply-templates select="@*|*" mode="M37"/></axsl:template>

<!--PATTERN mods34_usage-->


	<!--RULE -->
<axsl:template match="mods:mods/*[(self::mods:classification or self::mods:language    or self::mods:name or self::mods:subject or self::mods:titleInfo or self::mods:typeOfResource) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M38"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:mods/*[(self::mods:classification or self::mods:language    or self::mods:name or self::mods:subject or self::mods:titleInfo or self::mods:typeOfResource) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@usage)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@usage)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@usage)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M38"/></axsl:template><axsl:template match="text()" priority="-1" mode="M38"/><axsl:template match="@*|node()" priority="-2" mode="M38"><axsl:apply-templates select="@*|*" mode="M38"/></axsl:template>

<!--PATTERN mods34_languageOfCataloging_usage-->


	<!--RULE -->
<axsl:template match="mods:languageOfCataloging[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M39"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:languageOfCataloging[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@usage)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@usage)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@usage)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M39"/></axsl:template><axsl:template match="text()" priority="-1" mode="M39"/><axsl:template match="@*|node()" priority="-2" mode="M39"><axsl:apply-templates select="@*|*" mode="M39"/></axsl:template>

<!--PATTERN mods34_genre_usage-->


	<!--RULE -->
<axsl:template match="mods:genre[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M40"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:genre[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@usage)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@usage)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@usage)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M40"/></axsl:template><axsl:template match="text()" priority="-1" mode="M40"/><axsl:template match="@*|node()" priority="-2" mode="M40"><axsl:apply-templates select="@*|*" mode="M40"/></axsl:template>

<!--PATTERN mods34_displayLabel-->


	<!--RULE -->
<axsl:template match="mods:mods/*[(self::mods:extension or self::mods:language or self::mods:location or self::mods:originInfo    or self::mods:part or self::mods:physicalDescription or self::mods:recordInfo or self::mods:subject or self::mods:targetAudience    or self::mods:typeOfResource) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M41"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:mods/*[(self::mods:extension or self::mods:language or self::mods:location or self::mods:originInfo    or self::mods:part or self::mods:physicalDescription or self::mods:recordInfo or self::mods:subject or self::mods:targetAudience    or self::mods:typeOfResource) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@displayLabel)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@displayLabel)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@displayLabel)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M41"/></axsl:template><axsl:template match="text()" priority="-1" mode="M41"/><axsl:template match="@*|node()" priority="-2" mode="M41"><axsl:apply-templates select="@*|*" mode="M41"/></axsl:template>

<!--PATTERN mods34_genre_displayLabel-->


	<!--RULE -->
<axsl:template match="mods:genre[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M42"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:genre[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@displayLabel)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@displayLabel)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@displayLabel)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M42"/></axsl:template><axsl:template match="text()" priority="-1" mode="M42"/><axsl:template match="@*|node()" priority="-2" mode="M42"><axsl:apply-templates select="@*|*" mode="M42"/></axsl:template>

<!--PATTERN mods34_languageOfCataloging_displayLabel-->


	<!--RULE -->
<axsl:template match="mods:languageOfCataloging[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M43"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:languageOfCataloging[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@displayLabel)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@displayLabel)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@displayLabel)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M43"/></axsl:template><axsl:template match="text()" priority="-1" mode="M43"/><axsl:template match="@*|node()" priority="-2" mode="M43"><axsl:apply-templates select="@*|*" mode="M43"/></axsl:template>

<!--PATTERN mods34_name_displayLabel-->


	<!--RULE -->
<axsl:template match="mods:name[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M44"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:name[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@displayLabel)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@displayLabel)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@displayLabel)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M44"/></axsl:template><axsl:template match="text()" priority="-1" mode="M44"/><axsl:template match="@*|node()" priority="-2" mode="M44"><axsl:apply-templates select="@*|*" mode="M44"/></axsl:template>

<!--PATTERN mods34_language-->


	<!--RULE -->
<axsl:template match="mods:mods/*[(self::mods:language or self::mods:location or self::mods:part) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M45"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:mods/*[(self::mods:language or self::mods:location or self::mods:part) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@language)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@language)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@language)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M45"/></axsl:template><axsl:template match="text()" priority="-1" mode="M45"/><axsl:template match="@*|node()" priority="-2" mode="M45"><axsl:apply-templates select="@*|*" mode="M45"/></axsl:template>

<!--PATTERN mods34_languageOfCataloging_language-->


	<!--RULE -->
<axsl:template match="mods:languageOfCataloging[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M46"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:languageOfCataloging[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@language)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@language)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@language)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M46"/></axsl:template><axsl:template match="text()" priority="-1" mode="M46"/><axsl:template match="@*|node()" priority="-2" mode="M46"><axsl:apply-templates select="@*|*" mode="M46"/></axsl:template>

<!--PATTERN mods34_language_scriptTerm-->


	<!--RULE -->
<axsl:template match="mods:language[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M47"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:language[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@scriptTerm)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@scriptTerm)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@scriptTerm)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M47"/></axsl:template><axsl:template match="text()" priority="-1" mode="M47"/><axsl:template match="@*|node()" priority="-2" mode="M47"><axsl:apply-templates select="@*|*" mode="M47"/></axsl:template>

<!--PATTERN mods34_languageOfCataloging_scriptTerm-->


	<!--RULE -->
<axsl:template match="mods:languageOfCataloging[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M48"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:languageOfCataloging[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@scriptTerm)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@scriptTerm)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@scriptTerm)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M48"/></axsl:template><axsl:template match="text()" priority="-1" mode="M48"/><axsl:template match="@*|node()" priority="-2" mode="M48"><axsl:apply-templates select="@*|*" mode="M48"/></axsl:template>

<!--PATTERN mods34_nameTitleGroup-->


	<!--RULE -->
<axsl:template match="mods:mods/*[(self::mods:name or self::mods:titleInfo) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M49"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:mods/*[(self::mods:name or self::mods:titleInfo) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@nameTitleGroup)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@nameTitleGroup)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@nameTitleGroup)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M49"/></axsl:template><axsl:template match="text()" priority="-1" mode="M49"/><axsl:template match="@*|node()" priority="-2" mode="M49"><axsl:apply-templates select="@*|*" mode="M49"/></axsl:template>

<!--PATTERN mods34_cartographics_authority-->


	<!--RULE -->
<axsl:template match="mods:cartographics[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M50"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:cartographics[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@authority)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@authority)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@authority)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M50"/></axsl:template><axsl:template match="text()" priority="-1" mode="M50"/><axsl:template match="@*|node()" priority="-2" mode="M50"><axsl:apply-templates select="@*|*" mode="M50"/></axsl:template>

<!--PATTERN mods34_hierarchicalGeographic_authority-->


	<!--RULE -->
<axsl:template match="mods:hierarchicalGeographic[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M51"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:hierarchicalGeographic[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@authority)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@authority)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@authority)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M51"/></axsl:template><axsl:template match="text()" priority="-1" mode="M51"/><axsl:template match="@*|node()" priority="-2" mode="M51"><axsl:apply-templates select="@*|*" mode="M51"/></axsl:template>

<!--PATTERN mods34_temporal_authority-->


	<!--RULE -->
<axsl:template match="mods:temporal[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M52"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:temporal[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@authority)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@authority)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@authority)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M52"/></axsl:template><axsl:template match="text()" priority="-1" mode="M52"/><axsl:template match="@*|node()" priority="-2" mode="M52"><axsl:apply-templates select="@*|*" mode="M52"/></axsl:template>

<!--PATTERN mods34_lang-->


	<!--RULE -->
<axsl:template match="mods:mods/*[(self::mods:originInfo or self::mods:physicalDescription or self::mods:classification    or self::mods:identifier or self::mods:accessCondition or self::mods:recordInfo or self::mods:titleInfo    or self::mods:targetAudience or self::mods:subject or self::mods:abstract or self::mods:tableOfContents) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M53"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:mods/*[(self::mods:originInfo or self::mods:physicalDescription or self::mods:classification    or self::mods:identifier or self::mods:accessCondition or self::mods:recordInfo or self::mods:titleInfo    or self::mods:targetAudience or self::mods:subject or self::mods:abstract or self::mods:tableOfContents) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@lang)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@lang)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@lang)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M53"/></axsl:template><axsl:template match="text()" priority="-1" mode="M53"/><axsl:template match="@*|node()" priority="-2" mode="M53"><axsl:apply-templates select="@*|*" mode="M53"/></axsl:template>

<!--PATTERN mods34_name_lang-->


	<!--RULE -->
<axsl:template match="mods:name[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M54"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:name[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@lang)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@lang)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@lang)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M54"/></axsl:template><axsl:template match="text()" priority="-1" mode="M54"/><axsl:template match="@*|node()" priority="-2" mode="M54"><axsl:apply-templates select="@*|*" mode="M54"/></axsl:template>

<!--PATTERN mods34_genre_lang-->


	<!--RULE -->
<axsl:template match="mods:genre[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M55"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:genre[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@lang)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@lang)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@lang)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M55"/></axsl:template><axsl:template match="text()" priority="-1" mode="M55"/><axsl:template match="@*|node()" priority="-2" mode="M55"><axsl:apply-templates select="@*|*" mode="M55"/></axsl:template>

<!--PATTERN mods34_recordContentSource_lang-->


	<!--RULE -->
<axsl:template match="mods:recordContentSource[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M56"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:recordContentSource[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@lang)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@lang)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@lang)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M56"/></axsl:template><axsl:template match="text()" priority="-1" mode="M56"/><axsl:template match="@*|node()" priority="-2" mode="M56"><axsl:apply-templates select="@*|*" mode="M56"/></axsl:template>

<!--PATTERN mods34_physicalLocation_lang-->


	<!--RULE -->
<axsl:template match="mods:physicalLocation[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M57"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:physicalLocation[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@lang)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@lang)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@lang)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M57"/></axsl:template><axsl:template match="text()" priority="-1" mode="M57"/><axsl:template match="@*|node()" priority="-2" mode="M57"><axsl:apply-templates select="@*|*" mode="M57"/></axsl:template>

<!--PATTERN mods34_xml_lang-->


	<!--RULE -->
<axsl:template match="mods:mods/*[(self::mods:originInfo or self::mods:physicalDescription or self::mods:classification    or self::mods:identifier or self::mods:accessCondition or self::mods:recordInfo or self::mods:titleInfo    or self::mods:targetAudience or self::mods:subject or self::mods:abstract or self::mods:tableOfContents) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M58"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:mods/*[(self::mods:originInfo or self::mods:physicalDescription or self::mods:classification    or self::mods:identifier or self::mods:accessCondition or self::mods:recordInfo or self::mods:titleInfo    or self::mods:targetAudience or self::mods:subject or self::mods:abstract or self::mods:tableOfContents) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@xml:lang)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@xml:lang)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@xml:lang)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M58"/></axsl:template><axsl:template match="text()" priority="-1" mode="M58"/><axsl:template match="@*|node()" priority="-2" mode="M58"><axsl:apply-templates select="@*|*" mode="M58"/></axsl:template>

<!--PATTERN mods34_name_xml_lang-->


	<!--RULE -->
<axsl:template match="mods:name[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M59"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:name[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@xml:lang)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@xml:lang)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@xml:lang)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M59"/></axsl:template><axsl:template match="text()" priority="-1" mode="M59"/><axsl:template match="@*|node()" priority="-2" mode="M59"><axsl:apply-templates select="@*|*" mode="M59"/></axsl:template>

<!--PATTERN mods34_genre_xml_lang-->


	<!--RULE -->
<axsl:template match="mods:genre[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M60"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:genre[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@xml:lang)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@xml:lang)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@xml:lang)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M60"/></axsl:template><axsl:template match="text()" priority="-1" mode="M60"/><axsl:template match="@*|node()" priority="-2" mode="M60"><axsl:apply-templates select="@*|*" mode="M60"/></axsl:template>

<!--PATTERN mods34_recordContentSource_xml_lang-->


	<!--RULE -->
<axsl:template match="mods:recordContentSource[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M61"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:recordContentSource[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@xml:lang)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@xml:lang)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@xml:lang)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M61"/></axsl:template><axsl:template match="text()" priority="-1" mode="M61"/><axsl:template match="@*|node()" priority="-2" mode="M61"><axsl:apply-templates select="@*|*" mode="M61"/></axsl:template>

<!--PATTERN mods34_physicalLocation_xml_lang-->


	<!--RULE -->
<axsl:template match="mods:physicalLocation[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M62"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:physicalLocation[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@xml:lang)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@xml:lang)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@xml:lang)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M62"/></axsl:template><axsl:template match="text()" priority="-1" mode="M62"/><axsl:template match="@*|node()" priority="-2" mode="M62"><axsl:apply-templates select="@*|*" mode="M62"/></axsl:template>

<!--PATTERN mods34_script-->


	<!--RULE -->
<axsl:template match="mods:mods/*[(self::mods:originInfo or self::mods:physicalDescription or self::mods:classification    or self::mods:identifier or self::mods:accessCondition or self::mods:recordInfo or self::mods:titleInfo    or self::mods:targetAudience or self::mods:subject or self::mods:abstract or self::mods:tableOfContents) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M63"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:mods/*[(self::mods:originInfo or self::mods:physicalDescription or self::mods:classification    or self::mods:identifier or self::mods:accessCondition or self::mods:recordInfo or self::mods:titleInfo    or self::mods:targetAudience or self::mods:subject or self::mods:abstract or self::mods:tableOfContents) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@script)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@script)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@script)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M63"/></axsl:template><axsl:template match="text()" priority="-1" mode="M63"/><axsl:template match="@*|node()" priority="-2" mode="M63"><axsl:apply-templates select="@*|*" mode="M63"/></axsl:template>

<!--PATTERN mods34_name_script-->


	<!--RULE -->
<axsl:template match="mods:name[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M64"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:name[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@script)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@script)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@script)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M64"/></axsl:template><axsl:template match="text()" priority="-1" mode="M64"/><axsl:template match="@*|node()" priority="-2" mode="M64"><axsl:apply-templates select="@*|*" mode="M64"/></axsl:template>

<!--PATTERN mods34_genre_script-->


	<!--RULE -->
<axsl:template match="mods:genre[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M65"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:genre[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@script)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@script)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@script)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M65"/></axsl:template><axsl:template match="text()" priority="-1" mode="M65"/><axsl:template match="@*|node()" priority="-2" mode="M65"><axsl:apply-templates select="@*|*" mode="M65"/></axsl:template>

<!--PATTERN mods34_recordContentSource_script-->


	<!--RULE -->
<axsl:template match="mods:recordContentSource[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M66"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:recordContentSource[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@script)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@script)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@script)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M66"/></axsl:template><axsl:template match="text()" priority="-1" mode="M66"/><axsl:template match="@*|node()" priority="-2" mode="M66"><axsl:apply-templates select="@*|*" mode="M66"/></axsl:template>

<!--PATTERN mods34_physicalLocation_script-->


	<!--RULE -->
<axsl:template match="mods:physicalLocation[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M67"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:physicalLocation[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@script)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@script)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@script)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M67"/></axsl:template><axsl:template match="text()" priority="-1" mode="M67"/><axsl:template match="@*|node()" priority="-2" mode="M67"><axsl:apply-templates select="@*|*" mode="M67"/></axsl:template>

<!--PATTERN mods34_transliteration-->


	<!--RULE -->
<axsl:template match="mods:mods/*[(self::mods:originInfo or self::mods:physicalDescription or self::mods:classification    or self::mods:identifier or self::mods:accessCondition or self::mods:recordInfo or self::mods:titleInfo    or self::mods:targetAudience or self::mods:subject or self::mods:abstract or self::mods:tableOfContents) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M68"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:mods/*[(self::mods:originInfo or self::mods:physicalDescription or self::mods:classification    or self::mods:identifier or self::mods:accessCondition or self::mods:recordInfo or self::mods:titleInfo    or self::mods:targetAudience or self::mods:subject or self::mods:abstract or self::mods:tableOfContents) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@transliteration)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@transliteration)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@transliteration)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M68"/></axsl:template><axsl:template match="text()" priority="-1" mode="M68"/><axsl:template match="@*|node()" priority="-2" mode="M68"><axsl:apply-templates select="@*|*" mode="M68"/></axsl:template>

<!--PATTERN mods34_name_transliteration-->


	<!--RULE -->
<axsl:template match="mods:name[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M69"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:name[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@transliteration)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@transliteration)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@transliteration)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M69"/></axsl:template><axsl:template match="text()" priority="-1" mode="M69"/><axsl:template match="@*|node()" priority="-2" mode="M69"><axsl:apply-templates select="@*|*" mode="M69"/></axsl:template>

<!--PATTERN mods34_genre_transliteration-->


	<!--RULE -->
<axsl:template match="mods:genre[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M70"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:genre[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@transliteration)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@transliteration)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@transliteration)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M70"/></axsl:template><axsl:template match="text()" priority="-1" mode="M70"/><axsl:template match="@*|node()" priority="-2" mode="M70"><axsl:apply-templates select="@*|*" mode="M70"/></axsl:template>

<!--PATTERN mods34_recordContentSource_transliteration-->


	<!--RULE -->
<axsl:template match="mods:recordContentSource[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M71"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:recordContentSource[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@transliteration)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@transliteration)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@transliteration)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M71"/></axsl:template><axsl:template match="text()" priority="-1" mode="M71"/><axsl:template match="@*|node()" priority="-2" mode="M71"><axsl:apply-templates select="@*|*" mode="M71"/></axsl:template>

<!--PATTERN mods34_physicalLocation_transliteration-->


	<!--RULE -->
<axsl:template match="mods:physicalLocation[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M72"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:physicalLocation[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@transliteration)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@transliteration)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@transliteration)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M72"/></axsl:template><axsl:template match="text()" priority="-1" mode="M72"/><axsl:template match="@*|node()" priority="-2" mode="M72"><axsl:apply-templates select="@*|*" mode="M72"/></axsl:template>

<!--PATTERN mods34_issuance_values1-->


	<!--RULE -->
<axsl:template match="mods:issuance[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M73"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:issuance[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="normalize-space(.)!=string('single unit')"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="normalize-space(.)!=string('single unit')"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Value '<axsl:text/><axsl:value-of select="."/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>').
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M73"/></axsl:template><axsl:template match="text()" priority="-1" mode="M73"/><axsl:template match="@*|node()" priority="-2" mode="M73"><axsl:apply-templates select="@*|*" mode="M73"/></axsl:template>

<!--PATTERN mods34_issuance_values2-->


	<!--RULE -->
<axsl:template match="mods:issuance[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M74"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:issuance[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="normalize-space(.)!=string('multipart monograph')"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="normalize-space(.)!=string('multipart monograph')"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Value '<axsl:text/><axsl:value-of select="."/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>').
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M74"/></axsl:template><axsl:template match="text()" priority="-1" mode="M74"/><axsl:template match="@*|node()" priority="-2" mode="M74"><axsl:apply-templates select="@*|*" mode="M74"/></axsl:template>

<!--PATTERN mods34_issuance_values3-->


	<!--RULE -->
<axsl:template match="mods:issuance[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M75"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:issuance[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="normalize-space(.)!=string('serial')"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="normalize-space(.)!=string('serial')"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Value '<axsl:text/><axsl:value-of select="."/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>').
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M75"/></axsl:template><axsl:template match="text()" priority="-1" mode="M75"/><axsl:template match="@*|node()" priority="-2" mode="M75"><axsl:apply-templates select="@*|*" mode="M75"/></axsl:template>

<!--PATTERN mods34_issuance_values4-->


	<!--RULE -->
<axsl:template match="mods:issuance[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M76"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:issuance[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="normalize-space(.)!=string('integrating resource')"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="normalize-space(.)!=string('integrating resource')"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Value '<axsl:text/><axsl:value-of select="."/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>').
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M76"/></axsl:template><axsl:template match="text()" priority="-1" mode="M76"/><axsl:template match="@*|node()" priority="-2" mode="M76"><axsl:apply-templates select="@*|*" mode="M76"/></axsl:template>

<!--PATTERN mods34_encoding_values1-->


	<!--RULE -->
<axsl:template match="mods:mods//*[@encoding and (@encoding) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M77"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:mods//*[@encoding and (@encoding) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="normalize-space(@encoding)!=string('temper')"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="normalize-space(@encoding)!=string('temper')"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Value '<axsl:text/><axsl:value-of select="@encoding"/><axsl:text/>' is not allowed in attribute '<axsl:text/><axsl:value-of select="name(@encoding)"/><axsl:text/>' in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>').
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M77"/></axsl:template><axsl:template match="text()" priority="-1" mode="M77"/><axsl:template match="@*|node()" priority="-2" mode="M77"><axsl:apply-templates select="@*|*" mode="M77"/></axsl:template>

<!--PATTERN mods34_encoding_values2-->


	<!--RULE -->
<axsl:template match="mods:mods//*[@encoding and (@encoding) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M78"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:mods//*[@encoding and (@encoding) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="normalize-space(@encoding)!=string('edtf')"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="normalize-space(@encoding)!=string('edtf')"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Value '<axsl:text/><axsl:value-of select="@encoding"/><axsl:text/>' is not allowed in attribute '<axsl:text/><axsl:value-of select="name(@encoding)"/><axsl:text/>' in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>').
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M78"/></axsl:template><axsl:template match="text()" priority="-1" mode="M78"/><axsl:template match="@*|node()" priority="-2" mode="M78"><axsl:apply-templates select="@*|*" mode="M78"/></axsl:template>

<!--PATTERN mods34_name_type_values-->


	<!--RULE -->
<axsl:template match="mods:name[@type and (true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M79"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:name[@type and (true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="normalize-space(@type)!=string('family')"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="normalize-space(@type)!=string('family')"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Value '<axsl:text/><axsl:value-of select="@type"/><axsl:text/>' is not allowed in attribute '<axsl:text/><axsl:value-of select="name(@type)"/><axsl:text/>' in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>').
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M79"/></axsl:template><axsl:template match="text()" priority="-1" mode="M79"/><axsl:template match="@*|node()" priority="-2" mode="M79"><axsl:apply-templates select="@*|*" mode="M79"/></axsl:template>

<!--PATTERN mods34_relatedItem_type_values1-->


	<!--RULE -->
<axsl:template match="mods:relatedItem[@type and (true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M80"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:relatedItem[@type and (true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="normalize-space(@type)!=string('references')"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="normalize-space(@type)!=string('references')"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Value '<axsl:text/><axsl:value-of select="@type"/><axsl:text/>' is not allowed in attribute '<axsl:text/><axsl:value-of select="name(@type)"/><axsl:text/>' in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>').
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M80"/></axsl:template><axsl:template match="text()" priority="-1" mode="M80"/><axsl:template match="@*|node()" priority="-2" mode="M80"><axsl:apply-templates select="@*|*" mode="M80"/></axsl:template>

<!--PATTERN mods34_relatedItem_type_values2-->


	<!--RULE -->
<axsl:template match="mods:relatedItem[@type and (true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M81"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:relatedItem[@type and (true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="normalize-space(@type)!=string('reviewOf')"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="normalize-space(@type)!=string('reviewOf')"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Value '<axsl:text/><axsl:value-of select="@type"/><axsl:text/>' is not allowed in attribute '<axsl:text/><axsl:value-of select="name(@type)"/><axsl:text/>' in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>').
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M81"/></axsl:template><axsl:template match="text()" priority="-1" mode="M81"/><axsl:template match="@*|node()" priority="-2" mode="M81"><axsl:apply-templates select="@*|*" mode="M81"/></axsl:template>

<!--PATTERN mods34_usage_values-->


	<!--RULE -->
<axsl:template match="mods:url[@usage and (true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]" priority="1000" mode="M82"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:url[@usage and (true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.4'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="normalize-space(@usage)!=string('primary')"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="normalize-space(@usage)!=string('primary')"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Value '<axsl:text/><axsl:value-of select="@usage"/><axsl:text/>' is not allowed in attribute '<axsl:text/><axsl:value-of select="name(@usage)"/><axsl:text/>' in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.4')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>').
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M82"/></axsl:template><axsl:template match="text()" priority="-1" mode="M82"/><axsl:template match="@*|node()" priority="-2" mode="M82"><axsl:apply-templates select="@*|*" mode="M82"/></axsl:template>

<!--PATTERN mods33_authority-->


	<!--RULE -->
<axsl:template match="mods:frequency[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]" priority="1000" mode="M83"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:frequency[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@authority)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@authority)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@authority)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.3')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M83"/></axsl:template><axsl:template match="text()" priority="-1" mode="M83"/><axsl:template match="@*|node()" priority="-2" mode="M83"><axsl:apply-templates select="@*|*" mode="M83"/></axsl:template>

<!--PATTERN mods33_physicalLocation_xlink_type-->


	<!--RULE -->
<axsl:template match="mods:physicalLocation[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]" priority="1000" mode="M84"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:physicalLocation[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@xlink:type)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@xlink:type)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@xlink:type)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.3')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M84"/></axsl:template><axsl:template match="text()" priority="-1" mode="M84"/><axsl:template match="@*|node()" priority="-2" mode="M84"><axsl:apply-templates select="@*|*" mode="M84"/></axsl:template>

<!--PATTERN mods33_physicalLocation_xlink_href-->


	<!--RULE -->
<axsl:template match="mods:physicalLocation[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]" priority="1000" mode="M85"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:physicalLocation[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@xlink:href)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@xlink:href)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@xlink:href)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.3')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M85"/></axsl:template><axsl:template match="text()" priority="-1" mode="M85"/><axsl:template match="@*|node()" priority="-2" mode="M85"><axsl:apply-templates select="@*|*" mode="M85"/></axsl:template>

<!--PATTERN mods33_physicalLocation_xlink_role-->


	<!--RULE -->
<axsl:template match="mods:physicalLocation[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]" priority="1000" mode="M86"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:physicalLocation[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@xlink:role)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@xlink:role)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@xlink:role)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.3')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M86"/></axsl:template><axsl:template match="text()" priority="-1" mode="M86"/><axsl:template match="@*|node()" priority="-2" mode="M86"><axsl:apply-templates select="@*|*" mode="M86"/></axsl:template>

<!--PATTERN mods33_physicalLocation_xlink_arcrole-->


	<!--RULE -->
<axsl:template match="mods:physicalLocation[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]" priority="1000" mode="M87"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:physicalLocation[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@xlink:arcrole)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@xlink:arcrole)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@xlink:arcrole)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.3')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M87"/></axsl:template><axsl:template match="text()" priority="-1" mode="M87"/><axsl:template match="@*|node()" priority="-2" mode="M87"><axsl:apply-templates select="@*|*" mode="M87"/></axsl:template>

<!--PATTERN mods33_physicalLocation_xlink_title-->


	<!--RULE -->
<axsl:template match="mods:physicalLocation[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]" priority="1000" mode="M88"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:physicalLocation[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@xlink:title)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@xlink:title)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@xlink:title)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.3')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M88"/></axsl:template><axsl:template match="text()" priority="-1" mode="M88"/><axsl:template match="@*|node()" priority="-2" mode="M88"><axsl:apply-templates select="@*|*" mode="M88"/></axsl:template>

<!--PATTERN mods33_physicalLocation_xlink_show-->


	<!--RULE -->
<axsl:template match="mods:physicalLocation[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]" priority="1000" mode="M89"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:physicalLocation[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@xlink:show)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@xlink:show)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@xlink:show)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.3')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M89"/></axsl:template><axsl:template match="text()" priority="-1" mode="M89"/><axsl:template match="@*|node()" priority="-2" mode="M89"><axsl:apply-templates select="@*|*" mode="M89"/></axsl:template>

<!--PATTERN mods33_physicalLocation_xlink_actuate-->


	<!--RULE -->
<axsl:template match="mods:physicalLocation[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]" priority="1000" mode="M90"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:physicalLocation[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@xlink:actuate)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@xlink:actuate)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@xlink:actuate)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.3')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M90"/></axsl:template><axsl:template match="text()" priority="-1" mode="M90"/><axsl:template match="@*|node()" priority="-2" mode="M90"><axsl:apply-templates select="@*|*" mode="M90"/></axsl:template>

<!--PATTERN mods33_extraterrestrialArea-->


	<!--RULE -->
<axsl:template match="mods:hierarchicalGeographic[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]" priority="1000" mode="M91"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:hierarchicalGeographic[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(./mods:extraterrestrialArea)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(./mods:extraterrestrialArea)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Element '<axsl:text/><axsl:value-of select="name(mods:extraterrestrialArea)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.3')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M91"/></axsl:template><axsl:template match="text()" priority="-1" mode="M91"/><axsl:template match="@*|node()" priority="-2" mode="M91"><axsl:apply-templates select="@*|*" mode="M91"/></axsl:template>

<!--PATTERN mods33_citySection-->


	<!--RULE -->
<axsl:template match="mods:hierarchicalGeographic[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]" priority="1000" mode="M92"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:hierarchicalGeographic[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(./mods:citySection)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(./mods:citySection)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Element '<axsl:text/><axsl:value-of select="name(mods:citySection)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.3')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M92"/></axsl:template><axsl:template match="text()" priority="-1" mode="M92"/><axsl:template match="@*|node()" priority="-2" mode="M92"><axsl:apply-templates select="@*|*" mode="M92"/></axsl:template>

<!--PATTERN mods33_shelfLocator-->


	<!--RULE -->
<axsl:template match="mods:location[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]" priority="1000" mode="M93"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:location[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(./mods:shelfLocator)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(./mods:shelfLocator)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Element '<axsl:text/><axsl:value-of select="name(mods:shelfLocator)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.3')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M93"/></axsl:template><axsl:template match="text()" priority="-1" mode="M93"/><axsl:template match="@*|node()" priority="-2" mode="M93"><axsl:apply-templates select="@*|*" mode="M93"/></axsl:template>

<!--PATTERN mods33_holdingSimple-->


	<!--RULE -->
<axsl:template match="mods:location[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]" priority="1000" mode="M94"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:location[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(./mods:holdingSimple)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(./mods:holdingSimple)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Element '<axsl:text/><axsl:value-of select="name(mods:holdingSimple)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.3')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M94"/></axsl:template><axsl:template match="text()" priority="-1" mode="M94"/><axsl:template match="@*|node()" priority="-2" mode="M94"><axsl:apply-templates select="@*|*" mode="M94"/></axsl:template>

<!--PATTERN mods33_location_holdingExternal-->


	<!--RULE -->
<axsl:template match="mods:location[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]" priority="1000" mode="M95"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:location[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(./mods:holdingExternal)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(./mods:holdingExternal)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Element '<axsl:text/><axsl:value-of select="name(mods:holdingExternal)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.3')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M95"/></axsl:template><axsl:template match="text()" priority="-1" mode="M95"/><axsl:template match="@*|node()" priority="-2" mode="M95"><axsl:apply-templates select="@*|*" mode="M95"/></axsl:template>

<!--PATTERN mods33_recordInfo_holdingExternal-->


	<!--RULE -->
<axsl:template match="mods:recordInfo[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]" priority="1000" mode="M96"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:recordInfo[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(./mods:holdingExternal)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(./mods:holdingExternal)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Element '<axsl:text/><axsl:value-of select="name(mods:holdingExternal)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.3')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M96"/></axsl:template><axsl:template match="text()" priority="-1" mode="M96"/><axsl:template match="@*|node()" priority="-2" mode="M96"><axsl:apply-templates select="@*|*" mode="M96"/></axsl:template>

<!--PATTERN mods33_languageTerm_authority_values-->


	<!--RULE -->
<axsl:template match="mods:languageTerm[@authority and (true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]" priority="1000" mode="M97"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:languageTerm[@authority and (true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="normalize-space(@authority)!=string('rfc4646')"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="normalize-space(@authority)!=string('rfc4646')"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Value '<axsl:text/><axsl:value-of select="@authority"/><axsl:text/>' is not allowed in attribute '<axsl:text/><axsl:value-of select="name(@authority)"/><axsl:text/>' in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.3')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>').
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M97"/></axsl:template><axsl:template match="text()" priority="-1" mode="M97"/><axsl:template match="@*|node()" priority="-2" mode="M97"><axsl:apply-templates select="@*|*" mode="M97"/></axsl:template>

<!--PATTERN mods33_typeOfResource_values-->


	<!--RULE -->
<axsl:template match="mods:typeOfResource[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]" priority="1000" mode="M98"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:typeOfResource[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="normalize-space(.)!=string('')"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="normalize-space(.)!=string('')"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Value '<axsl:text/><axsl:value-of select="."/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.3')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>').
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M98"/></axsl:template><axsl:template match="text()" priority="-1" mode="M98"/><axsl:template match="@*|node()" priority="-2" mode="M98"><axsl:apply-templates select="@*|*" mode="M98"/></axsl:template>

<!--PATTERN mods33_extension-->


	<!--RULE -->
<axsl:template match="mods:extension[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]" priority="1000" mode="M99"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:extension[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="./*"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="./*"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' requires sub-elements in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.3')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>').
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M99"/></axsl:template><axsl:template match="text()" priority="-1" mode="M99"/><axsl:template match="@*|node()" priority="-2" mode="M99"><axsl:apply-templates select="@*|*" mode="M99"/></axsl:template>

<!--PATTERN mods33_accessCondition-->


	<!--RULE -->
<axsl:template match="mods:accessCondition[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]" priority="1000" mode="M100"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:accessCondition[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.3'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="./*"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="./*"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' requires sub-elements in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.3')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>').
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M100"/></axsl:template><axsl:template match="text()" priority="-1" mode="M100"/><axsl:template match="@*|node()" priority="-2" mode="M100"><axsl:apply-templates select="@*|*" mode="M100"/></axsl:template>

<!--PATTERN mods32_ID-->


	<!--RULE -->
<axsl:template match="mods:mods/*[(self::mods:note or self::mods:relatedItem or self::mods:part) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.2'))]" priority="1000" mode="M101"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:mods/*[(self::mods:note or self::mods:relatedItem or self::mods:part) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.2'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@ID)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@ID)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@ID)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.2')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M101"/></axsl:template><axsl:template match="text()" priority="-1" mode="M101"/><axsl:template match="@*|node()" priority="-2" mode="M101"><axsl:apply-templates select="@*|*" mode="M101"/></axsl:template>

<!--PATTERN mods32_note_ID-->


	<!--RULE -->
<axsl:template match="mods:physicalDescription/mods:note[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.2'))]" priority="1000" mode="M102"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:physicalDescription/mods:note[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.2'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@ID)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@ID)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@ID)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.2')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M102"/></axsl:template><axsl:template match="text()" priority="-1" mode="M102"/><axsl:template match="@*|node()" priority="-2" mode="M102"><axsl:apply-templates select="@*|*" mode="M102"/></axsl:template>

<!--PATTERN mods32_note-->


	<!--RULE -->
<axsl:template match="mods:url[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.2'))]" priority="1000" mode="M103"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:url[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.2'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@note)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@note)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@note)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.2')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M103"/></axsl:template><axsl:template match="text()" priority="-1" mode="M103"/><axsl:template match="@*|node()" priority="-2" mode="M103"><axsl:apply-templates select="@*|*" mode="M103"/></axsl:template>

<!--PATTERN mods32_access-->


	<!--RULE -->
<axsl:template match="mods:url[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.2'))]" priority="1000" mode="M104"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:url[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.2'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@access)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@access)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@access)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.2')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M104"/></axsl:template><axsl:template match="text()" priority="-1" mode="M104"/><axsl:template match="@*|node()" priority="-2" mode="M104"><axsl:apply-templates select="@*|*" mode="M104"/></axsl:template>

<!--PATTERN mods32_usage-->


	<!--RULE -->
<axsl:template match="mods:url[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.2'))]" priority="1000" mode="M105"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:url[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.2'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@usage)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@usage)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@usage)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.2')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M105"/></axsl:template><axsl:template match="text()" priority="-1" mode="M105"/><axsl:template match="@*|node()" priority="-2" mode="M105"><axsl:apply-templates select="@*|*" mode="M105"/></axsl:template>

<!--PATTERN mods32_type-->


	<!--RULE -->
<axsl:template match="mods:part[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.2'))]" priority="1000" mode="M106"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:part[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.2'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@type)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@type)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@type)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.2')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M106"/></axsl:template><axsl:template match="text()" priority="-1" mode="M106"/><axsl:template match="@*|node()" priority="-2" mode="M106"><axsl:apply-templates select="@*|*" mode="M106"/></axsl:template>

<!--PATTERN mods32_order-->


	<!--RULE -->
<axsl:template match="mods:part[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.2'))]" priority="1000" mode="M107"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:part[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.2'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@order)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@order)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@order)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.2')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M107"/></axsl:template><axsl:template match="text()" priority="-1" mode="M107"/><axsl:template match="@*|node()" priority="-2" mode="M107"><axsl:apply-templates select="@*|*" mode="M107"/></axsl:template>

<!--PATTERN mods32_genre-->


	<!--RULE -->
<axsl:template match="mods:subject[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.2'))]" priority="1000" mode="M108"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:subject[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.2'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(./mods:genre)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(./mods:genre)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Element '<axsl:text/><axsl:value-of select="name(mods:genre)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.2')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M108"/></axsl:template><axsl:template match="text()" priority="-1" mode="M108"/><axsl:template match="@*|node()" priority="-2" mode="M108"><axsl:apply-templates select="@*|*" mode="M108"/></axsl:template>

<!--PATTERN mods32_digitalOrigin_values1-->


	<!--RULE -->
<axsl:template match="mods:digitalOrigin[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.2'))]" priority="1000" mode="M109"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:digitalOrigin[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.2'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="normalize-space(.)!=string('digitized microfilm')"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="normalize-space(.)!=string('digitized microfilm')"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Value '<axsl:text/><axsl:value-of select="."/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.2')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>').
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M109"/></axsl:template><axsl:template match="text()" priority="-1" mode="M109"/><axsl:template match="@*|node()" priority="-2" mode="M109"><axsl:apply-templates select="@*|*" mode="M109"/></axsl:template>

<!--PATTERN mods32_digitalOrigin_values2-->


	<!--RULE -->
<axsl:template match="mods:digitalOrigin[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.2'))]" priority="1000" mode="M110"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:digitalOrigin[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.2'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="normalize-space(.)!=string('digitized other analog')"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="normalize-space(.)!=string('digitized other analog')"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Value '<axsl:text/><axsl:value-of select="."/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.2')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>').
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M110"/></axsl:template><axsl:template match="text()" priority="-1" mode="M110"/><axsl:template match="@*|node()" priority="-2" mode="M110"><axsl:apply-templates select="@*|*" mode="M110"/></axsl:template>

<!--PATTERN mods31_genre_type-->


	<!--RULE -->
<axsl:template match="mods:genre[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.1'))]" priority="1000" mode="M111"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:genre[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.1'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@type)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@type)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@type)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.1')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M111"/></axsl:template><axsl:template match="text()" priority="-1" mode="M111"/><axsl:template match="@*|node()" priority="-2" mode="M111"><axsl:apply-templates select="@*|*" mode="M111"/></axsl:template>

<!--PATTERN mods31_dateOther_type-->


	<!--RULE -->
<axsl:template match="mods:dateOther[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.1'))]" priority="1000" mode="M112"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:dateOther[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.1'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@type)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@type)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@type)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.1')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M112"/></axsl:template><axsl:template match="text()" priority="-1" mode="M112"/><axsl:template match="@*|node()" priority="-2" mode="M112"><axsl:apply-templates select="@*|*" mode="M112"/></axsl:template>

<!--PATTERN mods31_form_type-->


	<!--RULE -->
<axsl:template match="mods:form[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.1'))]" priority="1000" mode="M113"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:form[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.1'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@type)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@type)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@type)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.1')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M113"/></axsl:template><axsl:template match="text()" priority="-1" mode="M113"/><axsl:template match="@*|node()" priority="-2" mode="M113"><axsl:apply-templates select="@*|*" mode="M113"/></axsl:template>

<!--PATTERN mods31_physicalLocation_type-->


	<!--RULE -->
<axsl:template match="mods:physicalLocation[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.1'))]" priority="1000" mode="M114"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:physicalLocation[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.1'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@type)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@type)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@type)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.1')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M114"/></axsl:template><axsl:template match="text()" priority="-1" mode="M114"/><axsl:template match="@*|node()" priority="-2" mode="M114"><axsl:apply-templates select="@*|*" mode="M114"/></axsl:template>

<!--PATTERN mods31_language_objectPart-->


	<!--RULE -->
<axsl:template match="mods:language[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.1'))]" priority="1000" mode="M115"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:language[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.1'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@objectPart)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@objectPart)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@objectPart)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.1')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M115"/></axsl:template><axsl:template match="text()" priority="-1" mode="M115"/><axsl:template match="@*|node()" priority="-2" mode="M115"><axsl:apply-templates select="@*|*" mode="M115"/></axsl:template>

<!--PATTERN mods31_languageOfCataloging_objectPart-->


	<!--RULE -->
<axsl:template match="mods:languageOfCataloging[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.1'))]" priority="1000" mode="M116"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:languageOfCataloging[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.1'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@objectPart)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@objectPart)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@objectPart)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.1')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M116"/></axsl:template><axsl:template match="text()" priority="-1" mode="M116"/><axsl:template match="@*|node()" priority="-2" mode="M116"><axsl:apply-templates select="@*|*" mode="M116"/></axsl:template>

<!--PATTERN mods31_displayLabel-->


	<!--RULE -->
<axsl:template match="mods:classification[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.1'))]" priority="1000" mode="M117"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:classification[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.1'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(@displayLabel)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(@displayLabel)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Attribute '<axsl:text/><axsl:value-of select="name(@displayLabel)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.1')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M117"/></axsl:template><axsl:template match="text()" priority="-1" mode="M117"/><axsl:template match="@*|node()" priority="-2" mode="M117"><axsl:apply-templates select="@*|*" mode="M117"/></axsl:template>

<!--PATTERN mods31_part-->


	<!--RULE -->
<axsl:template match="mods:mods[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.1'))]" priority="1000" mode="M118"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:mods[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.1'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(./mods:part)"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="not(./mods:part)"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Element '<axsl:text/><axsl:value-of select="name(mods:part)"/><axsl:text/>' is not allowed in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.1')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M118"/></axsl:template><axsl:template match="text()" priority="-1" mode="M118"/><axsl:template match="@*|node()" priority="-2" mode="M118"><axsl:apply-templates select="@*|*" mode="M118"/></axsl:template>

<!--PATTERN mods31_coordinates-->


	<!--RULE -->
<axsl:template match="mods:cartographics[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.1'))]" priority="1000" mode="M119"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:cartographics[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.1'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="mods:coordinates"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="mods:coordinates"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Element '<axsl:text/><axsl:value-of select="string('mods:coordinates')"/><axsl:text/>' is required in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.1')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>')
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M119"/></axsl:template><axsl:template match="text()" priority="-1" mode="M119"/><axsl:template match="@*|node()" priority="-2" mode="M119"><axsl:apply-templates select="@*|*" mode="M119"/></axsl:template>

<!--PATTERN mods31_titleInfo-->


	<!--RULE -->
<axsl:template match="mods:titleInfo[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.1'))]" priority="1000" mode="M120"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:titleInfo[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.1'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="./*"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="./*"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' requires sub-elements in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.1')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>').
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M120"/></axsl:template><axsl:template match="text()" priority="-1" mode="M120"/><axsl:template match="@*|node()" priority="-2" mode="M120"><axsl:apply-templates select="@*|*" mode="M120"/></axsl:template>

<!--PATTERN mods31_name-->


	<!--RULE -->
<axsl:template match="mods:name[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.1'))]" priority="1000" mode="M121"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:name[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.1'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="./*"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="./*"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' requires sub-elements in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.1')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>').
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M121"/></axsl:template><axsl:template match="text()" priority="-1" mode="M121"/><axsl:template match="@*|node()" priority="-2" mode="M121"><axsl:apply-templates select="@*|*" mode="M121"/></axsl:template>

<!--PATTERN mods31_subject-->


	<!--RULE -->
<axsl:template match="mods:subject[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.1'))]" priority="1000" mode="M122"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mods:subject[(true()) and normalize-space(ancestor::mets:mdWrap/@MDTYPE)=string('MODS') and ancestor::mets:mdWrap/@MDTYPEVERSION and number(normalize-space(ancestor::mets:mdWrap/@MDTYPEVERSION)) &lt; number(string('3.1'))]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="./*"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="./*"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' requires sub-elements in <axsl:text/><axsl:value-of select="string('MODS')"/><axsl:text/> version older than <axsl:text/><axsl:value-of select="string('3.1')"/><axsl:text/>. (ID of the METS metadata section '<axsl:text/><axsl:value-of select="name(ancestor::mets:mdWrap/..)"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="ancestor::mets:mdWrap/../@ID"/><axsl:text/>').
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M122"/></axsl:template><axsl:template match="text()" priority="-1" mode="M122"/><axsl:template match="@*|node()" priority="-2" mode="M122"><axsl:apply-templates select="@*|*" mode="M122"/></axsl:template></axsl:stylesheet>
