<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="xs portal" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>
  <xsl:include href="/libraries/common.xsl"/>
  <xsl:include href="/packages/site/border.xsl"/>
  <xsl:include href="/libraries/formatDate.xsl"/>
  <xsl:variable name="language" select="/verticaldata/context/@languagecode"/>
  <xsl:variable as="xs:integer" name="totalCount" select="/verticaldata/contents/@totalcount"/>
  <xsl:param name="border" select="'false'"/>
  <xsl:param name="header-text" select="''"/>
  <xsl:template match="/">
    
    <xsl:if test="$border = 'true'">
      <xsl:call-template name="border-start">
        <xsl:with-param name="header-text" select="$header-text"/>
      </xsl:call-template>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="/verticaldata/contents/@totalcount = 0">
        <xsl:text>No items published.</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <div id="articlelist">
          <xsl:apply-templates select="/verticaldata/contents/content"/>
        </div>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="$border = 'true'">
      <xsl:call-template name="border-end"/>
    </xsl:if>

  </xsl:template>
  <xsl:template match="content">
    <div class="item poll">
      <xsl:if test="position() = 1">
        <xsl:attribute name="class">item poll first</xsl:attribute>
      </xsl:if>
      <h2>
        <xsl:value-of select="contentdata/title"/>
      </h2>
        <span class="byline">
          <xsl:call-template name="formatDate">
            <xsl:with-param name="date" select="@publishfrom"/>
            <xsl:with-param name="format" select="'short'"/>
          </xsl:call-template>
        </span>
        <p>
          <xsl:value-of disable-output-escaping="yes" select="contentdata/description"/>
        </p>
        <ul class="result">
          <xsl:for-each select="contentdata/alternatives/alternative">
            <xsl:variable name="percent" select="round(@count div (sum(../alternative/@count))*100)"/>
            <xsl:variable name="percentText" select="concat($percent,'%')"/>
            <li>
              <xsl:value-of select="."/> -
              <xsl:value-of select="$percentText"/>
              <div class="pollGraph">
                <xsl:attribute name="style">
                  <xsl:text>width:</xsl:text>
                  <xsl:value-of select="$percent"/>
                  <xsl:text>%;</xsl:text>
                </xsl:attribute>
                <xsl:comment/>
              </div>
            </li>
          </xsl:for-each>
        </ul>
    </div>
  </xsl:template>
</xsl:stylesheet>