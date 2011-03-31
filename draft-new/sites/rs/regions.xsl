<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:util="enonic:utilities" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:import href="global-variables.xsl" />
  <xsl:template name="region.render-region">
    <xsl:param name="region"/>
    <xsl:param name="parameters" as="xs:anyAtomicType*"/>
    <xsl:for-each select="$rendered-page/regions/region[name = $region]/windows/window">
      <xsl:value-of select="portal:createWindowPlaceholder(@key, $parameters)"/>
    </xsl:for-each>
  </xsl:template>


</xsl:stylesheet>
