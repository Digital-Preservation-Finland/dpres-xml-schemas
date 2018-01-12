<axsl:stylesheet xmlns:axsl="http://www.w3.org/1999/XSL/Transform" xmlns:sch="http://www.ascc.net/xml/schematron" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:mets="http://www.loc.gov/METS/" xmlns:fi="http://www.kdk.fi/standards/mets/kdk-extensions" xmlns:exsl="http://exslt.org/common" xmlns:sets="http://exslt.org/sets" xmlns:str="http://exslt.org/strings" version="1.0"><!--Implementers: please note that overriding process-prolog or process-root is 
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
<axsl:template match="/"><svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" title="METS Cultural data profile validation" schemaVersion="1.7.0"><axsl:comment><axsl:value-of select="$archiveDirParameter"/>   
		 <axsl:value-of select="$archiveNameParameter"/>  
		 <axsl:value-of select="$fileNameParameter"/>  
		 <axsl:value-of select="$fileDirParameter"/></axsl:comment><svrl:ns-prefix-in-attribute-values uri="http://www.loc.gov/METS/" prefix="mets"/><svrl:ns-prefix-in-attribute-values uri="http://www.kdk.fi/standards/mets/kdk-extensions" prefix="fi"/><svrl:ns-prefix-in-attribute-values uri="http://exslt.org/common" prefix="exsl"/><svrl:ns-prefix-in-attribute-values uri="http://exslt.org/sets" prefix="sets"/><svrl:ns-prefix-in-attribute-values uri="http://exslt.org/strings" prefix="str"/><svrl:active-pattern><axsl:attribute name="id">profile_parameter_names</axsl:attribute><axsl:attribute name="name">profile_parameter_names</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M9"/><svrl:active-pattern><axsl:attribute name="id">mets_CATALOG_values</axsl:attribute><axsl:attribute name="name">mets_CATALOG_values</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M10"/><svrl:active-pattern><axsl:attribute name="id">mets_SPECIFICATION_values</axsl:attribute><axsl:attribute name="name">mets_SPECIFICATION_values</axsl:attribute><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M11"/></svrl:schematron-output></axsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon">METS Cultural data profile validation</svrl:text><axsl:param name="culture_profiles" select="exsl:node-set('http://www.kdk.fi/kdk-mets-profile')"/><axsl:param name="culture_profile_params" select=""/><axsl:param name="given_profile" select="str:split(normalize-space(/mets:mets/@PROFILE), '?')"/>

<!--PATTERN profile_parameter_names-->


	<!--RULE -->
<axsl:template match="mets:mets" priority="1000" mode="M9"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mets:mets"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="count($research_profile_params) = count(sets:distinct(str:tokenize($given_profile[2], '&amp;=')[position() mod 2 = 1] | $research_profile_params))    or not(count($research_profiles) = count(sets:distinct(exsl:node-set($given_profile[1]) | $research_profiles)))"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="count($research_profile_params) = count(sets:distinct(str:tokenize($given_profile[2], '&amp;=')[position() mod 2 = 1] | $research_profile_params)) or not(count($research_profiles) = count(sets:distinct(exsl:node-set($given_profile[1]) | $research_profiles)))"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Unknown parameter name in attribute 'PROFILE'.
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M9"/></axsl:template><axsl:template match="text()" priority="-1" mode="M9"/><axsl:template match="@*|node()" priority="-2" mode="M9"><axsl:apply-templates select="@*|*" mode="M9"/></axsl:template>

<!--PATTERN mets_CATALOG_values-->


	<!--RULE -->
<axsl:template match="mets:mets[@fi:CATALOG and not(contains(@fi:CATALOG, ';')) and (true())]" priority="1001" mode="M10"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mets:mets[@fi:CATALOG and not(contains(@fi:CATALOG, ';')) and (true())]"/><axsl:variable name="given_profile" select="str:split(normalize-space(/mets:mets/@PROFILE), '?')"/><axsl:variable name="section_context" select="ancestor-or-self::*[self::mets:dmdSec or self::mets:techMD or self::mets:rightsMD or self::mets:sourceMD or self::mets:digiprovMD]"/><axsl:variable name="section_string" select="concat('(ID of the metadata section ', name($section_context), ' is ', $section_context/@ID, ')')"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="(contains(concat('; ',string('1.5.0; 1.6.0; 1.7.0'),'; '), concat('; ',normalize-space(@fi:CATALOG),'; ')))     or not(str:concat(exsl:node-set(''))='' or count(exsl:node-set('')) = count(sets:distinct(exsl:node-set($given_profile[1]) | exsl:node-set('')))) or not(normalize-space(string(''))=''    or ((normalize-space(substring(string(''),1,4))='not:') and ((not(contains(concat('; ',normalize-space(substring-after(string(''),':')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:CATALOG),'; ')))) and not(contains(concat('; ',normalize-space(substring-after(string(''),':')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:SPECIFICATION),'; ')))))    or ((normalize-space(substring(string(''),1,4))!='not:') and ((contains(concat('; ',normalize-space(string('')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:CATALOG),'; '))) or (contains(concat('; ',normalize-space(string('')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:SPECIFICATION),'; '))))))"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="(contains(concat('; ',string('1.5.0; 1.6.0; 1.7.0'),'; '), concat('; ',normalize-space(@fi:CATALOG),'; '))) or not(str:concat(exsl:node-set(''))='' or count(exsl:node-set('')) = count(sets:distinct(exsl:node-set($given_profile[1]) | exsl:node-set('')))) or not(normalize-space(string(''))='' or ((normalize-space(substring(string(''),1,4))='not:') and ((not(contains(concat('; ',normalize-space(substring-after(string(''),':')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:CATALOG),'; ')))) and not(contains(concat('; ',normalize-space(substring-after(string(''),':')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:SPECIFICATION),'; '))))) or ((normalize-space(substring(string(''),1,4))!='not:') and ((contains(concat('; ',normalize-space(string('')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:CATALOG),'; '))) or (contains(concat('; ',normalize-space(string('')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:SPECIFICATION),'; '))))))"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Value '<axsl:text/><axsl:value-of select="@fi:CATALOG"/><axsl:text/>' is not allowed in attribute '<axsl:text/><axsl:value-of select="name(@fi:CATALOG)"/><axsl:text/>' in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>'. <axsl:text/><axsl:value-of select="substring($section_string,1,number($section_context)*string-length($section_string))"/><axsl:text/> Valid values are: <axsl:text/><axsl:value-of select="string(string('1.5.0; 1.6.0; 1.7.0'))"/><axsl:text/>
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M10"/></axsl:template>

	<!--RULE -->
<axsl:template match="mets:mets/@fi:CATALOG[contains(., ';') and (true())]" priority="1000" mode="M10"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mets:mets/@fi:CATALOG[contains(., ';') and (true())]"/><axsl:variable name="given_profile" select="str:split(normalize-space(/mets:mets/@PROFILE), '?')"/><axsl:variable name="section_context" select="ancestor-or-self::*[self::mets:dmdSec or self::mets:techMD or self::mets:rightsMD or self::mets:sourceMD or self::mets:digiprovMD]"/><axsl:variable name="section_string" select="concat('(ID of the metadata section ', name($section_context), ' is ', $section_context/@ID, ')')"/><axsl:variable name="params" select="str:split(.,';')"/><axsl:variable name="realValue" select="concat(normalize-space($params[1]), ';', normalize-space($params[2]))"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="(contains(concat('; ',string('1.5.0; 1.6.0; 1.7.0'),'; '), concat('; ',$realValue,'; ')))     or not(str:concat(exsl:node-set(''))='' or count(exsl:node-set('')) = count(sets:distinct(exsl:node-set($given_profile[1]) | exsl:node-set('')))) or not(normalize-space(string(''))=''    or ((normalize-space(substring(string(''),1,4))='not:') and ((not(contains(concat('; ',normalize-space(substring-after(string(''),':')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:CATALOG),'; ')))) and not(contains(concat('; ',normalize-space(substring-after(string(''),':')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:SPECIFICATION),'; ')))))    or ((normalize-space(substring(string(''),1,4))!='not:') and ((contains(concat('; ',normalize-space(string('')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:CATALOG),'; '))) or (contains(concat('; ',normalize-space(string('')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:SPECIFICATION),'; '))))))"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="(contains(concat('; ',string('1.5.0; 1.6.0; 1.7.0'),'; '), concat('; ',$realValue,'; '))) or not(str:concat(exsl:node-set(''))='' or count(exsl:node-set('')) = count(sets:distinct(exsl:node-set($given_profile[1]) | exsl:node-set('')))) or not(normalize-space(string(''))='' or ((normalize-space(substring(string(''),1,4))='not:') and ((not(contains(concat('; ',normalize-space(substring-after(string(''),':')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:CATALOG),'; ')))) and not(contains(concat('; ',normalize-space(substring-after(string(''),':')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:SPECIFICATION),'; '))))) or ((normalize-space(substring(string(''),1,4))!='not:') and ((contains(concat('; ',normalize-space(string('')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:CATALOG),'; '))) or (contains(concat('; ',normalize-space(string('')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:SPECIFICATION),'; '))))))"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Value '<axsl:text/><axsl:value-of select="."/><axsl:text/>' is not allowed in attribute '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in element '<axsl:text/><axsl:value-of select="name(..)"/><axsl:text/>'. <axsl:text/><axsl:value-of select="substring($section_string,1,number($section_context)*string-length($section_string))"/><axsl:text/> Valid values are: <axsl:text/><axsl:value-of select="string(string('1.5.0; 1.6.0; 1.7.0'))"/><axsl:text/>
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M10"/></axsl:template><axsl:template match="text()" priority="-1" mode="M10"/><axsl:template match="@*|node()" priority="-2" mode="M10"><axsl:apply-templates select="@*|*" mode="M10"/></axsl:template>

<!--PATTERN mets_SPECIFICATION_values-->


	<!--RULE -->
<axsl:template match="mets:mets[@fi:SPECIFICATION and not(contains(@fi:SPECIFICATION, ';')) and (true())]" priority="1001" mode="M11"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mets:mets[@fi:SPECIFICATION and not(contains(@fi:SPECIFICATION, ';')) and (true())]"/><axsl:variable name="given_profile" select="str:split(normalize-space(/mets:mets/@PROFILE), '?')"/><axsl:variable name="section_context" select="ancestor-or-self::*[self::mets:dmdSec or self::mets:techMD or self::mets:rightsMD or self::mets:sourceMD or self::mets:digiprovMD]"/><axsl:variable name="section_string" select="concat('(ID of the metadata section ', name($section_context), ' is ', $section_context/@ID, ')')"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="(contains(concat('; ',string('1.5.0; 1.6.0; 1.6.1; 1.7.0'),'; '), concat('; ',normalize-space(@fi:SPECIFICATION),'; ')))     or not(str:concat(exsl:node-set(''))='' or count(exsl:node-set('')) = count(sets:distinct(exsl:node-set($given_profile[1]) | exsl:node-set('')))) or not(normalize-space(string(''))=''    or ((normalize-space(substring(string(''),1,4))='not:') and ((not(contains(concat('; ',normalize-space(substring-after(string(''),':')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:CATALOG),'; ')))) and not(contains(concat('; ',normalize-space(substring-after(string(''),':')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:SPECIFICATION),'; ')))))    or ((normalize-space(substring(string(''),1,4))!='not:') and ((contains(concat('; ',normalize-space(string('')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:CATALOG),'; '))) or (contains(concat('; ',normalize-space(string('')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:SPECIFICATION),'; '))))))"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="(contains(concat('; ',string('1.5.0; 1.6.0; 1.6.1; 1.7.0'),'; '), concat('; ',normalize-space(@fi:SPECIFICATION),'; '))) or not(str:concat(exsl:node-set(''))='' or count(exsl:node-set('')) = count(sets:distinct(exsl:node-set($given_profile[1]) | exsl:node-set('')))) or not(normalize-space(string(''))='' or ((normalize-space(substring(string(''),1,4))='not:') and ((not(contains(concat('; ',normalize-space(substring-after(string(''),':')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:CATALOG),'; ')))) and not(contains(concat('; ',normalize-space(substring-after(string(''),':')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:SPECIFICATION),'; '))))) or ((normalize-space(substring(string(''),1,4))!='not:') and ((contains(concat('; ',normalize-space(string('')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:CATALOG),'; '))) or (contains(concat('; ',normalize-space(string('')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:SPECIFICATION),'; '))))))"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Value '<axsl:text/><axsl:value-of select="@fi:SPECIFICATION"/><axsl:text/>' is not allowed in attribute '<axsl:text/><axsl:value-of select="name(@fi:SPECIFICATION)"/><axsl:text/>' in element '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>'. <axsl:text/><axsl:value-of select="substring($section_string,1,number($section_context)*string-length($section_string))"/><axsl:text/> Valid values are: <axsl:text/><axsl:value-of select="string(string('1.5.0; 1.6.0; 1.6.1; 1.7.0'))"/><axsl:text/>
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M11"/></axsl:template>

	<!--RULE -->
<axsl:template match="mets:mets/@fi:SPECIFICATION[contains(., ';') and (true())]" priority="1000" mode="M11"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mets:mets/@fi:SPECIFICATION[contains(., ';') and (true())]"/><axsl:variable name="given_profile" select="str:split(normalize-space(/mets:mets/@PROFILE), '?')"/><axsl:variable name="section_context" select="ancestor-or-self::*[self::mets:dmdSec or self::mets:techMD or self::mets:rightsMD or self::mets:sourceMD or self::mets:digiprovMD]"/><axsl:variable name="section_string" select="concat('(ID of the metadata section ', name($section_context), ' is ', $section_context/@ID, ')')"/><axsl:variable name="params" select="str:split(.,';')"/><axsl:variable name="realValue" select="concat(normalize-space($params[1]), ';', normalize-space($params[2]))"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="(contains(concat('; ',string('1.5.0; 1.6.0; 1.6.1; 1.7.0'),'; '), concat('; ',$realValue,'; ')))     or not(str:concat(exsl:node-set(''))='' or count(exsl:node-set('')) = count(sets:distinct(exsl:node-set($given_profile[1]) | exsl:node-set('')))) or not(normalize-space(string(''))=''    or ((normalize-space(substring(string(''),1,4))='not:') and ((not(contains(concat('; ',normalize-space(substring-after(string(''),':')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:CATALOG),'; ')))) and not(contains(concat('; ',normalize-space(substring-after(string(''),':')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:SPECIFICATION),'; ')))))    or ((normalize-space(substring(string(''),1,4))!='not:') and ((contains(concat('; ',normalize-space(string('')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:CATALOG),'; '))) or (contains(concat('; ',normalize-space(string('')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:SPECIFICATION),'; '))))))"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:saxon="http://icl.com/saxon" test="(contains(concat('; ',string('1.5.0; 1.6.0; 1.6.1; 1.7.0'),'; '), concat('; ',$realValue,'; '))) or not(str:concat(exsl:node-set(''))='' or count(exsl:node-set('')) = count(sets:distinct(exsl:node-set($given_profile[1]) | exsl:node-set('')))) or not(normalize-space(string(''))='' or ((normalize-space(substring(string(''),1,4))='not:') and ((not(contains(concat('; ',normalize-space(substring-after(string(''),':')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:CATALOG),'; ')))) and not(contains(concat('; ',normalize-space(substring-after(string(''),':')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:SPECIFICATION),'; '))))) or ((normalize-space(substring(string(''),1,4))!='not:') and ((contains(concat('; ',normalize-space(string('')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:CATALOG),'; '))) or (contains(concat('; ',normalize-space(string('')),'; '), concat('; ',normalize-space(ancestor-or-self::mets:mets/@fi:SPECIFICATION),'; '))))))"><axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute><svrl:line-number><axsl:value-of select="saxon:line-number()"/></svrl:line-number><svrl:text>
				Value '<axsl:text/><axsl:value-of select="."/><axsl:text/>' is not allowed in attribute '<axsl:text/><axsl:value-of select="name(.)"/><axsl:text/>' in element '<axsl:text/><axsl:value-of select="name(..)"/><axsl:text/>'. <axsl:text/><axsl:value-of select="substring($section_string,1,number($section_context)*string-length($section_string))"/><axsl:text/> Valid values are: <axsl:text/><axsl:value-of select="string(string('1.5.0; 1.6.0; 1.6.1; 1.7.0'))"/><axsl:text/>
			</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*" mode="M11"/></axsl:template><axsl:template match="text()" priority="-1" mode="M11"/><axsl:template match="@*|node()" priority="-2" mode="M11"><axsl:apply-templates select="@*|*" mode="M11"/></axsl:template></axsl:stylesheet>