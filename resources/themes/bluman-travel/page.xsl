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
    <xsl:template name="pc"><!--
        <html dir="ltr" lang="{$fw:language}" xml:lang="{$fw:language}">-->
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
                <xsl:call-template name="pc.body" />
                <xsl:call-template name="background-images" />
                <xsl:call-template name="util:google.analytics"/>
            </body>
        </html>
    </xsl:template>
    
    <!-- MOBILE template -->
    <!-- Basic template for a page, outputs standard HTML-tags, metadata and all scripts, css and regions defined in the theme.xml -->
    <xsl:template name="mobile">
        <html lang="{$fw:language}" xml:lang="{$fw:language}">
            <head>
                <title>
                    <xsl:value-of select="util:menuitem-name($fw:current-resource)"/>
                </title>
                <link rel="apple-touch-icon" href="{portal:createResourceUrl(concat($fw:theme-public, '/images-mobile/apple-touch-icon.png'))}"/>
                <xsl:call-template name="head.script-common" />
                <!--<xsl:call-template name="mobile.scripts" />-->
                <xsl:call-template name="head.css-common"/>
                
                <meta content="minimum-scale=1.0, width=device-width, user-scalable=yes"
                    name="viewport" />
                <meta name="apple-mobile-web-app-capable" content="yes" />
            </head>
            <body>
                <xsl:call-template name="mobile.body" />
                <xsl:call-template name="util:google.analytics"/>
            </body>
        </html>
    </xsl:template>


        
        <xsl:template name="background-images">
            <div class="slideshow">
                <xsl:for-each select="/result/slideshow-images/contents/content/contentdata/image/image">
                    <xsl:variable name="image-data" select="/result/slideshow-images/contents/relatedcontents/content[current()/@key = @key]/contentdata/images/image" />
                    <img src="{portal:createImageUrl(@key, (''), '' , 'jpg' , 40 )}" data-imagekey="{@key}" width="{$image-data/width}" height="{$image-data/height}" />
                </xsl:for-each>
            </div>
            <ul class="slideshow-pager">
                <xsl:for-each select="/result/slideshow-images/contents/content/contentdata/image/image">
                    <li>
                        
                        <a href="#">
                            <img src="{portal:createImageUrl(@key, ('scaleblock(45, 45)'))}" heigh="45" width="45" style="display:block;" />
                        </a>
                    </li>
                </xsl:for-each>
            </ul>
            <div class="slideshow-description">
                <img src="{portal:createResourceUrl('/_public/themes/bluman-travel/images/arrow-right-icon-blue.png')}" class="collapse-ss-description" />
                <ul>
                    <xsl:for-each select="/result/slideshow-images/contents/content">

                            <xsl:for-each select="contentdata/image">
                                <li data-imagekey="{image/@key}">
                                    <xsl:if test="position() != 1">
                                        <xsl:attribute name="style">
                                            display:none;
                                        </xsl:attribute>    
                                    </xsl:if>
                                    
                                    "<xsl:value-of select="image_text" />",
                                    <xsl:text> </xsl:text>
                                    <a href="{portal:createContentUrl(../../@key)}"><xsl:value-of select="../../display-name" /></a> 
                                </li>                                    
                            </xsl:for-each>
                        
                    </xsl:for-each>
                </ul>
            </div>
        </xsl:template>





</xsl:stylesheet>