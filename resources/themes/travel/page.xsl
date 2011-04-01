<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:util="enonic:utilities" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:import href="framework.xsl"/>
  <xsl:import href="widgets/user.xsl"/>
  <xsl:import href="widgets/breadcrumbs.xsl"/>
  <xsl:import href="mobile-page.xsl"/>

  <xsl:output doctype-public="-//W3C//DTD XHTML 1.1//EN" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" encoding="utf-8" indent="yes" method="xhtml" omit-xml-declaration="yes"/>

  <!-- regions -->
  <xsl:param name="north">
    <type>region</type>
  </xsl:param>
  <xsl:param name="west">
    <type>region</type>
  </xsl:param>
  <xsl:param name="center">
    <type>region</type>
  </xsl:param>
  <xsl:param name="east">
    <type>region</type>
  </xsl:param>
  <xsl:param name="south">
    <type>region</type>
  </xsl:param>

  <!-- Start template -->
  <!-- Here you can choose different templates based on device -->
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="$device-class = 'mobile'">
        <xsl:call-template name="mobile.page"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="page.page"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  

  <!-- Page template -->
  <!-- Basic template for a page, outputs standard HTML-tags, metadata and all scripts, css and regions defined in the config.xml -->
  <xsl:template name="page.page">
    <html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="{$language}" xml:lang="{$language}">
      <head>
        <title>
          <xsl:call-template name="framework.title"/>
        </title>
        <link rel="shortcut icon" type="image/x-icon" href="{portal:createResourceUrl(concat($site-public, '/images/favicon.ico'))}"/>
        <xsl:call-template name="framework.meta-common"/>
        <xsl:call-template name="framework.script-common"/>
        <xsl:call-template name="framework.css-common"/>

      </head>
      <body>
        <div id="page">
          <noscript>
            <p>
              <xsl:value-of select="portal:localize('javascript-required')"/>
            </p>
          </noscript>
          
          <xsl:call-template name="framework.accessibility"/>
          <xsl:call-template name="page.header"/>

          <div id="outer-container">
            <xsl:call-template name="page.navigation"/>
            <div id="middle-container">

              <!-- Calls the breadcrumb widgets print-crumbs -->
              <xsl:call-template name="breadcrumbs.print-crumbs">
                <xsl:with-param name="path" select="$current-resource/path/resource[position() &gt; 1]" />
              </xsl:call-template>
              
              <!-- Renders all regions defined in config.xml -->
              <xsl:call-template name="framework.regions"/>
              
            </div>
          </div>
          <xsl:call-template name="page.footer" />
        </div>
        <!-- If google tracker is set in config.xml, renders analytics code -->
        <xsl:if test="$google-tracker/text()">
          <xsl:call-template name="google-analytics.google-analytics">
            <xsl:with-param name="google-tracker" select="$google-tracker"/>
          </xsl:call-template>
        </xsl:if>
      </body>
    </html>
  </xsl:template>
  
  

  <!-- Header template -->
  <!-- Put your static header XSL/HTML here -->
  <xsl:template name="page.header">
    <div id="header">
      <a class="screen" href="{portal:createUrl($front-page)}">
        <img alt="{$site-name}-{portal:localize('logo')}" id="logo-screen" src="{portal:createResourceUrl(concat($theme-public, '/images/logo-screen.png'))}" title="{$site-name}"/>
      </a>
      <img alt="{$site-name}-{portal:localize('logo')}" id="logo-print" class="print" src="{portal:createResourceUrl(concat($theme-public, '/images/logo-print.gif'))}" title="{$site-name}"/>
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
        <xsl:if test="$user or $login-page or $sitemap-page != '' or $search-result-page != '' or (count($config-site/skins/skin) &gt; 1 and $user)">
          <div class="header-content bottom clear clearfix">
            <!-- User stuff, rendered from the user widget -->
            <xsl:if test="$user">
              <xsl:attribute name="class">header-content bottom clear clearfix logged-in</xsl:attribute>
              <xsl:call-template name="user.image" />
            </xsl:if>
            <xsl:call-template name="user.info" />
            <!-- Search box -->
            <xsl:if test="$search-result-page != ''">
              <form action="{portal:createUrl($search-result-page)}" method="get">
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
  <xsl:template name="page.footer">
    <div id="footer">
      <img alt="{$site-name}-{portal:localize('logo')}" src="{portal:createResourceUrl(concat($path-to-skin, '/images/logo-footer.png'))}" title="{$site-name}" class="screen"/>
      <xsl:if test="$rss-page">
        <a href="{portal:createUrl($rss-page)}" class="screen">
          <img src="{portal:createResourceUrl(concat($path-to-skin, '/images/icon-rss-large.png'))}" alt="RSS {portal:localize('icon')}"/>
        </a>
      </xsl:if>
      <p>
        <xsl:value-of select="portal:localize('footer-text', (year-from-date(current-date())))"/>
      </p>
      <!-- Text main menu in footer -->
        <!--<ul class="menu horizontal footer screen">-->
          <xsl:call-template name="framework.menu">
            <xsl:with-param name="menuitems" select="/result/menu/menuitems/menuitem[@path = 'true']/menuitems"/>
            <xsl:with-param name="levels" select="1"/>
            <xsl:with-param name="list-class" select="'menu horizontal footer screen'" />
          </xsl:call-template>
        <!--</ul>-->
      
      <a href="{portal:createServicesUrl('portal','forceDeviceClass', ('deviceclass', 'mobile', 'lifetime', 'session'))}" class="device-class screen" rel="nofollow">
        <img src="{portal:createResourceUrl(concat($path-to-skin, '/images/icon-mobile.png'))}" alt="{portal:localize('Mobile-version')}" class="icon text"/>
        <xsl:value-of select="portal:localize('Change-to-mobile-version')"/>
      </a>
    </div>
  </xsl:template>
  
  
  
  <!-- Navigation template -->
  <!-- Renders the main menu -->
  <xsl:template name="page.navigation">
    <div id="main-menu">
      <xsl:call-template name="framework.menu">
        <xsl:with-param name="menuitems" select="/result/menu/menuitems/menuitem[@path = 'true']/menuitems"/>
        <xsl:with-param name="levels" select="1"/>
        <xsl:with-param name="list-class" select="'menu horizontal main level1'" />
      </xsl:call-template>
    </div>
  </xsl:template>

</xsl:stylesheet>
