<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:util="enonic:utilities" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:import href="global-variables.xsl" />
  
 <xsl:template name="skin.selector">
   <!-- Skin selector -->
   <xsl:if test="count($config-site/skins/skin) &gt; 1 and $user">
     <form action="{portal:createServicesUrl('user', 'setpreferences')}" method="post" id="skin-selector">
       <fieldset>
         <label for="skin-selector-list">
           <xsl:value-of select="portal:localize('Select-skin')"/>
         </label>
         <select name="SITE$skin" onchange="document.getElementById('skin-selector').submit();" id="skin-selector-list">
           <xsl:for-each select="$config-site/skins/skin">
             <option value="{@name}">
               <xsl:if test="$skin = @name">
                 <xsl:attribute name="selected">selected</xsl:attribute>
               </xsl:if>
               <xsl:value-of select="concat(translate(substring(@name, 1, 1), 'abcdefghijklmnopqrstuvwxyzæøå', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ'), substring(@name, 2))"/>
             </option>
           </xsl:for-each>
         </select>
       </fieldset>
     </form>
   </xsl:if>
 </xsl:template>

</xsl:stylesheet>
