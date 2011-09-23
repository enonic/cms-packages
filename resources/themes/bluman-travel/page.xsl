<xsl:stylesheet
    exclude-result-prefixes="#all"
    version="2.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:util="enonic:utilities"
    xmlns:portal="http://www.enonic.com/cms/xslt/portal"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <xsl:import href="../../libraries/utilities/standard-variables.xsl"/>
    <xsl:import href="../../libraries/utilities/region.xsl"/>
    <xsl:import href="../../libraries/utilities/head.xsl"/>
    <xsl:import href="../../libraries/utilities/error-handler.xsl"/>
    <xsl:import href="../../libraries/utilities/accessibility.xsl"/>
    <xsl:import href="../../libraries/utilities/google.xsl"/>
    <xsl:import href="../../libraries/widgets/breadcrumbs.xsl"/>
    <xsl:import href="../../libraries/widgets/menu.xsl"/>
    <xsl:import href="mobile.xsl"/>
    <xsl:import href="pc.xsl"/>

    <xsl:output method="html" omit-xml-declaration="no" doctype-system="about:legacy-compat"/>

    <!-- page type -->
    <!-- For multiple layouts on one site. Various layouts can be configured in theme.xml, each with a different 'name' attribute on the 'layout' element. -->
    <xsl:param name="layout" select="'default'" as="xs:string"/>

    <!-- regions -->
    <xsl:param name="north"><type>region</type></xsl:param>
    <xsl:param name="west"><type>region</type></xsl:param>
    <xsl:param name="south"><type>region</type></xsl:param>

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

    <xsl:template name="pc">
        <!-- paulirish.com/2008/conditional-stylesheets-vs-css-hacks-answer-neither/ -->
        <!--[if lt IE 7]> <html class="no-js ie6 oldie" dir="ltr" lang="{$language}" xml:lang="{$language}" > <![endif]-->
        <!--[if IE 7]>    <html class="no-js ie7 oldie" dir="ltr" lang="{$language}" xml:lang="{$language}" > <![endif]-->
        <!--[if IE 8]>    <html class="no-js ie8 oldie" dir="ltr" lang="{$language}" xml:lang="{$language}" > <![endif]-->
        <!--[if gt IE 8]><!--> <html class="no-js" dir="ltr" lang="{$language}" xml:lang="{$language}" > <!--<![endif]-->
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
            </head>
            <body>
                <xsl:call-template name="pc.body" />
            </body>
        </html>
    </xsl:template>

    <xsl:template name="mobile">
        <html lang="{$language}" xml:lang="{$language}">
          <head>
            <title>
              <xsl:value-of select="util:menuitem-name($current-resource)"/>
            </title>
            <link rel="apple-touch-icon" href="{portal:createResourceUrl(concat($theme-public, '/images-mobile/apple-touch-icon.png'))}"/>
            <xsl:call-template name="head.script-common" />
            <!--<xsl:call-template name="mobile.scripts" />-->
            <xsl:call-template name="head.css-common"/>

            <meta content="minimum-scale=1.0, width=device-width, user-scalable=yes" name="viewport" />
            <meta name="apple-mobile-web-app-capable" content="yes" />
          </head>
          <body>
            MOBILE
          </body>
        </html>
    </xsl:template>

    <xsl:template name="pc.body">
        <div id="container">
            <header>
                <xsl:call-template name="accessibility.links"/>
                <xsl:call-template name="pc.header"/>
            </header>
            <div id="page" role="page">
                <noscript>
                    <p>
                        <xsl:value-of select="portal:localize('javascript-required')"/>
                    </p>
                </noscript>
                <div id="outer-container">
                    <xsl:call-template name="pc.menu"/>
                    <div id="middle-container">
                        <!-- Renders all regions defined in config.xml -->
                        <xsl:call-template name="region.renderall">
                            <xsl:with-param name="layout" select="$layout" as="xs:string"/>
                        </xsl:call-template>
                    </div>
                </div>
            </div>
            <footer>
                FOOTER
            </footer>
        </div>
        <!-- JavaScript at the bottom for fast page loading -->

        <!-- Grab Google CDN's jQuery, with a protocol relative URL; fall back to local if offline
        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"></script>
        <script>window.jQuery || document.write('<script src="{portal:createResourceUrl(concat($theme-public, 'js/libs/jquery-1.6.2.min.js'))}"><\/script>')</script>
        -->
        <!-- scripts concatenated and minified via ant build script
        <script defer="defer" src="{portal:createResourceUrl(concat($theme-public, 'js/plugins.js'))}"></script>
        <script defer="defer" src="{portal:createResourceUrl(concat($theme-public, 'js/script.js'))}"></script>-->
        <!-- end scripts-->


        <!-- If google tracker is set in config.xml, renders analytics code -->
        <xsl:if test="$google-tracker/text()">
          <xsl:call-template name="google.analytics">
            <xsl:with-param name="google-tracker" select="$google-tracker"/>
          </xsl:call-template>
        </xsl:if>

        <!-- Prompt IE 6 users to install Chrome Frame. Remove this if you want to support IE 6.
           chromium.org/developers/how-tos/chrome-frame-getting-started -->
        <!--[if lt IE 7 ]>
        <script src="//ajax.googleapis.com/ajax/libs/chrome-frame/1.0.3/CFInstall.min.js"></script>
        <script>window.attachEvent('onload',function(){CFInstall.check({mode:'overlay'})})</script>
        <![endif]-->
    </xsl:template>

</xsl:stylesheet>