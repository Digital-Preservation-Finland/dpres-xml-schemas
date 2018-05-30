<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">

<xsl:strip-space elements="*"/>
<xsl:output method="xml" indent="yes"/>

    <xsl:template match="svrl:active-pattern">
        <xsl:variable name="current_id" select="@id"/>
        <xsl:if test="not(preceding-sibling::svrl:active-pattern[1]/@id=$current_id)">
            <xsl:copy-of select="."/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="svrl:fired-rule">
        <xsl:variable name="current_context" select="@context"/>
        <xsl:if test="not(preceding-sibling::svrl:fired-rule[1]/@context=$current_context)">
            <xsl:copy-of select="."/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="svrl:schematron-output">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@*|*[not(self::svrl:schematron-output|self::svrl:active-pattern|self::svrl:fired-rule)]">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="comment()">
        <xsl:copy/>
    </xsl:template>
</xsl:stylesheet>

