<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:util="enonic:utilities" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
   <!--<xsl:output doctype-public="-//W3C//DTD XHTML 1.1//EN" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" encoding="utf-8" indent="yes" method="xhtml" omit-xml-declaration="yes"/>-->

   <!-- Menu template -->
   <!-- Renders a standard ul-li menutree based on parameters sent as input -->
   <xsl:template name="menu.render">
      <xsl:param name="menuitems" select="/result/menus/menu/menuitems" as="element()*"/>
      <xsl:param name="levels" select="0" as="xs:integer"/>
      <xsl:param name="currentLevel" select="1" as="xs:integer"/>
      <xsl:param name="list-class" />
      <xsl:param name="list-id" />
      
      <xsl:choose>
         <xsl:when test="exists($menuitems)">
            <xsl:if test="$menuitems/menuitem">
               <ul>
                  <xsl:if test="$list-class != ''">
                     <xsl:attribute name="class">
                        <xsl:value-of select="$list-class" />
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:if test="$list-id != ''">
                     <xsl:attribute name="id">
                        <xsl:value-of select="$list-id" />
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:for-each select="$menuitems/menuitem">
                     <li>
                        <xsl:attribute name="class">
                           <xsl:value-of select="concat('menu-level-', $currentLevel)"/> 
                           <xsl:if test="@path = 'true'">
                              <xsl:text> path</xsl:text>
                           </xsl:if>
                           <xsl:if test="@active = 'true'">
                              <xsl:text> active</xsl:text>
                           </xsl:if>
                           <xsl:if test="current()/menuitems/menuitem">
                              <xsl:text> parent</xsl:text>   
                           </xsl:if>
                        </xsl:attribute>
                        <a href="{portal:createPageUrl(@key, ())}" class="{if (position() = 1) then 'first' else if (position() = last()) then 'last' else ''}">
                           <xsl:choose>
                              <xsl:when test="menu-name != ''">
                                 <xsl:value-of select="menu-name"/>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:value-of select="display-name"/>
                              </xsl:otherwise>
                           </xsl:choose>
                        </a>
                        <xsl:if test="current()/menuitems">
                           <xsl:if test="$levels = 0 or $levels > $currentLevel">
                              <xsl:call-template name="menu.render">
                                 <xsl:with-param name="menuitems" select="current()/menuitems"/>
                                 <xsl:with-param name="currentLevel" select="$currentLevel + 1"/>
                                 <xsl:with-param name="levels" select="$levels"/>
                              </xsl:call-template>
                           </xsl:if>
                        </xsl:if>
                     </li>
                  </xsl:for-each>
               </ul>
            </xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <p>No menuitems exists on current menu element</p>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

</xsl:stylesheet>
