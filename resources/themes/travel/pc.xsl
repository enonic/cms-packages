<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fw="http://www.enonic.com/cms/xslt/framework"
  xmlns:util="http://www.enonic.com/cms/xslt/utilities"
  xmlns:portal="http://www.enonic.com/cms/xslt/portal">
 
  <!-- Support templates for PC version -->

  <!-- Header template -->
  <!-- Put your static header XSL/HTML here -->
  <xsl:template name="pc.header">
    <div id="header">
      <a class="screen" href="{portal:createUrl($fw:front-page)}">
        <img alt="{$fw:site-name}-{portal:localize('logo')}" id="logo-screen" src="{portal:createResourceUrl(concat($fw:theme-public, '/images/logo-screen.png'))}" title="{$fw:site-name}"/>
      </a>
      <img alt="{$fw:site-name}-{portal:localize('logo')}" id="logo-print" class="print" src="{portal:createResourceUrl(concat($fw:theme-public, '/images/logo-print.gif'))}" title="{$fw:site-name}"/>
      <div id="header-content" class="screen">
        <div class="header-content top clearfix">
          <ul class="menu horizontal flags screen">
            <li id="text-size">
              <a href="#" class="change-text-size">
                <xsl:value-of select="portal:localize('Text-size')"/>
              </a>
              <a href="#">A</a>
              <a href="#" class="large-text">A</a>
              <a href="#" class="largest-text">A</a>
            </li>
            <li>
              <a href="#" id="contrast">
                <xsl:value-of select="portal:localize('High-contrast')"/>
              </a>
            </li>
          </ul>
        </div>
        <xsl:if test="$fw:user or $fw:login-page or $fw:sitemap-page != '' or $fw:search-result-page != '' or $fw:user">
          <div class="header-content bottom clear clearfix">
            <!-- User stuff, rendered from the user widget -->
            <xsl:if test="$fw:user">
              <xsl:attribute name="class">header-content bottom clear clearfix logged-in</xsl:attribute>
              <xsl:call-template name="pc.userimage" />
            </xsl:if>
            <xsl:call-template name="pc.userinfo" />
            <!-- Search box -->
            <xsl:if test="$fw:search-result-page != ''">
              <form action="{portal:createUrl($fw:search-result-page)}" method="get">
                <fieldset>
                  <label for="page-search-box">
                    <xsl:value-of select="portal:localize('Search')"/>
                  </label>
                  <input type="text" class="text" name="q" id="page-search-box"/>
                </fieldset>
              </form>
            </xsl:if>
          </div>
        </xsl:if>
      </div>
    </div>
  </xsl:template>
  
  
  
  <!-- Footer template -->
  <!-- Put your static footer XSL/HTML here -->
  <xsl:template name="pc.footer">
    <div id="footer">
      <img alt="{$fw:site-name}-{portal:localize('logo')}" src="{portal:createResourceUrl(concat($fw:theme-public, '/images/logo-footer.png'))}" title="{$fw:site-name}" class="screen"/>
      <!--<xsl:if test="$rss-page">
        <a href="{portal:createUrl($rss-page)}" class="screen">
          <img src="{portal:createResourceUrl(concat($fw:theme-public, '/images/icon-rss-large.png'))}" alt="RSS {portal:localize('icon')}"/>
        </a>
      </xsl:if>-->
      <p>
        <xsl:value-of select="portal:localize('footer-text', (year-from-date(current-date())))"/>
      </p>
      <!-- Text main menu in footer -->
      <!--<ul class="menu horizontal footer screen">-->
      <xsl:call-template name="menu.render">
        <xsl:with-param name="menuitems" select="/result/menu/menuitems"/>
        <xsl:with-param name="levels" select="1"/>
        <xsl:with-param name="list-class" select="'menu horizontal footer screen'" />
      </xsl:call-template>
      <!--</ul>-->
      
      <a href="{portal:createServicesUrl('portal','forceDeviceClass', ('deviceclass', 'mobile', 'lifetime', 'session'))}" class="device-class screen" rel="nofollow">
        <img src="{portal:createResourceUrl(concat($fw:theme-public, '/images/icon-mobile.png'))}" alt="{portal:localize('Mobile-version')}" class="icon text"/>
        <xsl:value-of select="portal:localize('Change-to-mobile-version')"/>
      </a>
    </div>
  </xsl:template>
  
  <!-- Menu template -->
  <!-- Renders the main menu -->
  <xsl:template name="pc.menu">
    <div id="main-menu">
      <xsl:call-template name="menu.render">
        <xsl:with-param name="menuitems" select="/result/menus/menu/menuitems"/>
        <xsl:with-param name="levels" select="1"/>
        <xsl:with-param name="list-class" select="'menu horizontal main level1'" />
      </xsl:call-template>
    </div>
  </xsl:template>
  
  
  <xsl:template name="pc.userinfo">
    <xsl:if test="$fw:user or $fw:login-page or $fw:sitemap-page != ''">
      <ul class="menu horizontal">
        <xsl:choose>
          <!-- User logged in -->
          <xsl:when test="$fw:user">
            <li>
              <xsl:choose>
                <xsl:when test="$fw:login-page">
                  <a href="{portal:createPageUrl($fw:login-page/@key, ())}">
                    <xsl:value-of select="$fw:user/display-name"/>
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <div>
                    <xsl:value-of select="$fw:user/display-name"/>
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
          <xsl:when test="$fw:login-page">
            <li>
              <a href="{portal:createPageUrl($fw:login-page/@key, ())}">
                <xsl:value-of select="portal:localize('Login')"/>
              </a>
            </li>
          </xsl:when>
        </xsl:choose>
        <xsl:if test="$fw:sitemap-page != ''">
          <li>
            <a href="{portal:createUrl($fw:sitemap-page)}">
              <xsl:value-of select="portal:localize('Sitemap')"/>
            </a>
          </li>
        </xsl:if>
      </ul>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="pc.userimage">
    <img src="{if ($fw:user/photo/@exists = 'true') then portal:createImageUrl(concat('user/', $fw:user/@key), 'scalesquare(48);rounded(2)') else portal:createResourceUrl(concat($fw:theme-public, '/images/dummy-user-small.png'))}" title="{$fw:user/display-name}" alt="{concat(portal:localize('Image-of'), ' ', $fw:user/display-name)}" class="user-image">
      <xsl:if test="$fw:login-page">
        <xsl:attribute name="class">user-image clickable</xsl:attribute>
        <xsl:attribute name="onclick">
          <xsl:value-of select="concat('location.href = &quot;', portal:createPageUrl($fw:login-page/@key, ()), '&quot;;')"/>
        </xsl:attribute>
      </xsl:if>
    </img>
  </xsl:template>
  
  
 
  

</xsl:stylesheet>
