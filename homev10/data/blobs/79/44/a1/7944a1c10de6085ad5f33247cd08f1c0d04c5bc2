<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:xs="http://www.w3.org/2001/XMLSchema">
  
  <xsl:import href="/libraries/utilities/standard-variables.xsl"/>
  <xsl:include href="/libraries/utilities/xhtml.xsl"/>
  
  <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>

  <xsl:template match="/">
    <xsl:apply-templates select="/result/contents/content"/>
  </xsl:template>

  <xsl:template match="content">
    <h1>
      <xsl:value-of select="title"/>
    </h1>
    <xsl:call-template name="xhtml.process"><!--
      <xsl:with-param name="region-width" tunnel="yes" as="xs:integer" select="$config-region-width"/>-->
      <xsl:with-param name="document" select="contentdata/text"/>
      <xsl:with-param name="image" tunnel="yes" select="/result/contents/relatedcontents/content"/>
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
