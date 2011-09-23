<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:saxon="http://saxon.sf.net/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xml"/>
  <xsl:variable name="forumConfiguration" select="document('forumConfiguration.xml')"/>
  <xsl:include href="/libraries/navigationMenu.xsl"/>
  <xsl:include href="/libraries/common.xsl"/>
  <xsl:include href="/libraries/forumFilter.xsl"/>
  <xsl:include href="/libraries/syntaxHighlight.xsl"/>
  <xsl:param name="report" select="'true'"/>
  <xsl:param name="syntaxHighlight" select="'true'"/>
  <xsl:param name="showNavigationMenu" select="'true'"/>
  <xsl:param name="pagesInNavigation" select="10"/>
  <xsl:param name="contentsPerPage" select="10"/>
  <xsl:variable name="totalCount" select="/verticaldata/contents/@totalcount"/>
  <xsl:variable name="contentCount" select="count(/verticaldata/contents/content)"/>
  <xsl:variable name="language" select="/verticaldata/context/@language"/>
  <xsl:variable name="replyPage" select="$forumConfiguration/properties/property[@key = 'replyPage']/@value"/>
  <xsl:variable name="reportPage" select="$forumConfiguration/properties/property[@key = 'reportPage']/@value"/>
  <xsl:variable name="current">
    <xsl:choose>
      <xsl:when test="string-length(/verticaldata/context/querystring/parameter[@name = 'current']) > 0">
        <xsl:value-of select="/verticaldata/context/querystring/parameter[@name = 'current']"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/verticaldata/contents/content[1]/@key"/>
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
  <xsl:variable name="ucase">ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ1234567890</xsl:variable>
  <xsl:variable name="lcase">abcdefghijklmnopqrstuvwxyzæøå1234567890</xsl:variable>

  <xsl:variable name="contentNode" select="/verticaldata/contents/content[@key = $current]"/>
  <xsl:template match="/">
    <h1>
      <xsl:value-of select="/verticaldata/categories/category/@name"/>
    </h1>
    <ul class="forumnav">
      <li class="forum_add">
        <a href="{portal:createPageUrl($replyPage, ('key',$contentNode/@key,'cat',/verticaldata/context/querystring/parameter[@name = 'cat']))}">
          Post a reply
        </a>
      </li>
    </ul>
    <xsl:choose>
      <xsl:when test="/verticaldata/contents/@totalcount = 0">
        No items found in this category.
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$showNavigationMenu = 'true' and $totalCount > $contentsPerPage">
          <xsl:call-template name="navigationHeader"/>
        </xsl:if>

        <table class="forumcontent">
          <tr>
            <th style="width: 5%;">
              <xsl:comment>//</xsl:comment>
            </th>
            <th style="width: 95%;">
              Thread
            </th>
          </tr>
          <xsl:apply-templates select="/verticaldata/contents/content"/>
        </table>
        <xsl:if test="$showNavigationMenu = 'true' and $totalCount > $contentsPerPage">
          <xsl:call-template name="navigationMenu"/>
        </xsl:if>
        <xsl:if test="$syntaxHighlight = 'true'">
          <xsl:call-template name="syntaxHighlight"/>
        </xsl:if>
        <p>
          <a href="javascript:history.back();">&lt;&lt; Back</a>
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="/verticaldata/contents/content">
    <tr>
      <xsl:if test="position() mod 2 = 0">
        <xsl:attribute name="class">row_g</xsl:attribute>
      </xsl:if>
      <td class="svar" style="text-align: center;">
        <img alt="" src="{portal:createResourceUrl('/_public/packages/site/images/icon_post.png')}" style="width: 16px; height: 16px;"/>
      </td>
      <td class="svar">
        <div style="width: 700px;">
          <ul class="postnav">
            <li class="forum_answerquote">
              <a href="{portal:createPageUrl($replyPage, ('quote','yes','key',@key,'cat',/verticaldata/context/querystring/parameter[@name = 'cat']))}">
                Quote
              </a>
            </li>
            <xsl:if test="$report = 'true'">
              <li class="forum_report">
                <a href="#" onclick="return reportThread({$reportPage},{@key},{/verticaldata/context/querystring/parameter[@name = 'cat']});">
                  Report
                </a>
              </li>
            </xsl:if>
          </ul>
          <strong>
            <xsl:value-of select="title"/>
          </strong>
          <br/>
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
          <xsl:text>, </xsl:text>
          <xsl:call-template name="dateTimeFull">
            <xsl:with-param name="date" select="@publishfrom"/>
          </xsl:call-template>
          <div style="width: 100%; border-top: 1px #aaa dashed; height: 10px; margin-top: 5px;">
            <xsl:comment>//</xsl:comment>
          </div>
          <xsl:if test="string-length(contentdata/body) > 0">
            <xsl:call-template name="formatForumOutput">
              <xsl:with-param name="inputString" select="contentdata/body"/>
            </xsl:call-template>
          </xsl:if>
        </div>
      </td>
    </tr>
  </xsl:template>
</xsl:stylesheet>