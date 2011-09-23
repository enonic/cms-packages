<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="xs portal" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>
  <xsl:include href="/libraries/common.xsl"/>
  <xsl:param name="categorykey"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="/verticaldata/contents/content">
        <div id="faq">
          <xsl:apply-templates select="/verticaldata/contents/content"/>    
        </div>
      </xsl:when>
      <xsl:otherwise>
        <h2>No items published.</h2>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="content">
    <div class="faqs">
      <xsl:apply-templates select="contentdata"/>
      <div class="spacer"><xsl:comment> </xsl:comment></div>
    </div>
  </xsl:template>

  <xsl:template match="contentdata">
    <h2><a href="javascript:;" onclick="expand('faq-{../@key}'); return(false);"><xsl:value-of select="question"/></a></h2>
    <div class="editor" id="faq-{../@key}" style="display:none;">
      <p>
        <xsl:apply-templates select="answer"/>
      </p>

      <xsl:if test="files/file">
        <div class="related-frame">
          <h4>Related files</h4>
          <div class="related-inner">
            <ul class="related">
              <xsl:apply-templates select="files/file"/>
            </ul>
          </div>
        </div>
      </xsl:if>
    </div>
  </xsl:template>

  <xsl:template match="file">
    <xsl:variable name="currentFile" select="/verticaldata/contents/relatedcontents/content[@key = current()/@key]"/>
    <li>
      <xsl:choose>
        <xsl:when test="position() mod 2 = 0 and position() = last()">
          <xsl:attribute name="class">dark last</xsl:attribute>
        </xsl:when>
        <xsl:when test="position() mod 2 = 0 and position() != last()">
          <xsl:attribute name="class">dark</xsl:attribute>
        </xsl:when>
        <xsl:when test="position() = last()">
          <xsl:attribute name="class">last</xsl:attribute>
        </xsl:when>
      </xsl:choose>

      <xsl:call-template name="getIconImage">
        <xsl:with-param name="filename" select="$currentFile/title"/>
      </xsl:call-template>

      <a href="{portal:createBinaryUrl($currentFile/contentdata/binarydata/@key, ('download','true'))}">
        <xsl:choose>
          <xsl:when test="description != ''">
            <xsl:call-template name="cropText">
              <xsl:with-param name="sourceText" select="description"/>
              <xsl:with-param name="numCharacters" select="200"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$currentFile/title"/>
          </xsl:otherwise>
        </xsl:choose>
      </a><xsl:text> </xsl:text>(<xsl:call-template name="convertBytes"><xsl:with-param name="bytes" select="$currentFile/binaries/binary[1]/@filesize"/></xsl:call-template>)
    </li>
  </xsl:template>
</xsl:stylesheet>