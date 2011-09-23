<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0"
                xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:saxon="http://icl.com/saxon"
                xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xml" omit-xml-declaration="yes"/>
  <xsl:include href="/packages/site/border.xsl"/>

  <xsl:variable name="forum-configuration" select="document('forumConfiguration.xml')"/>
  <xsl:include href="/libraries/common.xsl"/>
  <xsl:param name="preface-length" select="200"/>
  <xsl:variable name="thread-page" select="$forum-configuration/properties/property[@key = 'threadPage']/@value"/>
  <xsl:param name="border" select="'false'"/>
  <xsl:param name="header-text" select="''"/>

  <xsl:template match="/">
    <xsl:if test="$border = 'true'">
      <xsl:call-template name="border-start">
        <xsl:with-param name="header-text" select="$header-text"/>
      </xsl:call-template>
    </xsl:if>

    <ul class="postinglist">
      <xsl:for-each select="/verticaldata/contents/content">
        <xsl:variable name="thread">
          <xsl:choose>
            <xsl:when test="contentdata/top != 'true'">
              <xsl:value-of select="contentdata/topkey/@key"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@key"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="key" select="@key"/>
        <li>
          <a>
            <xsl:attribute name="title">
              <xsl:call-template name="cropText">
                <xsl:with-param name="sourceText" select="contentdata/body"/>
                <xsl:with-param name="numCharacters" select="number($preface-length)"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="href">
              <xsl:value-of
                  select="portal:createPageUrl($thread-page, ('current',@key,'cat',categoryname/@key,'thread',$thread))"/>
            </xsl:attribute>
            <xsl:value-of select="contentdata/title"/>
          </a>
        </li>
      </xsl:for-each>
    </ul>

    <xsl:if test="$border = 'true'">
      <xsl:call-template name="border-end"/>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>