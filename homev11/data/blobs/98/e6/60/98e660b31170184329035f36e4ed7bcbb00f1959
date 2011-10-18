<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:util="enonic:utilities" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <xsl:include href="utilities.xsl"/>

    <!-- Context variables -->
    <xsl:variable name="user" as="element()?" select="/result/context/user"/>
    <xsl:variable name="language" select="/result/context/@languagecode"/>
    <xsl:variable name="device-class" as="xs:string" select="/result/context/device-class"/>
    <xsl:variable name="rendered-page" as="element()" select="/result/context/page"/>
    
    <!-- Variables from framework, in use? -->
    <xsl:variable name="current-resource" as="element()" select="/result/context/resource"/>
    <xsl:variable name="url" as="xs:string" select="/result/context/querystring/@url"/>
    <xsl:variable name="path" as="xs:string" select="concat('/', string-join(/result/context/resource/path/resource/name, '/'))"/>
    <xsl:variable name="site-name" as="xs:string" select="/result/context/site/name"/>
    
    <!-- Site Configuration variables -->
    <xsl:variable name="config-home" select="/result/context/site/path-to-home-resources"/>
    <xsl:variable name="config" select="document(concat($config-home, '/site.xml'))/config"/>
    <xsl:variable name="config-theme" select="$config/theme" as="xs:string"/>
    <xsl:variable name="config-parameter" as="element()*" select="$config/parameters/parameter"/>

    <xsl:variable name="google-tracker" select="util:get-scoped-parameter('google-tracker', $path, $config-parameter)" as="element()?"/>
    <xsl:variable name="google-verify" select="util:get-scoped-parameter('google-verify', $path, $config-parameter)" as="element()?"/>    

    <!-- Theme variables -->
    <xsl:variable name="theme-location" select="concat('/themes/', $config-theme)" as="xs:string"/>
    <xsl:variable name="theme-public" select="concat('/_public/themes/', $config-theme)" as="xs:string"/>
    <xsl:variable name="theme-config" select="document(concat($theme-location, '/theme.xml'))/theme"/> 
    <xsl:variable name="config-device-class" as="element()" select="if ($theme-config/device-classes/device-class[tokenize(@name, ',')[. = $device-class]]) then $theme-config/device-classes/device-class[tokenize(@name, ',')[. = $device-class]] else $theme-config/device-classes/device-class[1]"/>
    <xsl:variable name="config-style" as="element()*" select="$config-device-class/styles/style"/>
    
    <!-- Standard pages -->
    <xsl:variable name="front-page" select="util:get-scoped-parameter('front-page', $path, $config-parameter)" as="element()?"/>
    <xsl:variable name="search-result-page" select="util:get-scoped-parameter('search-result', $path, $config-parameter)" as="element()?"/>
    <xsl:variable name="sitemap-page" select="util:get-scoped-parameter('sitemap', $path, $config-parameter)" as="element()?"/>
    <xsl:variable name="rss-page" select="util:get-scoped-parameter('rss', $path, $config-parameter)" as="element()?"/>
    <xsl:variable name="login-page" as="element()?" select="/result/context/site/login-page/resource"/>
    <xsl:variable name="error-page" as="element()?" select="/result/context/site/error-page/resource"/>
    <xsl:variable name="error-user" as="element()?" select="/result/context/querystring/parameter[contains(@name, 'error_user_')]"/>
    <xsl:variable name="success" as="element()?" select="/result/context/querystring/parameter[@name ='success']"/>
        
    <!-- Region Config variables -->
    <xsl:variable name="region" select="/result/context/window/@region"/>
    <xsl:variable name="config-filter">
        <xsl:value-of select="string-join($config-device-class/image/filters/filter, ';')"/>
        <xsl:if test="$config-device-class/image/filters/filter != ''">;</xsl:if>
    </xsl:variable>
    <xsl:variable name="config-region-prefix" as="xs:string" select="$theme-config/region-prefix"/>
    <xsl:variable name="config-imagesize" select="$config-device-class/image/sizes/size"/>
    <xsl:variable name="config-frame-padding" select="$config-device-class/layout/area/region[@name = $region]/framepadding"/>
    <xsl:variable name="config-frame-border" select="$config-device-class/layout/area/region[@name = $region]/frameborder"/>
<!--    <xsl:variable name="standard-region-parameters" as="xs:anyAtomicType*"-->
        <!--<xsl:sequence select="'_config-layout', $config-layout/@name, '_config-site', 'advanced'"/>-->
    <!--/xsl:variable-->
    
    <!-- Standard window variables passed from page -->
    <xsl:variable name="config-region-width" as="xs:integer" select="/result/context/querystring/parameter[@name = '_config-region-width']"/>

   

</xsl:stylesheet>
