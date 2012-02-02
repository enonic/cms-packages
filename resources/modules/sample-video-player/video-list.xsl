<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
    xmlns="http://www.w3.org/1999/xhtml" version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fw="http://www.enonic.com/cms/xslt/framework"
    xmlns:portal="http://www.enonic.com/cms/xslt/portal"
    xmlns:util="http://www.enonic.com/cms/xslt/utilities"> 
    
    <xsl:import href="/modules/library-utilities/fw-variables.xsl"/>
    <xsl:import href="/modules/library-utilities/pagination.xsl"/>    
    <xsl:import href="/modules/library-utilities/image.xsl"/>
    <xsl:import href="/modules/library-utilities/time.xsl"/>  
    <xsl:import href="/modules/library-utilities/text.xsl"/>

    <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>

    <xsl:variable name="url-parameters" select="/result/context/querystring/parameter[not(@name = 'index' or @name = 'id' or starts-with(@name, '_config-'))]"/>
    <xsl:variable name="index" select="xs:integer(/result/contents/@index)"/>
    <xsl:variable name="content-count" select="xs:integer(/result/contents/@resultcount)"/>
    <xsl:variable name="total-count" select="xs:integer(/result/contents/@totalcount)"/>
    <xsl:variable name="contents-per-page" select="xs:integer(/result/contents/@count)"/>

    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="/result/contents/content">
                <xsl:call-template name="util:pagination.header">
                    <xsl:with-param name="index" select="$index"/>
                    <xsl:with-param name="content-count" select="$content-count"/>
                    <xsl:with-param name="total-count" select="$total-count"/>
                    <xsl:with-param name="contents-per-page" select="$contents-per-page"/>
                </xsl:call-template>
                <xsl:call-template name="util:pagination.menu">
                    <xsl:with-param name="parameters" tunnel="yes" select="$url-parameters"/>
                    <xsl:with-param name="index" tunnel="yes" select="$index"/>
                    <xsl:with-param name="content-count" select="$content-count"/>
                    <xsl:with-param name="total-count" tunnel="yes" select="$total-count"/>
                    <xsl:with-param name="contents-per-page" tunnel="yes" select="$contents-per-page"/>
                </xsl:call-template>
                <div class="video list clear clearfix append-bottom">
                    <xsl:apply-templates select="/result/contents/content"/>
                </div>
                <xsl:call-template name="util:pagination.menu">
                    <xsl:with-param name="parameters" tunnel="yes" select="$url-parameters"/>
                    <xsl:with-param name="index" tunnel="yes" select="$index"/>
                    <xsl:with-param name="content-count" select="$content-count"/>
                    <xsl:with-param name="total-count" tunnel="yes" select="$total-count"/>
                    <xsl:with-param name="contents-per-page" tunnel="yes" select="$contents-per-page"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <p class="clear">
                    <xsl:value-of select="portal:localize('No-videos')"/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="content">
        <div class="item">
            <xsl:if test="position() = 1">
                <xsl:attribute name="class">item first</xsl:attribute>
            </xsl:if>
            <xsl:if test="position() = last()">
                <xsl:attribute name="class">item last</xsl:attribute>
            </xsl:if>
            <xsl:if test="$fw:device-class != 'mobile'">
                <xsl:call-template name="image"/>
            </xsl:if>
            <h2>
                <a href="{portal:createContentUrl(@key,())}">
                    <xsl:value-of select="title"/>
                </a>
            </h2>
            <xsl:if test="$fw:device-class = 'mobile'">
                <xsl:call-template name="image"/>
            </xsl:if>
            <p>
                <span class="byline">
                    <xsl:value-of select="util:time.format-date(@publishfrom, /result/context/@languagecode, 'short', true())"/>
                </span>
                <xsl:if test="contentdata/description != ''">
                    <xsl:value-of select="util:text.crop(contentdata/description, xs:integer(floor($fw:region-width * 0.5)))"/>
                </xsl:if>
            </p>
        </div>
    </xsl:template>

    <xsl:template name="image">
        <xsl:variable name="image-size" select="floor($fw:region-width * 0.25)"/>
        <a href="{portal:createContentUrl(@key,())}" title="{title}">
            <span class="play-icon" style="width: {$image-size}px; height: {$image-size}px;">
                <xsl:if test="not(/result/contents/relatedcontents/content[@key = current()/contentdata/thumbnail/@key])">
                    <xsl:attribute name="class">play-icon dummy</xsl:attribute>
                </xsl:if>
            </span>
            <xsl:if test="/result/contents/relatedcontents/content[@key = current()/contentdata/thumbnail/@key]">
                <xsl:call-template name="util:image.display">
                    <xsl:with-param name="filter" select="concat('scalesquare(', $image-size, ');', $fw:config-filter)"/>
                    <xsl:with-param name="image" select="/result/contents/relatedcontents/content[@key = current()/contentdata/thumbnail/@key]"/>
                </xsl:call-template>
            </xsl:if>
        </a>
    </xsl:template>

</xsl:stylesheet>
