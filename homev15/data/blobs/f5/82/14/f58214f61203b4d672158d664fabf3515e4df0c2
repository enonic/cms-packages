<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- Context variables -->
    <xsl:variable name="device-class" select="/result/context/device-class"/>
    <xsl:variable name="region" select="/result/context/window/@region"/>
    <xsl:variable name="user" select="/result/context/user"/>
    <xsl:variable name="language" select="/result/context/@languagecode"/>

    <!-- Standard variables passed on from page.xsl -->
    <xsl:variable name="region-width" select="/result/context/querystring/parameter[@name = '_config-region-width']"/>
    <xsl:variable name="skin" select="/result/context/querystring/parameter[@name = '_config-skin']"/>
    <xsl:variable name="site" select="/result/context/querystring/parameter[@name = '_config-site']"/>
    
    <!-- Configuration variables -->
    <xsl:variable name="config-site" select="document(concat(/result/context/site/path-to-home-resources, '/sites/', $site, '/config.xml'))/config"/>
    <xsl:variable name="config-device-class" select="document(concat('/skins/', $site, '/', $skin, '/skin.xml'))/skin/device-classes/device-class"/>
    <xsl:variable name="config-device-class-current" select="if ($config-device-class[tokenize(@name, ',')[. = $device-class]]) then $config-device-class[tokenize(@name, ',')[. = $device-class]] else $config-device-class[1]"/>
    <xsl:variable name="config-filter">
        <xsl:value-of select="string-join($config-device-class-current/image/filters/filter, ';')"/>
        <xsl:if test="$config-device-class-current/image/filters/filter != ''">;</xsl:if>
    </xsl:variable>
    <xsl:variable name="config-imagesize" select="$config-device-class-current/image/sizes/size"/>
    <xsl:variable name="config-frame-padding" select="$config-device-class-current/layout/regions/region[@name = $region]/framepadding"/>
    <xsl:variable name="config-frame-border" select="$config-device-class-current/layout/regions/region[@name = $region]/frameborder"/>
    
    <!-- Other variables -->
    <xsl:variable name="path-to-skin" select="concat('/_public/skins/', $site, '/', $skin)"/>

</xsl:stylesheet>
