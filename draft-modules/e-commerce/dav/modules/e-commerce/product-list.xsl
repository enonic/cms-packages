<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:util="enonic:utilities" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:import href="/libraries/utilities/standard-variables.xsl"/>
  <xsl:include href="/libraries/utilities/utilities.xsl"/>
  <xsl:include href="/libraries/utilities/navigation-menu.xsl"/>

  <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>

  <xsl:variable name="url-parameters" select="/result/context/querystring/parameter[not(@name = 'index' or @name = 'id' or starts-with(@name, '_config-'))]"/>
  <xsl:variable name="index" select="xs:integer(/result/contents/@index)"/>
  <xsl:variable name="content-count" select="xs:integer(/result/contents/@resultcount)"/>
  <xsl:variable name="total-count" select="xs:integer(/result/contents/@totalcount)"/>
  <xsl:variable name="contents-per-page" select="xs:integer(/result/contents/@count)"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="/result/contents/content">
        <xsl:call-template name="navigation-menu.navigation-header">
          <xsl:with-param name="index" select="$index"/>
          <xsl:with-param name="content-count" select="$content-count"/>
          <xsl:with-param name="total-count" select="$total-count"/>
          <xsl:with-param name="contents-per-page" select="$contents-per-page"/>
        </xsl:call-template>
        <xsl:call-template name="navigation-menu.navigation-menu">
          <xsl:with-param name="parameters" tunnel="yes" select="$url-parameters"/>
          <xsl:with-param name="index" tunnel="yes" select="$index"/>
          <xsl:with-param name="content-count" select="$content-count"/>
          <xsl:with-param name="total-count" tunnel="yes" select="$total-count"/>
          <xsl:with-param name="contents-per-page" tunnel="yes" select="$contents-per-page"/>
        </xsl:call-template>
        <div class="list clear clearfix append-bottom product-list">
          <xsl:apply-templates select="/result/contents/content"/>
        </div>
        <xsl:call-template name="navigation-menu.navigation-menu">
          <xsl:with-param name="parameters" tunnel="yes" select="$url-parameters"/>
          <xsl:with-param name="index" tunnel="yes" select="$index"/>
          <xsl:with-param name="content-count" select="$content-count"/>
          <xsl:with-param name="total-count" tunnel="yes" select="$total-count"/>
          <xsl:with-param name="contents-per-page" tunnel="yes" select="$contents-per-page"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <p class="clear">
          <xsl:value-of select="portal:localize('No-products')"/>
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
      <xsl:if test="$device-class != 'mobile'">
        <xsl:call-template name="image">
          <xsl:with-param name="size" select="'list'"/>
        </xsl:call-template>
      </xsl:if>
      <h2>
        <a href="{portal:createContentUrl(@key,())}">
          <xsl:value-of select="contentdata/name"/>
        </a>
      </h2>
      <xsl:if test="$device-class = 'mobile'">
        <xsl:call-template name="image">
          <xsl:with-param name="size" select="'wide'"/>
        </xsl:call-template>
      </xsl:if>
      <p>
        <xsl:value-of select="util:crop-text(contentdata/teaser, xs:integer(floor($region-width * 0.5)))"/>
      </p>
      <p class="price">
        <xsl:variable name="min-price" as="xs:double" select="min(contentdata/variation/price)"/>
        <xsl:variable name="max-price" as="xs:double" select="max(contentdata/variation/price)"/>
        <xsl:if test="$min-price != $max-price">
          <xsl:value-of select="concat(portal:localize('From'), ' ')"/>
        </xsl:if>
        <xsl:value-of select="util:format-price($min-price, $language)"/>
      </p>
      <form action="#">
        <fieldset>
          <input type="text" name="qty" value="1" class="text"/>
          <input type="submit" class="button" value="{portal:localize('Legg-i-handlekurv')}"/>
        </fieldset>
      </form>
    </div>
  </xsl:template>

  <xsl:template name="image">
    <xsl:param name="size"/>
    <xsl:if test="/result/contents/relatedcontents/content[@key = current()/contentdata/image/@key]">
      <a href="{portal:createContentUrl(@key,())}" title="{title}">
        <xsl:call-template name="utilities.display-image">
          <xsl:with-param name="region-width" select="$region-width"/>
          <xsl:with-param name="filter" select="$config-filter"/>
          <xsl:with-param name="imagesize" select="$config-imagesize"/>
          <xsl:with-param name="image" select="/result/contents/relatedcontents/content[@key = current()/contentdata/image/@key]"/>
          <xsl:with-param name="size" select="$size"/>
        </xsl:call-template>
      </a>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
