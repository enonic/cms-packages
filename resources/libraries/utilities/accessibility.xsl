<?xml version="1.0" encoding="UTF-8"?>

<!--
   **************************************************
   
   accessibility.xsl
   version: ###VERSION-NUMBER-IS-INSERTED-HERE###
   
   **************************************************
-->

<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:fw="http://www.enonic.com/cms/xslt/framework"
   xmlns:portal="http://www.enonic.com/cms/xslt/portal"
   xmlns:util="http://www.enonic.com/cms/xslt/utilities">
        
   <!-- Accessibility links -->
   <!-- Renders hotkeys to access different anchors as defined in the config.xml -->
   <xsl:template name="util:accessibility.links">
      <xsl:if test="exists($fw:theme-config/accessibility/access-key)">
         <ul id="accessibility-links">
            <xsl:for-each select="$fw:theme-config/accessibility/access-key">
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
