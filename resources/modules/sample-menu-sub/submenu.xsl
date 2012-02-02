<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
   xmlns:util="enonic:utilities" xmlns:portal="http://www.enonic.com/cms/xslt/portal"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
   <xsl:output doctype-public="-//W3C//DTD XHTML 1.1//EN"
      doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" encoding="utf-8" indent="yes"
      method="xhtml" omit-xml-declaration="yes"/>

   <xsl:include href="/modules/sample-navigation/menu.xsl"/>

   <xsl:template match="/">
      <!-- Render sub menu -->

      <xsl:variable as="element()?" name="root-item"
         select="/result/menu/menuitems/menuitem[@path = 'true']"/>
      <!-- Adapt your datasource to serve proper root-item -->
      <xsl:if test="$root-item">
         <ul id="sub-menu" class="menu sub append-bottom">
            <li>
               <a class="first" href="{portal:createPageUrl($root-item/@key,())}">
                  <xsl:choose>
                     <xsl:when test="$root-item/menu-name != ''">
                        <xsl:value-of select="$root-item/menu-name"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="$root-item/display-name"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </a>
               <xsl:call-template name="menu.render">
                  <xsl:with-param name="menuitems" select="$root-item/menuitems" as="element()*"/>
                  <xsl:with-param name="levels" select="0" as="xs:integer"/>
                  <xsl:with-param name="currentLevel" select="1" as="xs:integer"/>
                  <xsl:with-param name="list-class"/>
                  <xsl:with-param name="list-id"/>
               </xsl:call-template>
            </li>
         </ul>
      </xsl:if>
   </xsl:template>
</xsl:stylesheet>
