<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:util="enonic:utilities" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:import href="global-variables.xsl" />
  
  <xsl:template name="user.info">
    <xsl:if test="$user or $login-page or $sitemap-page != ''">
      <ul class="menu horizontal">
        <xsl:choose>
          <!-- User logged in -->
          <xsl:when test="$user">
            <li>
              <xsl:choose>
                <xsl:when test="$login-page">
                  <a href="{portal:createPageUrl($login-page/@key, ())}">
                    <xsl:value-of select="$user/display-name"/>
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <div>
                    <xsl:value-of select="$user/display-name"/>
                  </div>
                </xsl:otherwise>
              </xsl:choose>
            </li>
            <li>
              <a href="{portal:createServicesUrl('user', 'logout')}">
                <xsl:value-of select="portal:localize('Logout')"/>
              </a>
            </li>
          </xsl:when>
          <!-- User not logged in -->
          <xsl:when test="$login-page">
            <li>
              <a href="{portal:createPageUrl($login-page/@key, ())}">
                <xsl:value-of select="portal:localize('Login')"/>
              </a>
            </li>
          </xsl:when>
        </xsl:choose>
        <xsl:if test="$sitemap-page != ''">
          <li>
            <a href="{portal:createUrl($sitemap-page)}">
              <xsl:value-of select="portal:localize('Sitemap')"/>
            </a>
          </li>
        </xsl:if>
      </ul>
    </xsl:if>
  </xsl:template>


</xsl:stylesheet>
