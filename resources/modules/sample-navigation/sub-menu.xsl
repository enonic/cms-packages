<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:import href="/modules/library-utilities/standard-variables.xsl"/>
    
    <xsl:output indent="no" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>
    
    <xsl:param name="menu-id" as="xs:string?"/>
    <xsl:param name="menu-class" as="xs:string?"/>
    <xsl:param name="read-more" as="xs:boolean" select="false()"/>
    <xsl:param name="include-header" select="'false'" />
    
    <xsl:template match="/">
        <xsl:if test="/result/menu/menus/menu/menuitems/node() or /result/menu/menuitems/menuitem/menuitems/node() or /result/menu/contents/content/node()">
            <xsl:choose>
                <xsl:when test="$include-header = 'true'">
                    <ul class="menu {$menu-class}">
                        <xsl:if test="$menu-id">
                            <xsl:attribute name="id" select="$menu-id"/>
                        </xsl:if>
                        <li>
                            <a href="{portal:createPageUrl(result/menu/menuitems/menuitem[@path = 'true']/@key, ())}">
                                <xsl:value-of select="/result/menu/menuitems/menuitem[@path = 'true']/display-name" />
                            </a>
                            <ul>                            
                                <xsl:apply-templates select="/result/menu/menus/menu/menuitems/menuitem[not(parameters/parameter[@name = 'hidden'] = 'true')]"/>
                                <xsl:apply-templates select="/result/menu/menuitems/menuitem[@path = 'true']/menuitems/menuitem[not(parameters/parameter[@name = 'hidden'] = 'true')]"/>
                                <xsl:apply-templates select="/result/menu/contents/content"/>
                            </ul>
                        </li>
                    </ul>        
                </xsl:when>
                <xsl:otherwise>
                    <ul class="menu {$menu-class}">
                        <xsl:if test="$menu-id">
                            <xsl:attribute name="id" select="$menu-id"/>
                        </xsl:if>
                        <xsl:apply-templates select="/result/menu/menus/menu/menuitems/menuitem[not(parameters/parameter[@name = 'hidden'] = 'true')]"/>
                        <xsl:apply-templates select="/result/menu/menuitems/menuitem/menuitems/menuitem[not(parameters/parameter[@name = 'hidden'] = 'true')]"/>
                        <xsl:apply-templates select="/result/menu/contents/content"/>
                    </ul>
                </xsl:otherwise>
            </xsl:choose>
            
            
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="menuitem">
        <li>
            <xsl:if test="@path = 'true' or position() = 1 or position() = last()">
                <xsl:attribute name="class">
                    <xsl:if test="@path = 'true'">
                        <xsl:attribute name="class" select="'path '"/>
                    </xsl:if>
                    <xsl:if test="position() = 1">
                        <xsl:attribute name="class" select="'first '"/>
                    </xsl:if>
                    <xsl:if test="position() = last()">
                        <xsl:attribute name="class" select="'last '"/>
                    </xsl:if>
                </xsl:attribute>
            </xsl:if>
            <a href="{if (@type = 'url') then url else portal:createPageUrl(@key,())}">
                <xsl:if test="url/@newwindow = 'yes'">
                    <xsl:attribute name="rel" select="'external'"/>
                </xsl:if>
                <xsl:if test="parameters/parameter[@name = 'class'] or @active = 'true'">
                    <xsl:attribute name="class" select="concat(if (@active = 'true') then 'active ' else '', parameters/parameter[@name = 'class'])"/>
                </xsl:if>
                <span>
                    <xsl:value-of select="if (display-name/text()) then display-name else name"/>
                </span>
            </a>
            <xsl:if test="menuitems/menuitem">
                <ul>
                    <xsl:apply-templates select="menuitems/menuitem"/>
                </ul>
            </xsl:if>
        </li>
    </xsl:template>
    
    <xsl:template match="content">
        <li>
            <xsl:if test="position() = last()">
                <xsl:attribute name="class" select="'last'"/>
            </xsl:if>
            <a href="{portal:createContentUrl(@key)}">
                <span>
                    <xsl:value-of select="title"/>
                </span>
                <xsl:if test="$read-more">
                    <span class="read-more">
                        <xsl:text>Les mer</xsl:text>
                    </span>
                </xsl:if>
            </a>
        </li>
    </xsl:template>
    
</xsl:stylesheet>
