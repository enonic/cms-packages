<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:util="enonic:utilities" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:import href="global-variables.xsl"/>
  
  <xsl:template name="functions.breadcrumbs">
    <!-- Breadcrumb trail -->
    <xsl:if test="$config-device-class/menu/breadcrumb = 'true'">
      <div id="breadcrumb-trail" class="clear screen">
        <xsl:value-of select="concat(portal:localize('You-are-here'), ': ')"/>
        <!-- Always start with front page -->
        <xsl:choose>
          <xsl:when test="$breadcrumb-path[(show-in-menu = 'true' or (position() = last() and @type = 'menuitem')) and not(@key = $front-page/@key)]">
            <a href="{portal:createUrl($front-page)}">
              <xsl:value-of select="$site-name"/>
            </a>
            <xsl:text> - </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$site-name"/>
          </xsl:otherwise>
        </xsl:choose>
        <!-- Loop through path -->
        <xsl:for-each select="$breadcrumb-path[(show-in-menu = 'true' or (position() = last() and @type = 'menuitem')) and not(@key = $front-page/@key)]">
          <xsl:choose>
            <xsl:when test="type = 'label' or type = 'section' or (position() = last() and @key = $current-resource/@key)">
              <xsl:value-of select="util:menuitem-name(.)"/>
            </xsl:when>
            <xsl:otherwise>
              <a href="{portal:createPageUrl(@key, ())}">
                <xsl:value-of select="util:menuitem-name(.)"/>
              </a>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="not(position() = last() and @key = $current-resource/@key)">
            <xsl:text> - </xsl:text>
          </xsl:if>
          <xsl:if test="position() = last() and @key != $current-resource/@key">
            <xsl:value-of select="util:menuitem-name($current-resource)"/>
          </xsl:if>
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="functions.searchbox">
    <xsl:if test="$search-result-page != ''">
      <form action="{portal:createUrl($search-result-page)}" method="get">
        <fieldset>
          <label for="page-search-box">
            <xsl:value-of select="portal:localize('Search')"/>
          </label>
          <input type="text" class="text" name="q" id="page-search-box" value="{$site-search-term}"/>
        </fieldset>
      </form>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
