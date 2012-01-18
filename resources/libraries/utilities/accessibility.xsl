<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:util="enonic:utilities" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
   <xsl:output doctype-public="-//W3C//DTD XHTML 1.1//EN" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" encoding="utf-8" indent="yes" method="xhtml" omit-xml-declaration="yes"/>
   
   <!-- To use this template, remember to include standard-variables.xsl as well -->
        
   <!-- Accessibility links -->
   <!-- Renders hotkeys to access different anchors as defined in the config.xml -->
   <xsl:template name="accessibility.links">
      <xsl:param name="list-id" select="''" />
      <xsl:if test="exists($theme-config/accessibility/access-key)">
         <ul>
            <xsl:if test="$list-id != ''">
               <xsl:attribute name="id">
                  <xsl:value-of select="$list-id" />
               </xsl:attribute>
            </xsl:if>
            <xsl:for-each select="$theme-config/accessibility/access-key">
               <li>
                  <a href="#{@anchor}" accesskey="{@key}">
                     <xsl:value-of select="portal:localize(@text)"/>
                  </a>
               </li>
            </xsl:for-each>
         </ul>
      </xsl:if>
   </xsl:template>
  
</xsl:stylesheet>
