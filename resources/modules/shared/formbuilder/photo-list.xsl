<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
  xmlns="http://www.w3.org/1999/xhtml" version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fw="http://www.enonic.com/cms/xslt/framework"
  xmlns:portal="http://www.enonic.com/cms/xslt/portal"
  xmlns:util="http://www.enonic.com/cms/xslt/utilities"> 
  
  <xsl:import href="/libraries/utilities/fw-variables.xsl"/>
  <xsl:import href="/libraries/utilities/utilities.xsl"/>
  <xsl:import href="/libraries/utilities/frame.xsl"/>
  
  <xsl:output indent="no" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>
  
  <xsl:param name="include-frame" select="false()"/>
  <xsl:param name="frame-heading"/>
<!--
  <xsl:variable name="available-region-width" select="if ($include-frame) then xs:integer($fw:region-width - $config-frame-padding * 2 - $config-frame-border * 2) else $fw:region-width"/>
-->
  
  <xsl:variable name="available-region-width" select="$fw:region-width"/>
  
  <xsl:template match="/">
    <xsl:variable name="content">
      <xsl:choose>
        <xsl:when test="/result/contents/content[contentdata/form/item[@label = 'Photo' and binarydata/@key]]">
          <div class="list clear clearfix append-bottom">
            <xsl:apply-templates select="/result/contents/content[contentdata/form/item[@label = 'Photo' and binarydata/@key]]"/>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <p class="clear">
            <xsl:value-of select="portal:localize('No-photos')"/>
          </p>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$include-frame">
        <xsl:call-template name="frame.frame">
          <xsl:with-param name="content" select="$content"/>
          <xsl:with-param name="frame-heading" select="$frame-heading"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$content"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="content">
    <xsl:variable name="filter" select="concat('scalewide(', $available-region-width * 1, ',', $available-region-width * 0.4, ');', $fw:config-filter)"/>
    <div class="item">
      <img src="{portal:createImageUrl(concat(@key, '/binary/', contentdata/form/item[@label = 'Photo']/binarydata/@key), $filter)}" alt="{contentdata/form/item[@label = 'Photo']/binarydata}" title="{contentdata/form/item[@label = 'Description']/data}"/>
      <xsl:if test="contentdata/form/item[@label = 'Description']/data != ''">
        <p>
          <xsl:value-of select="contentdata/form/item[@label = 'Description']/data"/>
        </p>
      </xsl:if>
      <xsl:if test="contentdata/form/item[@label = 'Name']/data != ''">
        <p>
          <xsl:choose>
            <xsl:when test="contentdata/form/item[@label = 'E-mail']/data != ''">
              <a href="mailto:{contentdata/form/item[@label = 'E-mail']/data}">
                <xsl:value-of select="contentdata/form/item[@label = 'E-mail']/data"/>
              </a>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="contentdata/form/item[@label = 'E-mail']/data"/>
            </xsl:otherwise>
          </xsl:choose>
        </p>
      </xsl:if>
    </div>
  </xsl:template>

</xsl:stylesheet>
