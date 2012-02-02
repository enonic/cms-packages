<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
  xmlns="http://www.w3.org/1999/xhtml" version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fw="http://www.enonic.com/cms/xslt/framework"
  xmlns:portal="http://www.enonic.com/cms/xslt/portal"
  xmlns:util="http://www.enonic.com/cms/xslt/utilities">

  <xsl:import href="/modules/library-utilities/fw-variables.xsl"/>
  <xsl:import href="/modules/library-utilities/image.xsl"/>
  <xsl:import href="/modules/library-utilities/pagination.xsl"/>
  <xsl:import href="/modules/library-utilities/text.xsl"/>
  <xsl:import href="/modules/library-utilities/time.xsl"/>

  <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>

  <xsl:variable name="url-parameters" select="/result/context/querystring/parameter[not(@name = 'index' or @name = 'id' or starts-with(@name, '_config-'))]"/>
  <xsl:variable name="index" select="xs:integer(/result/contents/@index)"/>
  <xsl:variable name="content-count" select="xs:integer(/result/contents/@resultcount)"/>
  <xsl:variable name="total-count" select="xs:integer(/result/contents/@totalcount)"/>
  <xsl:variable name="contents-per-page" select="xs:integer(/result/contents/@count)"/>
  
  <xsl:variable name="rss-page"/>
  
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="/result/contents/content">
        <xsl:call-template name="util:pagination.header">
          <xsl:with-param name="contents" select="/result/contents"/>
        </xsl:call-template>
        <xsl:call-template name="util:pagination.menu">
          <xsl:with-param name="contents" select="/result/contents"/>
        </xsl:call-template>
        <div class="list clear clearfix append-bottom">
          <xsl:apply-templates select="/result/contents/content"/>
          <xsl:if test="$rss-page">
            <a href="{portal:createUrl($rss-page, ('articleSectionId', portal:getPageKey()))}" class="rss">
              <img src="{portal:createResourceUrl(concat($fw:theme-public, '/images/icon-rss.png'))}" class="icon text" alt="RSS {portal:localize('icon')}"/>
              <xsl:value-of select="portal:localize('Articles-as-rss-feed')"/>
            </a>
          </xsl:if>
        </div>
        <xsl:call-template name="util:pagination.menu">
          <xsl:with-param name="contents" select="/result/contents"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <p class="clear">
          <xsl:value-of select="portal:localize('No-articles')"/>
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="content">
    <div class="item">
      <xsl:if test="position() = 1">
        <xsl:attribute name="class">item first</xsl:attribute>
      </xsl:if>
      <xsl:if test="position() = last() and not($rss-page)">
        <xsl:attribute name="class">item last</xsl:attribute>
      </xsl:if>
      <xsl:if test="$fw:device-class != 'mobile'">
        <xsl:call-template name="image">
          <xsl:with-param name="size" select="'list'"/>
        </xsl:call-template>
      </xsl:if>
      <h2>
        <a href="{portal:createContentUrl(@key,())}">
          <xsl:value-of select="contentdata/heading"/>
        </a>
      </h2>
      <xsl:if test="$fw:device-class = 'mobile'">
        <xsl:call-template name="image">
          <xsl:with-param name="size" select="'wide'"/>
        </xsl:call-template>
      </xsl:if>
      <p>
        <span class="byline">
          <xsl:value-of select="util:time.format-date(@publishfrom, /result/context/@languagecode, 'short', true())"/>
        </span>
        <xsl:value-of select="util:text.crop(contentdata/preface, xs:integer(floor($fw:region-width * 0.5)))"/>
      </p>
      <a href="{portal:createContentUrl(@key,())}" title="{title}">
        <xsl:value-of select="concat(portal:localize('Read-more'), ' »')"/>
      </a>
    </div>
  </xsl:template>

  <xsl:template name="image">
    <xsl:param name="size"/>
    <xsl:if test="/result/contents/relatedcontents/content[@key = current()/contentdata/image[1]/image/@key]">
      <a href="{portal:createContentUrl(@key,())}" title="{title}">
        <xsl:call-template name="util:image.display">
          <xsl:with-param name="image" select="/result/contents/relatedcontents/content[@key = current()/contentdata/image[1]/image/@key]"/>
          <xsl:with-param name="size" select="$size"/>
        </xsl:call-template>
      </a>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
