<?xml version="1.0"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <xsl:import href="/libraries/utilities/standard-variables.xsl"/>
    <xsl:include href="/libraries/utilities/frame.xsl"/>
    <xsl:include href="/libraries/utilities/xhtml.xsl"/>

    <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>

    <xsl:param name="include-frame" select="false()"/>
    <xsl:param name="frame-heading"/>
    

    
    <xsl:template match="/">
        
        <xsl:variable name="content">
            <xsl:call-template name="xhtml.process">
                <xsl:with-param name="document" select="/result/context/window/portlet/document"/>
                <xsl:with-param name="image" tunnel="yes" select="/result/contents/relatedcontents/content"/>
            </xsl:call-template>
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
    </xsl:template>

</xsl:stylesheet>
