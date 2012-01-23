<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fw="http://www.enonic.com/cms/xslt/framework"
    xmlns:util="http://www.enonic.com/cms/xslt/utilities"
    xmlns:portal="http://www.enonic.com/cms/xslt/portal">
    
    <xsl:import href="/libraries/utilities/fw-variables.xsl"/>
    <xsl:import href="/libraries/utilities/region.xsl"/>
    <xsl:import href="/libraries/utilities/head.xsl"/>
    <xsl:import href="/libraries/utilities/error.xsl"/> 
    <xsl:import href="/libraries/utilities/accessibility.xsl"/>
    <xsl:import href="/libraries/utilities/google.xsl"/>
    
    <xsl:import href="/libraries/utilities/system.xsl"/>
    <xsl:import href="/libraries/widgets/breadcrumbs.xsl"/>
    <xsl:import href="/libraries/widgets/menu.xsl"/>
    <xsl:import href="mobile.xsl"/>
    <xsl:import href="pc.xsl"/>
    
    <xsl:output doctype-system="about:legacy-compat" method="xhtml" encoding="utf-8" indent="yes" omit-xml-declaration="yes" include-content-type="no"/>
    
    <!-- page type -->
    <!-- For multiple layouts on one site. Various layouts can be configured in theme.xml, each with a different 'name' attribute on the 'layout' element. -->
    <xsl:param name="layout" as="xs:string" select="'default'"/>
    
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
    
    <!-- Select template based on current device -->
    <xsl:template match="/">
        <xsl:variable name="config-status" select="util:system.check-config()"/>
        <xsl:choose>
            <xsl:when test="$config-status/node()">
                <xsl:copy-of select="$config-status"/>
            </xsl:when>
            <xsl:when test="$fw:device-class = 'mobile'">
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
        <html>
            <head>
                <meta charset="UTF-8"/>
                <title>
                    <xsl:value-of select="util:menuitem-name($fw:current-resource)"/>
                    <xsl:value-of select="concat(' - ', $fw:site-name)"/>
                </title>
                <link rel="shortcut icon" type="image/x-icon" href="{portal:createResourceUrl(concat($fw:theme-public, '/images/favicon.ico'))}"/>
                <xsl:call-template name="head.meta-common"/>
                <xsl:call-template name="head.script-common"/>
                <xsl:call-template name="head.css-common"/>
                <xsl:call-template name="fw:region.css">
                    <xsl:with-param name="layout" select="$layout"/>
                </xsl:call-template>
            </head>
            <body>
                <div id="container">
                    <xsl:call-template name="util:accessibility.links"/>
                    <xsl:call-template name="pc.header"/>
                    
                    <div id="outer-container">
                        <xsl:call-template name="pc.menu"/>
                        <div id="middle-container">
                            
                            <!-- Calls the breadcrumb widgets print-crumbs -->
                            <xsl:call-template name="breadcrumbs.print-crumbs">
                                <xsl:with-param name="path" select="$fw:current-resource/path/resource[position() gt 1]" />
                            </xsl:call-template>
                            
                            <!--<xsl:variable name="prepend">
                                <h1>PREPEND LASSE</h1>
                                <h2>Fuzz</h2>
                            </xsl:variable>
                            
                            <xsl:variable name="append">
                                <h1>APPEND LASSE</h1>
                            </xsl:variable>-->
                            
                            <!-- Renders all regions defined in config.xml -->
                            <xsl:call-template name="fw:region.render">
                                <xsl:with-param name="layout" select="$layout" as="xs:string"/><!--
                                <xsl:with-param name="region-name" select="'center'"/>
                                <xsl:with-param name="content-prepend" select="$prepend"/>
                                
                                <xsl:with-param name="content-append" select="$append"/>-->
                            </xsl:call-template>
                            
                        </div>
                    </div>
                    <xsl:call-template name="pc.footer" />
                </div>
                <xsl:call-template name="util:google.analytics"/>
            </body>
        </html>
    </xsl:template>
    
    
    <!-- MOBILE template -->
    <!-- Basic template for a page, outputs standard HTML-tags, metadata and all scripts, css and regions defined in the theme.xml -->
    <xsl:template name="mobile">
        <html>
            <head>
                <title>
                    <xsl:value-of select="util:menuitem-name($fw:current-resource)"/>
                </title>
                <link rel="apple-touch-icon" href="{portal:createResourceUrl(concat($fw:theme-public, '/images-mobile/apple-touch-icon.png'))}"/>
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
                    
                    <!-- Menu -->
                    <div id="navigation" class="clearfix">
                        <ul>
                            <li>
                                <a href="#" class="show-menu bullet expand">
                                    <xsl:value-of select="portal:localize('Show-menu')"/>
                                </a>
                                <xsl:call-template name="menu.render">
                                    <xsl:with-param name="menuitems" select="/result/menus/menu/menuitems"/>
                                    <xsl:with-param name="levels" select="3"/>
                                    <xsl:with-param name="list-id" select="'menu'" />
                                    <xsl:with-param name="list-class" select="'clear'" />
                                </xsl:call-template>  
                            </li>
                        </ul>
                        
                    </div>
                    
                    <!-- Search box -->
                    <xsl:if test="$fw:search-result-page != ''">
                        <form action="{portal:createUrl($fw:search-result-page)}" method="get" id="page-search-form">
                            <fieldset>
                                <label for="page-search-box">
                                    <xsl:value-of select="portal:localize('Search')"/>
                                </label>
                                <input type="text" class="text" name="q" id="page-search-box"/>
                            </fieldset>
                        </form>
                    </xsl:if>
                    <div id="middle-container">
                        <xsl:call-template name="fw:region.render"/>
                    </div>
                </div>
                <!-- Footer -->
                <xsl:call-template name="mobile.footer" />
                
                <xsl:call-template name="util:google.analytics"/>
            </body>
        </html>
    </xsl:template>
    
    
    
    
</xsl:stylesheet>
