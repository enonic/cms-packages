<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:util="enonic:utilities" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:import href="global-variables.xsl" />
  <xsl:import href="layout.xsl"/>
  
  <xsl:template name="region.render-region">
    <xsl:param name="region"/>
    <xsl:param name="parameters" as="xs:anyAtomicType*"/>
    <xsl:for-each select="$rendered-page/regions/region[name = $region]/windows/window">
      <xsl:value-of select="portal:createWindowPlaceholder(@key, $parameters)"/>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="region.south">
    <!-- Region south -->
    <xsl:if test="$region-south-count > 0">
      <div id="south">
        <xsl:call-template name="region.render-region">
          <xsl:with-param name="region" select="'south'"/>
          <xsl:with-param name="parameters" as="xs:anyAtomicType*">
            <xsl:sequence select="'_config-region-width', xs:integer($layout-region-south/width - $layout-region-south/padding * 2), $standard-region-parameters"/>
          </xsl:with-param>
        </xsl:call-template>
      </div>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="region.east">
    <!-- Region east -->
    <xsl:if test="$region-east-count > 0">
      <div id="east" class="column screen">
        <xsl:call-template name="region.render-region">
          <xsl:with-param name="region" select="'east'"/>
          <xsl:with-param name="parameters" as="xs:anyAtomicType*">
            <xsl:sequence select="'_config-region-width', xs:integer($layout-region-east/width - $layout-region-east/padding * 2), $standard-region-parameters"/>
          </xsl:with-param>
        </xsl:call-template>
      </div>
    </xsl:if>
  </xsl:template>


</xsl:stylesheet>
