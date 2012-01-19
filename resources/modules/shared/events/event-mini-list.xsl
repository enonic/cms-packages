<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
    xmlns="http://www.w3.org/1999/xhtml" version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fw="http://www.enonic.com/cms/xslt/framework"
    xmlns:portal="http://www.enonic.com/cms/xslt/portal"
    xmlns:util="http://www.enonic.com/cms/xslt/utilities"> 
    
    <xsl:import href="/libraries/utilities/fw-variables.xsl"/>
    <xsl:import href="/libraries/utilities/frame.xsl"/>
    
    <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>
    
    <xsl:param name="include-frame" select="false()"/>
    <xsl:param name="frame-heading"/>
    
    <xsl:template match="/">
        <xsl:if test="/result/contents/content">
            <xsl:variable name="content">
                <div class="list mini clear clearfix">
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
        <xsl:variable name="start-date" select="contentdata/start-date"/>
        <div class="item">
            <xsl:if test="position() = 1">
                <xsl:attribute name="class">item first</xsl:attribute>
            </xsl:if>
            <a href="{portal:createContentUrl(@key)}" title="{title}" class="date">
                <span class="day">
                    <xsl:value-of select="day-from-date(xs:date($start-date))"/>
                </span>
                <span class="month">
                    <xsl:value-of select="format-date(xs:date($start-date), '[MN,*-3]', $fw:language, (), ())"/>
                </span>
            </a>
            <h3>
                <a href="{portal:createContentUrl(@key)}">
                    <xsl:value-of select="title"/>
                </a>
            </h3>
        </div>
    </xsl:template>
    
</xsl:stylesheet>
