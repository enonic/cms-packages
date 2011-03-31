<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="xs portal" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
                xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>
  <xsl:include href="/libraries/common.xsl"/>
  <xsl:include href="/libraries/formatDate.xsl"/>
  <xsl:param name="categorykey">
    <type>category</type>
  </xsl:param>
  <xsl:param name="imageMaxWidth" select="180"/>
  <xsl:variable name="language" select="/verticaldata/context/@languagecode"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="/verticaldata/contents/@totalcount = 0">
        <h2>No items published.</h2>
      </xsl:when>
      <xsl:otherwise>
        <div id="articlelist">
          <xsl:apply-templates select="/verticaldata/contents/content"/>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="content">
    <div class="item">
      <xsl:if test="position() = 1">
        <xsl:attribute name="class">item first</xsl:attribute>
      </xsl:if>
      <xsl:if test="/verticaldata/contents/relatedcontents/content[@key = current()/contentdata/teaser/image/@key]">
        <a href="{portal:createContentUrl(@key,())}" title="{title}">
          <xsl:call-template name="displayImage">
            <xsl:with-param name="key" select="contentdata/teaser/image/@key"/>
            <xsl:with-param name="imageMaxWidth" select="$imageMaxWidth"/>
          </xsl:call-template>
        </a>
      </xsl:if>
      <xsl:if test="/verticaldata/contents/relatedcontents/content[@key = current()/contentdata/teaser/image/@key]">
        <xsl:text disable-output-escaping="yes">&lt;div class="inner-articlelist" style="margin-left:</xsl:text><xsl:value-of
          select="180 + 15"/><xsl:text>px;"</xsl:text><xsl:text disable-output-escaping="yes">&gt;</xsl:text>
      </xsl:if>
      <h2>
        <a href="{portal:createContentUrl(@key,())}" title="{title}">
          <xsl:choose>
            <xsl:when test="contentdata/teaser/heading != ''">
              <xsl:value-of select="contentdata/teaser/heading"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="contentdata/heading"/>
            </xsl:otherwise>
          </xsl:choose>
        </a>
      </h2>
      <xsl:call-template name="comments"/>
      <xsl:variable name="preface">
        <xsl:choose>
          <xsl:when test="contentdata/teaser/preface != ''">
            <xsl:value-of disable-output-escaping="yes" select="contentdata/teaser/preface"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="contentdata/article/preface"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <p>
        <span class="byline">
          <xsl:call-template name="formatDate">
            <xsl:with-param name="date" select="@publishfrom"/>
            <xsl:with-param name="format" select="'short'"/>
          </xsl:call-template>
        </span>
        <xsl:call-template name="replaceSubstring">
          <xsl:with-param name="inputString" select="$preface"/>
        </xsl:call-template>
      </p>
      <p class="read-more">
        <a href="{portal:createContentUrl(@key,())}" title="{title}">
          <xsl:choose>
            <xsl:when test="contentdata/teaser/read_more != ''">
              <xsl:value-of select="concat('» ','Read more')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat('» ','Read more')"/>
            </xsl:otherwise>
          </xsl:choose>
        </a>
      </p>
      <xsl:if test="/verticaldata/contents/relatedcontents/content[@key = current()/contentdata/teaser/image/@key]">
        <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
      </xsl:if>
    </div>
  </xsl:template>

  <xsl:template name="comments">
    <xsl:variable name="comments"
                  select="/verticaldata/contents/relatedcontents/content[categoryname/@key = $categorykey]/contentdata/related/content[@key = current()/@key]"/>
    <xsl:variable name="noOfComments" select="count($comments)"/>
    <xsl:variable name="latestCommentName" select="$comments[position() = last()]/../../../owner/name"/>
    <xsl:variable name="latestCommentDate" select="$comments[position() = last()]/../../../@created"/>
    <div style="font-size:85%">
      <xsl:text>Comments: </xsl:text>
      <xsl:choose>
        <xsl:when test="$noOfComments != 0">
          <xsl:value-of select="$noOfComments"/>
          <xsl:text> | Last comment by </xsl:text>
          <xsl:value-of select="$latestCommentName"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>none</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>
</xsl:stylesheet>
