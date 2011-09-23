<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0"
                xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:saxon="http://icl.com/saxon"
                xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xml" omit-xml-declaration="yes"/>
  <xsl:variable name="forumConfiguration" select="document('forumConfiguration.xml')"/>
  <xsl:include href="/libraries/common.xsl"/>
  <xsl:include href="/libraries/navigationMenu.xsl"/>
  <xsl:param name="showNavigationMenu" select="'true'"/>
  <xsl:param name="pagesInNavigation" select="10"/>
  <xsl:param name="contentsPerPage" select="10"/>
  <xsl:param name="prefaceLength" select="200"/>
  <xsl:variable name="threadPage" select="$forumConfiguration/properties/property[@key = 'threadPage']/@value"/>
  <xsl:variable name="searchinput" select="/verticaldata/context/querystring/parameter[@name = 'query']"/>
  <xsl:variable name="language" select="/verticaldata/context/@language"/>
  <xsl:variable name="searchcount">
    <xsl:choose>
      <xsl:when test="string-length(/verticaldata/contents/@searchcount) > 0 and string-length($searchinput) > 3">
        <xsl:value-of select="/verticaldata/contents/@searchcount"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>0</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="totalCount" select="/verticaldata/contents/@totalcount"/>
  <xsl:variable name="contentCount" select="count(/verticaldata/contents/content)"/>
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
    <div>
      <em>
        Your query: "<xsl:value-of select="$searchinput"/>".
      </em>
    </div>
    <xsl:if test="$searchcount > 0">
      <xsl:if test="$showNavigationMenu = 'true' and $totalCount > $contentsPerPage">
        <xsl:call-template name="navigationHeader"/>
      </xsl:if>
      <div>
        <ol class="forum_searchitem" start="{$index + 1}">
          <xsl:for-each select="/verticaldata/contents/content">
            <xsl:sort order="descending" select="@publishfrom"/>
            <xsl:variable name="topkey">
              <xsl:choose>
                <xsl:when test="string-length(contentdata/topkey/@key) > 0">
                  <xsl:value-of select="contentdata/topkey/@key"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="@key"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <li>
              <span class="title">
                <a href="{portal:createPageUrl($threadPage, ('current',@key,'thread',$topkey,'cat',categoryname/@key))}">
                  <xsl:value-of select="contentdata/title"/>
                </a>
              </span>
              <br/>
              <span class="author">
                <xsl:text>By</xsl:text>
                <xsl:value-of select="contentdata/author"/>
                <xsl:text>(</xsl:text>
                <xsl:call-template name="dateTimeFull">
                  <xsl:with-param name="date" select="@publishfrom"/>
                </xsl:call-template>
                <xsl:text>)</xsl:text>
              </span>
              <br/>
              <span class="body">
                <xsl:variable name="bodytext">
                  <xsl:choose>
                    <xsl:when test="contains(contentdata/body, '---')">
                      <xsl:value-of select="substring-before(contentdata/body, '---')"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="contentdata/body"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="cropText">
                  <xsl:with-param name="sourceText" select="$bodytext"/>
                  <xsl:with-param name="numCharacters" select="$prefaceLength"/>
                </xsl:call-template>
              </span>
            </li>
          </xsl:for-each>
        </ol>
      </div>
      <xsl:if test="$showNavigationMenu = 'true' and $totalCount > $contentsPerPage">
        <xsl:call-template name="navigationMenu"/>
      </xsl:if>
    </xsl:if>
    <p>
      <a href="javascript:history.back()">Back</a>
    </p>
  </xsl:template>
</xsl:stylesheet>