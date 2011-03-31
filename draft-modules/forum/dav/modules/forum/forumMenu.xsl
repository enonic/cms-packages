<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0"
                xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:saxon="http://icl.com/saxon"
                xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xml" omit-xml-declaration="yes"/>
  <xsl:variable name="forumConfiguration" select="document('forumConfiguration.xml')"/>
  <xsl:variable name="catPage" select="$forumConfiguration/properties/property[@key = 'categoriesPage']/@value"/>
  <xsl:variable name="cat" select="/verticaldata/context/querystring/parameter[@key = 'cat']"/>
  <xsl:template match="/">
    <xsl:apply-templates select="/verticaldata/categories"/>
  </xsl:template>
  <xsl:template match="categories">
    <ul class="forumlist">
      <xsl:apply-templates mode="subcat" select="category">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>
    </ul>
  </xsl:template>
  <xsl:template match="category" mode="subcat">
    <xsl:variable name="attribute">
      <xsl:choose>
        <xsl:when test="position() = last() and $cat = @key">
          <xsl:text>last_active</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="$cat = @key">
            <xsl:text>active</xsl:text>
          </xsl:if>
          <xsl:if test="position() = last()">
            <xsl:text>last</xsl:text>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <li>
      <xsl:if test="position() = 1">
        <xsl:attribute name="class">first</xsl:attribute>
      </xsl:if>
      <xsl:if test="$cat = @key">
        <xsl:attribute name="class">
          <xsl:text>path</xsl:text>
          <xsl:if test="position() = 1">
            <xsl:attribute name="class">first</xsl:attribute>
          </xsl:if>
        </xsl:attribute>
      </xsl:if>
      <a href="{portal:createPageUrl($catPage, ('cat',@key))}" title="{@name}">
        <xsl:if test="$cat = @key">
          <xsl:attribute name="class">active</xsl:attribute>
        </xsl:if>
        <xsl:value-of select="@name"/>
      </a>
    </li>
  </xsl:template>
</xsl:stylesheet>