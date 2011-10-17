<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:util="enonic:utilities" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:import href="/libraries/utilities/standard-variables.xsl"/>
    <xsl:include href="/libraries/utilities/utilities.xsl"/>
    <xsl:include href="/libraries/utilities/frame.xsl"/>

    <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>
    
    <xsl:param name="include-frame" select="false()"/>
    <xsl:param name="frame-heading"/>

    <xsl:template match="/">
        <xsl:if test="/result/contents/content">
            <xsl:variable name="content">
                <div class="list clear clearfix">
                    <xsl:apply-templates select="/result/contents/content"/>
                </div>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$include-frame">
                    <xsl:call-template name="frame.frame">
                        <xsl:with-param name="content" select="$content"/>
                        <xsl:with-param name="frame-heading" select="$frame-heading"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="$content"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template match="content">
        <div class="item">
            <xsl:if test="position() = 1">
                <xsl:attribute name="class">item first</xsl:attribute>
            </xsl:if>
            <p>
                <span class="byline">
                    <xsl:value-of select="util:format-date(@publishfrom, /result/context/@languagecode, 'short', true())"/>
                </span>
            </p>
            <h3>
                <a href="{portal:createContentUrl(@key,())}">
                    <xsl:value-of select="title"/>
                </a>
            </h3>
        </div>
    </xsl:template>

</xsl:stylesheet>
