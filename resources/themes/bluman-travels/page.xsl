<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:util="enonic:utilities" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
 
  <xsl:import href="/libraries/utilities/standard-variables.xsl"/>
  <xsl:import href="/libraries/utilities/region.xsl"/>
  <xsl:import href="/libraries/utilities/head.xsl"/>
  <xsl:import href="/libraries/utilities/error-handler.xsl"/>
  <xsl:import href="/libraries/utilities/accessibility.xsl"/>
  <xsl:import href="/libraries/utilities/google.xsl"/>
  <xsl:import href="/libraries/widgets/breadcrumbs.xsl"/>
  <xsl:import href="/libraries/widgets/menu.xsl"/>
  <xsl:import href="mobile.xsl"/>
  <xsl:import href="pc.xsl"/>
  
  <xsl:output doctype-public="-//W3C//DTD XHTML 1.1//EN" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" encoding="utf-8" indent="yes" method="xhtml" omit-xml-declaration="yes"/>
  
  <!-- page type -->
  <!-- For multiple layouts on one site. Various layouts can be configured in theme.xml, each with a different 'name' attribute on the 'layout' element. -->
  <xsl:param name="layout" select="'welcome-page'" as="xs:string"/>
  
  <!-- regions -->
  <xsl:param name="north">
    <type>region</type>
  </xsl:param>
  <xsl:param name="west">
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
        <xsl:call-template name="mobile"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="pc"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- PC template -->
  <!-- Basic template for a page, outputs standard HTML-tags, metadata and all scripts, css and regions defined in the config.xml -->
  <xsl:template name="pc">
    <html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="{$language}" xml:lang="{$language}">
      <head>
        <title>
          <xsl:value-of select="util:menuitem-name($current-resource)"/>
          <xsl:value-of select="concat(' - ', $site-name)"/>
        </title>
        <link rel="shortcut icon" type="image/x-icon" href="{portal:createResourceUrl(concat($theme-public, '/images/favicon.ico'))}"/>
        <xsl:call-template name="head.meta-common"/>
        <xsl:call-template name="head.script-common"/>
        <xsl:call-template name="head.css-common"/>
        <xsl:call-template name="region.css">
          <xsl:with-param name="layout" select="$layout"/>
        </xsl:call-template>
        <script type="text/javascript" src="{portal:createResourceUrl(concat($theme-public, '/scripts/background.slideshow.js'))}" />
      </head>
      <body>
        <xsl:for-each select="/result/background-images/contents/relatedcontents/content[@contenttype='Image'] | /result/background-images/contents/content[@contenttype='Image']">
            <xsl:choose>
                <xsl:when test="position()=last()"><img id="bg{position()}" class="bg bg-wide" src="{portal:createImageUrl(@key,('scalewidth(1200)'))}" alt="{display-name}" /></xsl:when>
                <xsl:otherwise><img id="bg{position()}" style="visibility: hidden;" class="bg bg-wide" src="{portal:createImageUrl(@key,('scalewidth(1200)'))}" alt="{display-name}" /></xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <div id="page">
          <noscript>
            <p>
              <xsl:value-of select="portal:localize('javascript-required')"/>
            </p>
          </noscript>

          <xsl:call-template name="accessibility.links"/>
          <xsl:call-template name="pc.header"/>

          <div id="outer-container">
            <!--<xsl:call-template name="pc.menu"/>-->
            <div id="middle-container">
              <!-- Renders all regions defined in config.xml -->
              <xsl:call-template name="region.renderall">
                <xsl:with-param name="layout" select="$layout" as="xs:string"/>
              </xsl:call-template>
            </div>
          </div>
          <xsl:call-template name="pc.footer" />
        </div>
        <!-- If google tracker is set in config.xml, renders analytics code -->
        <xsl:if test="$google-tracker/text()">
          <xsl:call-template name="google.analytics">
            <xsl:with-param name="google-tracker" select="$google-tracker"/>
          </xsl:call-template>
        </xsl:if>
      </body>
    </html>
  </xsl:template>


  <!-- MOBILE template -->
  <!-- Basic template for a page, outputs standard HTML-tags, metadata and all scripts, css and regions defined in the theme.xml -->
  <xsl:template name="mobile">
    <html xmlns="http://www.w3.org/1999/xhtml" lang="{$language}" xml:lang="{$language}">
      <head>
        <title>
          <xsl:value-of select="util:menuitem-name($current-resource)"/>
        </title>
        <link rel="apple-touch-icon" href="{portal:createResourceUrl(concat($theme-public, '/images-mobile/apple-touch-icon.png'))}"/>
        <xsl:call-template name="head.script-common" />
        <xsl:call-template name="mobile.scripts" />
        <xsl:call-template name="head.css-common"/>
        
        <meta content="minimum-scale=1.0, width=device-width, user-scalable=yes"
          name="viewport" />
        <meta name="apple-mobile-web-app-capable" content="yes" />
      </head>
      <body>
        <!-- Header with logo and search box -->
        <xsl:call-template name="mobile.header" />
        <div id="outer-container" class="clear clearfix">
          <!-- Search box -->
          <xsl:if test="$search-result-page != ''">
            <form action="{portal:createUrl($search-result-page)}" method="get" id="page-search-form">
              <fieldset>
                <label for="page-search-box">
                  <xsl:value-of select="portal:localize('Search')"/>
                </label>
                <input type="text" class="text" name="q" id="page-search-box"/>
              </fieldset>
            </form>
          </xsl:if>
          <div id="middle-container" class="clear clearfix">
            <xsl:call-template name="region.renderall"/>
          </div>
        </div>
        <!-- Footer -->
        <xsl:call-template name="mobile.footer" />
        <xsl:if test="$google-tracker != ''">
          <xsl:call-template name="google.analytics">
            <xsl:with-param name="google-tracker" select="$google-tracker"/>
          </xsl:call-template>
        </xsl:if>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
