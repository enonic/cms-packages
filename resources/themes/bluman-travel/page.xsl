<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:util="enonic:utilities"
    xmlns:portal="http://www.enonic.com/cms/xslt/portal">

   <xsl:output method="html" version="1.0"
      omit-xml-declaration="no"
      doctype-system="about:legacy-compat"/>

  <xsl:param name="layout" select="'default'" as="xs:string"/>

  <xsl:param name="north">
    <type>region</type>
  </xsl:param>
  <xsl:param name="west">
    <type>region</type>
  </xsl:param>
  <xsl:param name="south">
    <type>region</type>
  </xsl:param>

   <xsl:template match="/html:html/html:body">
      <xsl:copy>
         <xsl:apply-templates select="@*"/>
         <p>HEADER<!--Template header code goes here.--></p>
         <xsl:apply-templates select="node()"/>
         <p>FOOTER<!--Template footer code goes here.--></p>
      </xsl:copy>
   </xsl:template>

   <xsl:template match="@*|node()">
      <xsl:copy>
         <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
   </xsl:template>

</xsl:stylesheet>