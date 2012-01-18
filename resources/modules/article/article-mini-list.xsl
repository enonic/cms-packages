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
                <ul class="spot list">
                    <xsl:apply-templates select="/result/contents/content"/>
                </ul>
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
        <li class="spot">
            <a href="{portal:createContentUrl(@key,())}">
                <img src="{portal:createImageUrl(contentdata/image[1]/image/@key, ('scaleblock(155, 90)'), '', 'jpg', 40)}" />
            </a>
            <h5>
                <a href="{portal:createContentUrl(@key,())}">
                    <xsl:value-of select="title"/>
                </a>
            </h5>
        </li>
    </xsl:template>

</xsl:stylesheet>
