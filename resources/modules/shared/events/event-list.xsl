<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
    xmlns="http://www.w3.org/1999/xhtml" version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fw="http://www.enonic.com/cms/xslt/framework"
    xmlns:portal="http://www.enonic.com/cms/xslt/portal"
    xmlns:util="http://www.enonic.com/cms/xslt/utilities">    
    
    <xsl:import href="/libraries/utilities/fw-variables.xsl"/>
    <xsl:import href="/libraries/utilities/utilities.xsl"/>
    <xsl:import href="/libraries/utilities/pagination.xsl"/>
    <xsl:import href="/libraries/utilities/time.xsl"/>
    
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
                <div class="list clear clearfix append-bottom" id="event-list">
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
                    <xsl:value-of select="portal:localize('No-events')"/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="content">
        <xsl:variable name="start-date" select="contentdata/start-date"/>
        <xsl:variable name="start-time" select="contentdata/start-time"/>
        <xsl:variable name="end-date" select="contentdata/end-date"/>
        <xsl:variable name="end-time" select="contentdata/end-time"/>
        <div class="item">
            <xsl:if test="position() = 1">
                <xsl:attribute name="class">item first</xsl:attribute>
            </xsl:if>
            <xsl:if test="position() = last()">
                <xsl:attribute name="class">item last</xsl:attribute>
            </xsl:if>
            <a href="{portal:createContentUrl(@key)}" title="{title}" class="date">
                <span class="day">
                    <xsl:value-of select="day-from-date(xs:date($start-date))"/>
                </span>
                <span class="month">
                    <xsl:value-of select="format-date(xs:date($start-date), '[MN,*-3]', $fw:language, (), ())"/>
                </span>
            </a>
            <h2>
                <a href="{portal:createContentUrl(@key)}">
                    <xsl:value-of select="contentdata/heading"/>
                </a>
            </h2>
            <p>
                <strong>
                    <xsl:value-of select="concat(portal:localize('When'), ': ')"/>
                </strong>
                <xsl:variable name="date">
                    <xsl:value-of select="$start-date"/>
                    <xsl:if test="$start-time != ''">
                        <xsl:value-of select="concat(' ', $start-time)"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:value-of select="util:time.format-date($date, $fw:language, (), true())"/>
                <xsl:if test="$end-date &gt; $start-date or $end-time != ''">
                    <xsl:text> -</xsl:text>
                    <xsl:if test="$end-date &gt; $start-date">
                        <xsl:value-of select="concat(' ', util:time.format-date($end-date, $fw:language, (), ()))"/>
                    </xsl:if>
                    <xsl:if test="$end-time != ''">
                        <xsl:value-of select="concat(' ', util:time.format-time($end-time, $fw:language))"/>
                    </xsl:if>
                </xsl:if>
                <xsl:if test="contentdata/location != ''">
                    <strong>
                        <xsl:value-of select="concat(' ', portal:localize('Where'), ': ')"/>
                    </strong>
                    <xsl:value-of select="contentdata/location"/>
                </xsl:if>
            </p>
        </div>
    </xsl:template>
    
</xsl:stylesheet>
