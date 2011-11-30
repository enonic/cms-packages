<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fw="http://www.enonic.com/cms/xslt/framework"
    xmlns:util="http://www.enonic.com/cms/xslt/utilities">

    <xsl:import href="/libraries/utilities/system.xsl"/>




    <xsl:variable name="fw:current-resource" as="element()" select="/result/context/resource"/>
    
    
    <xsl:variable name="fw:site-name" as="xs:string" select="/result/context/site/name"/>

    <xsl:variable name="fw:rendered-page" as="element()" select="/result/context/page"/><!--
    <xsl:variable name="fw:path" as="xs:string" select="concat('/', string-join(/result/context/resource/path/resource/name, '/'))"/>-->
    
    <xsl:variable name="fw:path" as="xs:string" select="concat('/', string-join(tokenize(/result/context/querystring/@servletpath, '/')[position() gt 3], '/'))"/>
    
    
    <xsl:variable name="fw:user" as="element()?" select="/result/context/user"/>
    <xsl:variable name="fw:language" as="xs:string" select="/result/context/@languagecode"/>
    <xsl:variable name="fw:device-class" as="xs:string" select="/result/context/device-class"/>

    <!-- Configuration variables -->
    <xsl:variable name="fw:config" as="element()" select="document(concat(/result/context/site/path-to-home-resources, '/site.xml'))/config"/>
    <xsl:variable name="fw:config-parameter" as="element()*" select="$fw:config/parameters/parameter"/>
    <xsl:variable name="fw:config-theme" as="xs:string" select="$fw:config/theme" />
    

    <xsl:variable name="fw:public-resources" as="xs:string" select="/result/context/site/path-to-public-home-resources"/>
    
    
    
    <xsl:variable name="fw:theme-location" as="xs:string" select="concat('/themes/', $fw:config-theme)" />
    <xsl:variable name="fw:theme-config" as="element()" select="document(concat($fw:theme-location, '/theme.xml'))/theme"/>
    <xsl:variable name="fw:theme-device-class" as="element()" select="if ($fw:theme-config/device-classes/device-class[tokenize(@name, ',')[. = $fw:device-class]]) then $fw:theme-config/device-classes/device-class[tokenize(@name, ',')[. = $fw:device-class]] else $fw:theme-config/device-classes/device-class[1]"/>
    <xsl:variable name="fw:theme-region-prefix" as="xs:string" select="$fw:theme-config/region-prefix"/>
    
    <xsl:variable name="fw:theme-public" select="concat('/_public/themes/', $fw:config-theme, '/')" as="xs:string"/>
    
    <xsl:variable name="fw:front-page" as="element()?" select="util:system.get-config-param('front-page', $fw:path)"/>
    <xsl:variable name="fw:error-page" as="element()?" select="/result/context/site/error-page/resource"/>
    <xsl:variable name="fw:login-page" as="element()?" select="/result/context/site/login-page/resource"/>
    <xsl:variable name="fw:sitemap-page" as="element()?" select="util:system.get-config-param('sitemap', $fw:path)"/>
    <xsl:variable name="fw:search-result-page" as="element()?" select="util:system.get-config-param('search-result', $fw:path)"/>
    
    
    <!-- Standard window variables passed from page -->
    <xsl:variable name="fw:region-width" as="xs:integer" select="if (/result/context/querystring/parameter[@name = '_config-region-width']) then /result/context/querystring/parameter[@name = '_config-region-width'] else 300"/>
    
    
    
   
    
    
    <xsl:variable name="fw:config-filter">
        <xsl:value-of select="string-join($fw:theme-device-class/image/filters/filter, ';')"/>
        <xsl:if test="$fw:theme-device-class/image/filters/filter != ''">;</xsl:if>
    </xsl:variable>
    
    
    <xsl:variable name="fw:config-imagesize" select="$fw:theme-device-class/image/sizes/size"/>
    
    <xsl:variable name="fw:site-admin-name" as="xs:string?" select="util:system.get-config-param('site-admin-name', $fw:path)"/>
    <xsl:variable name="fw:site-admin-email" as="xs:string?" select="util:system.get-config-param('site-admin-email', $fw:path)"/>
    


</xsl:stylesheet>
