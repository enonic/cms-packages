<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fw="http://www.enonic.com/cms/xslt/framework"
    xmlns:util="http://www.enonic.com/cms/xslt/utilities">

    <xsl:import href="/libraries/utilities/fw-variables.xsl"/>
    <xsl:import href="/libraries/utilities/frame.xsl"/>
    <xsl:import href="/libraries/utilities/html.xsl"/>

    <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>

    <xsl:param name="include-frame" select="false()"/>
    <xsl:param name="frame-heading"/>
    

    
    <xsl:template match="/">
        
        <xsl:variable name="content">
            <xsl:call-template name="util:html.process">
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
