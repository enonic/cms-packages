<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:saxon="http://icl.com/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xml" omit-xml-declaration="yes"/>
  <xsl:variable name="forumConfiguration" select="document('forumConfiguration.xml')"/>
  <xsl:include href="/libraries/common.xsl"/>
  <xsl:include href="/libraries/navigationMenu.xsl"/>
  <xsl:param name="prefaceLength" select="150"/>
  <xsl:param name="showNavigationMenu" select="'true'"/>
  <xsl:param name="pagesInNavigation" select="10"/>
  <xsl:param name="contentsPerPage" select="10"/>

  <xsl:variable name="mainPage" select="$forumConfiguration/properties/property[@key = 'mainPage']/@value"/>
  <xsl:variable name="threadPage" select="$forumConfiguration/properties/property[@key = 'threadPage']/@value"/>
  <xsl:variable name="publishPage" select="$forumConfiguration/properties/property[@key = 'publishPage']/@value"/>
  <xsl:variable name="categoriesPage" select="$forumConfiguration/properties/property[@key = 'categoriesPage']/@value"/>

  <xsl:variable name="totalCount" select="/verticaldata/contents/@totalcount"/>
  <xsl:variable name="contentCount" select="count(/verticaldata/contents/content)"/>
  <xsl:variable name="language" select="/verticaldata/context/@language"/>
  <xsl:variable name="current">
    <xsl:choose>
      <xsl:when test="string-length(/verticaldata/context/querystring/parameter[@name = 'current']) > 0">
        <xsl:value-of select="/verticaldata/context/querystring/parameter[@name = 'current']"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/verticaldata/contents/content/@key"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="indexTemp" select="/verticaldata/context/querystring/parameter[@name='index']"/>
  <xsl:variable name="index">
    <xsl:choose>
      <xsl:when test="$indexTemp != '' and string(number($indexTemp)) != 'NaN'">
        <xsl:value-of select="number($indexTemp)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="0"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:template match="/">
    <h1>
      <xsl:value-of select="/verticaldata/categories/category/@name"/>
    </h1>
    <ul class="forumnav">
      <li class="forum_add">
        <a href="{portal:createPageUrl($publishPage, ())}/?cat={//querystring/parameter[@name='cat']}">
          New posting
        </a>
      </li>
      <li class="forum_all">
        <a href="{portal:createPageUrl($mainPage, ())}/">
          Show all categories
        </a>
      </li>
    </ul>
    <xsl:choose>
      <xsl:when test="/verticaldata/contents/content/*">
        <xsl:if test="$showNavigationMenu = 'true' and $totalCount > $contentsPerPage">
          <xsl:call-template name="navigationHeader"/>
        </xsl:if>
        <table class="forumcontent">
          <tr>
            <th style="width: 5%;">
              <xsl:comment>//</xsl:comment>
            </th>
            <th style="width: 65%;">
              Title
            </th>
            <th style="width: 30%;">
              Started by
            </th>
          </tr>
          <xsl:apply-templates select="/verticaldata/contents/content[contentdata/top = 'true']"/>
        </table>
        <xsl:if test="$showNavigationMenu = 'true' and $totalCount > $contentsPerPage">
          <xsl:call-template name="navigationMenu"/>
        </xsl:if>
        <p>
          <a href="javascript:history.back();">&lt;&lt; Back</a>
        </p>
      </xsl:when>
      <xsl:otherwise>
        No items found in this category.
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="/verticaldata/contents/content[contentdata/top = 'true']">
    <tr>
      <xsl:if test="position() mod 2 = 0">
        <xsl:attribute name="class">row_g</xsl:attribute>
      </xsl:if>
      <td style="text-align: center;">
        <img alt="" src="{portal:createResourceUrl('/_public/packages/site/images/icon_pages.png')}" style="width: 16px; height: 16px;"/>
      </td>
      <td>
        <a href="{portal:createPageUrl($threadPage, ('current',@key,'thread',@key,'cat',//querystring/parameter[@name='cat']))}">
          <xsl:attribute name="title">
            <xsl:call-template name="cropText">
              <xsl:with-param name="sourceText" select="contentdata/body"/>
              <xsl:with-param name="numCharacters" select="number($prefaceLength)"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:value-of select="title"/>
        </a>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="string-length(contentdata/email) > 0">
            <a href="mailto:{contentdata/email}">
              <xsl:value-of select="contentdata/author"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="contentdata/author"/>
          </xsl:otherwise>
        </xsl:choose>
        <br/>
         <xsl:call-template name="dateTimeFull">
            <xsl:with-param name="date" select="@publishfrom"/>
          </xsl:call-template>
      </td>
    </tr>
  </xsl:template>
</xsl:stylesheet>