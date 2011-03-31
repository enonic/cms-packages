<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:util="enonic:utilities" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:import href="global-variables.xsl" />
  
  <xsl:variable name="layout-width" as="xs:integer" select="xs:integer($config-device-class/layout/width)"/>
  <xsl:variable name="layout-margin" as="xs:integer" select="xs:integer($config-device-class/layout/margin)"/>
  <xsl:variable name="layout-region-north" as="element()?" select="$config-device-class/layout/regions/region[@name = 'north']"/>
  <xsl:variable name="layout-region-west" as="element()?" select="$config-device-class/layout/regions/region[@name = 'west']"/>
  <xsl:variable name="layout-region-center" as="element()?" select="$config-device-class/layout/regions/region[@name = 'center']"/>
  <!-- Calculate center column width and right margin -->
  <xsl:variable name="center-column-attribute" as="xs:anyAtomicType+">
    <xsl:choose>
      <!-- 3 columns -->
      <xsl:when test="($region-west-count > 0 or $sub-menu) and $region-east-count > 0">
        <xsl:sequence select="xs:integer($layout-region-center/width - $layout-region-center/padding * 2), $layout-margin"/>
      </xsl:when>
      <!-- 2 columns, west + center -->
      <xsl:when test="$region-west-count > 0 or $sub-menu">
        <xsl:sequence select="xs:integer($layout-region-east/width + $layout-margin + $layout-region-center/width - $layout-region-center/padding * 2), 0"/>
      </xsl:when>
      <!-- 2 columns, center + east -->
      <xsl:when test="$region-east-count > 0">
        <xsl:sequence select="xs:integer($layout-region-west/width + $layout-margin + $layout-region-center/width - $layout-region-center/padding * 2), $layout-margin"/>
      </xsl:when>
      <!-- 1 column -->
      <xsl:otherwise>
        <xsl:sequence select="xs:integer($layout-region-west/width + $layout-margin + $layout-region-center/width - $layout-region-center/padding * 2 + $layout-margin + $layout-region-east/width), 0"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="layout-region-east" as="element()?" select="$config-device-class/layout/regions/region[@name = 'east']"/>
  <xsl:variable name="layout-region-south" as="element()?" select="$config-device-class/layout/regions/region[@name = 'south']"/>
  <xsl:variable name="standard-region-parameters" as="xs:anyAtomicType*">
    <xsl:sequence select="'_config-skin', $config-skin/@name, '_config-site', 'advanced'"/>
  </xsl:variable>
  
  <!-- Number of portlet windows in region north -->
  <xsl:variable name="region-north-count" as="xs:integer" select="count($rendered-page/regions/region[name = 'north']/windows/window)"/>
  <!-- Number of portlet windows in region west -->
  <xsl:variable name="region-west-count" as="xs:integer" select="count($rendered-page/regions/region[name = 'west']/windows/window)"/>
  <!-- Number of portlet windows in region east -->
  <xsl:variable name="region-east-count" as="xs:integer" select="count($rendered-page/regions/region[name = 'east']/windows/window)"/>
  <!-- Number of portlet windows in region south -->
  <xsl:variable name="region-south-count" as="xs:integer" select="count($rendered-page/regions/region[name = 'south']/windows/window)"/>
  
  
  <xsl:template name="layout.pc-regionstyles">
    <!-- Width settings, for screen only -->
    <xsl:text>@media screen { #outer-container, #footer {</xsl:text>
    <xsl:value-of select="concat('width: ', $layout-width, 'px;')"/>
    <xsl:text>} #north {</xsl:text>
    <xsl:value-of select="concat('width: ', $layout-region-north/width - $layout-region-north/padding * 2, 'px;')"/>
    <xsl:value-of select="concat('padding: ', $layout-region-north/padding, 'px;')"/>
    <xsl:text>} #west {</xsl:text>
    <xsl:value-of select="concat('width: ', $layout-region-west/width - $layout-region-west/padding * 2, 'px;')"/>
    <xsl:value-of select="concat('padding: ', $layout-region-west/padding, 'px;')"/>
    <xsl:value-of select="concat('margin-right: ', $layout-margin, 'px;')"/>
    <xsl:text>} #center {</xsl:text>
    <xsl:value-of select="concat('width: ', $center-column-attribute[1], 'px;')"/>
    <xsl:value-of select="concat('padding: ', $layout-region-center/padding, 'px;')"/>
    <xsl:value-of select="concat('margin-right: ', $center-column-attribute[2], 'px;')"/>
    <xsl:text>} #east {</xsl:text>
    <xsl:value-of select="concat('width: ', $layout-region-east/width - $layout-region-east/padding * 2, 'px;')"/>
    <xsl:value-of select="concat('padding: ', $layout-region-east/padding, 'px;')"/>
    <xsl:text>} #south {</xsl:text>
    <xsl:value-of select="concat('width: ', $layout-region-south/width - $layout-region-south/padding * 2, 'px;')"/>
    <xsl:value-of select="concat('padding: ', $layout-region-south/padding, 'px;')"/>
    <xsl:text>}</xsl:text>
    <xsl:if test="$main-menu and count($toplevel[@fixed = 'true']) &gt; 0">
      <xsl:call-template name="menu.main-menu-styles"/>
    </xsl:if>
    <xsl:text>}</xsl:text>
    <!-- Frame settings, for all media -->
    <xsl:for-each select="$config-device-class/layout/regions/region[framepadding &gt; 0 or frameborder &gt; 0]">
      <xsl:value-of select="concat('#', @name, ' .frame {')"/>
      <xsl:if test="framepadding &gt; 0">
        <xsl:value-of select="concat('padding: ', framepadding, 'px;')"/>
      </xsl:if>
      <xsl:if test="frameborder &gt; 0">
        <xsl:value-of select="concat('border-width: ', frameborder, 'px;')"/>
      </xsl:if>
      <xsl:text>}</xsl:text>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="layout.mobile-regionstyles">
    <!-- Width settings, for screen only -->
    <xsl:text>@media screen { #header, #page-search-form, #center, #footer {</xsl:text>
    <xsl:value-of select="concat('width: ', $layout-region-center/width - $layout-region-center/padding * 2, 'px;')"/>
    <xsl:value-of select="concat('padding: ', $layout-region-center/padding, 'px;')"/>
    <xsl:text>} #outer-container, #navigation, #menu {</xsl:text>
    <xsl:value-of select="concat('width: ', $layout-width, 'px;')"/>
    <xsl:text>} #north {</xsl:text>
    <xsl:value-of select="concat('width: ', $layout-region-north/width - $layout-region-north/padding * 2, 'px;')"/>
    <xsl:value-of select="concat('padding: ', $layout-region-north/padding, 'px;')"/>
    <xsl:text>} #south {</xsl:text>
    <xsl:value-of select="concat('width: ', $layout-region-south/width - $layout-region-south/padding * 2, 'px;')"/>
    <xsl:value-of select="concat('padding: ', $layout-region-south/padding, 'px;')"/>
    <xsl:text>}}</xsl:text>
    <!-- Frame settings, for all media -->
    <xsl:for-each select="$config-device-class/layout/regions/region[framepadding &gt; 0 or frameborder &gt; 0]">
      <xsl:value-of select="concat('#', @name, ' .frame {')"/>
      <xsl:if test="framepadding &gt; 0">
        <xsl:value-of select="concat('padding: ', framepadding, 'px;')"/>
      </xsl:if>
      <xsl:if test="frameborder &gt; 0">
        <xsl:value-of select="concat('border-width: ', frameborder, 'px;')"/>
      </xsl:if>
      <xsl:text>}</xsl:text>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="layout.stylesheets">
    <!-- CSS -->
    <xsl:for-each select="$config-style[not(@condition != '')]">
      <link rel="stylesheet" href="{portal:createResourceUrl(.)}" type="text/css"/>
    </xsl:for-each>
    <xsl:if test="$config-style[@condition != '']">
      <xsl:text disable-output-escaping="yes">&lt;!--[if </xsl:text>
      <xsl:for-each-group select="$config-style[@condition != '']" group-by="@condition">
        <xsl:value-of select="@condition"/>
        <xsl:text disable-output-escaping="yes">]&gt;</xsl:text>
        <xsl:for-each select="$config-style[@condition = current()/@condition]">
          <xsl:text disable-output-escaping="yes">&lt;link rel="stylesheet" type="text/css" href="</xsl:text>
          <xsl:value-of select="portal:createResourceUrl(.)"/>
          <xsl:text disable-output-escaping="yes">"/&gt;</xsl:text>
        </xsl:for-each>
        <xsl:text disable-output-escaping="yes">&lt;![endif]--&gt;</xsl:text>
      </xsl:for-each-group>
    </xsl:if>
  </xsl:template>


</xsl:stylesheet>
