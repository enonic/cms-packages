<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:util="enonic:utilities" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:import href="/libraries/page-rs/global-variables.xsl"/>
  <xsl:import href="/libraries/utilities/standard-variables.xsl"/>
  <xsl:import href="/libraries/page-rs/layout.xsl"/>

  <xsl:include href="/libraries/utilities/utilities.xsl"/>
  <xsl:include href="/libraries/utilities/navigation-menu.xsl"/>

  <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>
  <xsl:variable name="framepadding" as="xs:integer" select="xs:integer(/result/context/querystring/parameter[@name = '_config-region-framepadding'] * 2)"/>
  <xsl:variable name="region-width" as="xs:integer" select="xs:integer(/result/context/querystring/parameter[@name = '_config-region-width'] - $framepadding)"/>
  <xsl:variable name="url-parameters" select="/result/context/querystring/parameter[not(@name = 'index' or @name = 'id' or starts-with(@name, '_config-'))]"/>
  <xsl:variable name="index" select="xs:integer(/result/contents/@index)"/>
  <xsl:variable name="content-count" select="xs:integer(/result/contents/@resultcount)"/>
  <xsl:variable name="total-count" select="xs:integer(/result/contents/@totalcount)"/>
  <xsl:variable name="contents-per-page" select="xs:integer(/result/contents/@count)"/>
  <xsl:variable name="rss-page" select="util:get-scoped-parameter('rss', concat('/', string-join(/result/context/resource/path/resource/name, '/')), $config-site/parameters/parameter)" as="element()?"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="/result/contents/content">
        <div class="article">
          <xsl:for-each select="/result/contents/content">
            <xsl:choose>
              <xsl:when test="position() = 1">
                <xsl:call-template name="top-article">
                  <xsl:with-param name="content" select="current()"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="article">
                  <xsl:with-param name="content" select="current()"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <p>
          <xsl:value-of select="portal:localize('No-articles')"/>
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="top-article">
    <xsl:param name="content"/>
    <div class="item first">

      <xsl:if test="$device-class != 'mobile'">
        <h3 class="toptitle">
          <xsl:value-of select="contentdata/heading"/>
        </h3>
        <xsl:call-template name="image">
          <xsl:with-param name="size" select="'wide'"/>
        </xsl:call-template>
      </xsl:if>

      <h2 class="top-story">
        <a href="{portal:createContentUrl(@key,())}">
          <xsl:value-of select="contentdata/teaser/heading"/>
        </a>
      </h2>

      <xsl:if test="$device-class = 'mobile'">
        <xsl:call-template name="image">
          <xsl:with-param name="size" select="'wide'"/>
        </xsl:call-template>
      </xsl:if>

      <p class="date">
        <xsl:value-of select="util:format-date(@publishfrom, /result/context/@languagecode, 'short', false())"/>
      </p>

      <p class="preface top-story">
        <xsl:value-of select="contentdata/teaser/preface"/>
      </p>

      <a href="{portal:createContentUrl(@key,())}" title="{title}" class="read-more">
        <xsl:value-of select="portal:localize('Read-more')"/>
      </a>
    </div>
  </xsl:template>

  <xsl:template name="article">
    <xsl:param name="content"/>
    <div class="item">
      <xsl:if test="$device-class != 'mobile'">
        <xsl:call-template name="image">
          <xsl:with-param name="size" select="'list'"/>
        </xsl:call-template>
      </xsl:if>

      <div class="item-content">
        <h3 class="toptitle">
          <xsl:value-of select="contentdata/heading"/>
        </h3>

        <h2>
          <a href="{portal:createContentUrl(@key,())}">
            <xsl:value-of select="contentdata/teaser/heading"/>
          </a>
        </h2>

        <p class="date">
          <xsl:value-of select="util:format-date(@publishfrom, /result/context/@languagecode, 'short', false())"/>
        </p>

        <p class="preface">
          <xsl:value-of select="contentdata/teaser/preface"/>
        </p>

        <a href="{portal:createContentUrl(@key,())}" title="{title}" class="read-more">
          <xsl:value-of select="portal:localize('Read-more')"/>
        </a>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="image">
    <xsl:param name="size"/>
    <xsl:if test="/result/contents/relatedcontents/content[@key = current()/contentdata/teaser/image/@key]">
      <div class="teaser-image {if ($size = 'list') then 'small' else ''}">
        <a href="{portal:createContentUrl(@key,())}" title="{title}">
          <xsl:call-template name="utilities.display-image">
            <xsl:with-param name="region-width" select="$region-width"/>
            <xsl:with-param name="filter" select="$config-filter"/>
            <xsl:with-param name="imagesize" select="$config-imagesize"/>
            <xsl:with-param name="image" select="/result/contents/relatedcontents/content[@key = current()/contentdata/teaser/image/@key]"/>
            <xsl:with-param name="size" select="$size"/>
          </xsl:call-template>
        </a>
      </div>
    </xsl:if>
  </xsl:template>



</xsl:stylesheet>
