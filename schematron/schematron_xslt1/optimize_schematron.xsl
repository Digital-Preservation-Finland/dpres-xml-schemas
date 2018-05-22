<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" xmlns:sets="http://exslt.org/sets" xmlns:str="http://exslt.org/strings" xmlns:sch="http://purl.oclc.org/dsdl/schematron">

<xsl:strip-space elements="*"/>
<xsl:output method="xml" indent="yes"/>

    <xsl:template match="sch:pattern">
        <xsl:variable name="context_list" select="sets:distinct(sets:difference(sch:rule/@context, preceding::sch:pattern/sch:rule/@context))"/>

        <xsl:variable name="has_rules">
            <xsl:for-each select="$context_list">
                <xsl:variable name="current_context" select="."/>
                <xsl:if test="not(../preceding::sch:rule/@context=$current_context)">
                    <xsl:value-of select="string('true')"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>

        <xsl:if test="contains($has_rules,'true')">
            <xsl:copy>
                <xsl:for-each select="$context_list">
                    <xsl:variable name="current_context" select="."/>
                    <xsl:for-each select="sets:distinct(/sch:schema/sch:pattern[sch:rule/@context=$current_context]/@*)">
                        <xsl:variable name="current_attr" select="."/>
                        <xsl:copy-of select="(/sch:schema/sch:pattern[sch:rule/@context=$current_context]/@*[.=$current_attr])[1]"/>
                    </xsl:for-each>
                </xsl:for-each>
                <xsl:variable name="pattern_id">
                    <xsl:for-each select="$context_list">
                        <xsl:variable name="current_context" select="."/>
                        <xsl:value-of select="str:concat(sets:distinct(/sch:schema/sch:pattern[sch:rule/@context=$current_context]/@id))"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:attribute name="id"><xsl:value-of select="str:concat($pattern_id)"/></xsl:attribute>
                <xsl:for-each select="$context_list">
                    <xsl:variable name="current_context" select="."/> 
                    <xsl:for-each select="sets:distinct(/sch:schema/sch:pattern[sch:rule/@context=$current_context]/sch:let/@name)">
                        <xsl:variable name="current_name" select="."/>
                        <xsl:copy-of select="(/sch:schema/sch:pattern[sch:rule/@context=$current_context]/sch:let[@name=$current_name])[1]"/>
                    </xsl:for-each>
                    <xsl:apply-templates select=".."/>
                </xsl:for-each>
            </xsl:copy>
        </xsl:if>
    </xsl:template>

    <xsl:template match="sch:rule">
        <xsl:variable name="current_context" select="@context"/>
        <xsl:if test="not(preceding::sch:rule/@context=$current_context)">
            <xsl:copy>
                <xsl:apply-templates select="sets:distinct(/sch:schema/sch:pattern/sch:rule[@context=$current_context]/@*)"/>
                <xsl:for-each select="sets:distinct(/sch:schema/sch:pattern/sch:rule[@context=$current_context]/sch:let/@name)">
                    <xsl:variable name="current_name" select="."/>
                    <xsl:copy-of select="(/sch:schema/sch:pattern/sch:rule[@context=$current_context]/sch:let[@name=$current_name])[1]"/>
                </xsl:for-each>
                <xsl:copy-of select="/sch:schema/sch:pattern/sch:rule[@context=$current_context]/sch:report"/>
                <xsl:copy-of select="/sch:schema/sch:pattern/sch:rule[@context=$current_context]/sch:assert"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>

    <xsl:template match="sch:schema">
        <xsl:copy>
            <xsl:apply-templates select="@*|sch:title|sch:ns"/>
            <xsl:apply-templates select="sch:let"/>
            <xsl:apply-templates select="node()[not(sch:let|sch:ns|sch:title)]"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="sch:let|sch:ns|sch:title|@*">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="comment()">
        <xsl:if test="starts-with(normalize-space(), 'context-filter:') or starts-with(normalize-space(), 'pass-filter:')">
            <xsl:copy/>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>

