<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output encoding="UTF-8" indent="yes" method="xml" omit-xml-declaration="no"/>

  <xsl:param name="channel-managing-editor" select="/result/context/querystring/parameter[@name = 'rss-channel-managing-editor']"/>
  <xsl:param name="channel-webmaster" select="/result/context/querystring/parameter[@name = 'rss-channel-webmaster']"/>
  <xsl:param name="channel-image-path" select="/result/context/querystring/parameter[@name = 'rss-channel-image-path']"/>

  <xsl:variable name="site-name" select="/result/context/site/name"/>
  <xsl:variable name="menuitem-name">
    <xsl:choose>
      <xsl:when test="/result/menuitems/menuitem/alternative-name != ''">
        <xsl:value-of select="/result/menuitems/menuitem/alternative-name"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/result/menuitems/menuitem/name"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="channel-title">
    <xsl:value-of select="$site-name"/>
    <xsl:if test="$menuitem-name != ''">
      <xsl:value-of select="concat(' - ', $menuitem-name)"/>
    </xsl:if>
  </xsl:variable>
  <xsl:variable name="channel-link" select="/result/context/querystring/@url"/>
  <xsl:variable name="channel-description">
    <xsl:choose>
      <xsl:when test="/result/context/querystring/parameter[@name = 'rss-channel-description'] != ''">
        <xsl:value-of select="/result/context/querystring/parameter[@name = 'rss-channel-description']"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/result/context/resource/description"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="timezone-duration" select="timezone-from-dateTime(current-dateTime())"/>
  <xsl:variable name="timezone" select="replace(xs:string(format-dateTime(adjust-dateTime-to-timezone(current-dateTime() - $timezone-duration), '[ZN,*-3]')), ':', '')"/>
  <xsl:variable name="date-format-string" select="'[FNn,*-3], [D01] [MNn,*-3] [Y0001] [H01]:[m01]:[s01]'"/>

  <xsl:template match="/">
    <xsl:element name="rss">
      <xsl:attribute name="version">2.0</xsl:attribute>
      <xsl:element name="channel">
        <xsl:element name="title">
          <xsl:value-of select="$channel-title"/>
        </xsl:element>
        <xsl:element name="link">
          <xsl:value-of select="$channel-link"/>
        </xsl:element>
        <xsl:element name="atom:link">
          <xsl:attribute name="href">
            <xsl:value-of select="$channel-link"/>
          </xsl:attribute>
          <xsl:attribute name="rel">self</xsl:attribute>
          <xsl:attribute name="type">application/rss+xml</xsl:attribute>
        </xsl:element>
        <xsl:element name="description">
          <xsl:value-of select="$channel-description"/>
        </xsl:element>
        <xsl:element name="language">
          <xsl:value-of select="/result/context/@languagecode"/>
        </xsl:element>
        <xsl:element name="copyright">
          <xsl:value-of select="concat(portal:localize('Copyright'), ' ', year-from-date(current-date()), ', ', $site-name)"/>
        </xsl:element>
        <xsl:if test="$channel-managing-editor != ''">
          <xsl:element name="managingEditor">
            <xsl:value-of select="$channel-managing-editor"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="$channel-webmaster != ''">
          <xsl:element name="webMaster">
            <xsl:value-of select="$channel-webmaster"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="/result/contents/content">
          <xsl:element name="lastBuildDate">
            <xsl:value-of select="concat(format-dateTime(dateTime(xs:date(tokenize(/result/contents/content[1]/@timestamp, '\s+')[1]), xs:time(concat(tokenize(/result/contents/content[1]/@timestamp, '\s+')[2], ':00Z'))), $date-format-string), ' ', $timezone)"/>
          </xsl:element>
        </xsl:if>
        <xsl:element name="generator">
          <xsl:text>Enonic CMS</xsl:text>
        </xsl:element>
        <xsl:element name="docs">
          <xsl:text>http://www.rssboard.org/rss-specification</xsl:text>
        </xsl:element>
        <xsl:if test="$channel-image-path != ''">
          <xsl:element name="image">
            <xsl:element name="url">
              <xsl:value-of select="portal:createResourceUrl($channel-image-path)"/>
            </xsl:element>
            <xsl:element name="title">
              <xsl:value-of select="$channel-title"/>
            </xsl:element>
            <xsl:element name="link">
              <xsl:value-of select="$channel-link"/>
            </xsl:element>
            <xsl:element name="description">
              <xsl:value-of select="$channel-description"/>
            </xsl:element>
          </xsl:element>
        </xsl:if>
        <xsl:for-each select="/result/contents/content">
          <xsl:sort select="@publishfrom" order="descending"/>
          <xsl:element name="item">
            <xsl:element name="title">
              <xsl:value-of select="title"/>
            </xsl:element>
            <xsl:element name="link">
              <xsl:value-of select="portal:createContentUrl(@key, ())"/>
            </xsl:element>
            <xsl:element name="description">
              <xsl:value-of select="contentdata/preface"/>
            </xsl:element>
            <xsl:element name="guid">
              <xsl:attribute name="isPermaLink">
                <xsl:text>true</xsl:text>
              </xsl:attribute>
              <xsl:value-of select="portal:createContentUrl(@key, ())"/>
            </xsl:element>
            <xsl:element name="pubDate">
              <xsl:value-of select="concat(format-dateTime(dateTime(xs:date(tokenize(@publishfrom, '\s+')[1]), xs:time(concat(tokenize(@publishfrom, '\s+')[2], ':00Z'))), $date-format-string), ' ', $timezone)"/>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
