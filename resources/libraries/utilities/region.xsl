<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
   xmlns:util="enonic:utilities" xmlns:portal="http://www.enonic.com/cms/xslt/portal"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
   <xsl:output doctype-public="-//W3C//DTD XHTML 1.1//EN"
      doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" encoding="utf-8" indent="yes"
      method="xhtml" omit-xml-declaration="yes"/>

   <!-- Include standard-variables.xsl when using this utility -->

   <!-- Includes -->
   <xsl:include href="utilities.xsl"/>

   <xsl:variable name="active-regions" as="element()*">
      <xsl:copy-of select="/result/context/page/regions/region[count(windows/window) gt 0]"/>
   </xsl:variable>


   <!-- Regions template -->
   <!-- Renders all regions defined in theme.xml -->
   <xsl:template name="region.renderall">
      <xsl:param name="layout" as="xs:string" select="'default'"/>
      <xsl:for-each select="$config-device-class/layout[@name = $layout]//region">
         <!-- Creates region if it contains portlets or this is system region and error page-->
         <xsl:if
            test="count($rendered-page/regions/region[name = concat($config-region-prefix, current()/@name)]/windows/window) gt 0 or (current()/system = 'true' and $error-page/@key = portal:getPageKey())">
            <div id="{concat($config-region-prefix, current()/@name)}" class="region">
               <xsl:variable name="width">
                  <xsl:choose>
                     <xsl:when test="scalable = 'true'">
                        <xsl:variable name="active-siblings" as="element()*"
                           select="../region[not(scalable = 'true')][index-of($active-regions/name, concat($config-region-prefix, @name)) castable as xs:integer]"/>
                        <xsl:variable name="width-of-siblings" as="xs:integer">
                           <xsl:value-of
                              select="sum($active-siblings/width) + sum($active-siblings/margin/*) + sum($active-siblings/padding/*)"
                           />
                        </xsl:variable>
                        <xsl:variable name="padding-width" as="xs:integer">
                           <xsl:value-of
                              select="if (padding/node()) then sum(padding/node()[name() = 'left' or name() = 'right']) else 0"
                           />
                        </xsl:variable>
                        <xsl:value-of
                           select="xs:integer(../@width) - $width-of-siblings - $padding-width"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="width"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:variable>
               <xsl:call-template name="region.render">
                  <xsl:with-param name="region"
                     select="concat($config-region-prefix, current()/@name)"/>
                  <xsl:with-param name="parameters" as="xs:anyAtomicType*">
                     <xsl:sequence select="'_config-region-width', xs:integer($width)"/>
                  </xsl:with-param>
               </xsl:call-template>
            </div>
         </xsl:if>
      </xsl:for-each>
   </xsl:template>

   <xsl:template name="region.css">
      <xsl:param name="layout" as="xs:string" select="'default'"/>
      <style type="text/css">
         <xsl:apply-templates select="$config-device-class/layout[@name = $layout]//region[index-of($active-regions/name, concat($config-region-prefix, @name)) castable as xs:integer]" mode="css"/>
      </style>
   </xsl:template>

   <!-- region size css (width, margin, padding) for active regions -->
   <!-- insert region size css for active regions -->
   <xsl:template match="region" mode="css">
      <xsl:variable name="width" as="xs:integer">
         <xsl:choose>
            <xsl:when test="scalable = 'true'">
               <xsl:variable name="active-siblings" as="element()*"
                  select="../region[not(scalable = 'true')][index-of($active-regions/name, concat($config-region-prefix, @name)) castable as xs:integer]"/>
               <xsl:variable name="width-of-siblings" as="xs:integer">
                  <xsl:value-of
                     select="sum($active-siblings/width) + sum($active-siblings/margin/*) + sum($active-siblings/padding/*)"
                  />
               </xsl:variable>
               <xsl:variable name="padding-width" as="xs:integer">
                  <xsl:value-of
                     select="if (padding/node()) then sum(padding/node()[name() = 'left' or name() = 'right']) else 0"
                  />
               </xsl:variable>
               <xsl:value-of select="xs:integer(../@width) - $width-of-siblings - $padding-width"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="width"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="margin" as="xs:string"
         select="if (margin/node()) then concat(if (margin/top) then margin/top else 0, 'px ', if (margin/right) then margin/right else 0, 'px ', if (margin/bottom) then margin/bottom else 0, 'px ', if (margin/left) then margin/left else 0, 'px') else '0'"/>
      <xsl:variable name="padding" as="xs:string"
         select="if (padding/node()) then concat(if (padding/top) then padding/top else 0, 'px ', if (padding/right) then padding/right else 0, 'px ', if (padding/bottom) then padding/bottom else 0, 'px ', if (padding/left) then padding/left else 0, 'px') else '0'"/>

      <xsl:value-of select="concat('#', @name, '{')"/>
      <xsl:value-of select="concat('width: ', $width, 'px;')"/>
      <xsl:value-of select="concat('margin: ', $margin, ';')"/>
      <xsl:value-of select="concat('padding: ', $padding, ';')"/>
      <xsl:text>}</xsl:text>
   </xsl:template>



   <!-- Region template -->
   <!-- Create portlet placeholder for region -->
   <xsl:template name="region.render">
      <xsl:param name="region"/>
      <xsl:param name="parameters" as="xs:anyAtomicType*"/>
      <xsl:for-each select="$rendered-page/regions/region[name = $region]/windows/window">
         <xsl:value-of select="portal:createWindowPlaceholder(@key, $parameters)"/>
      </xsl:for-each>
   </xsl:template>





</xsl:stylesheet>
