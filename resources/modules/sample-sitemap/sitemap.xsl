<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="enonic:utilities">

    <xsl:import href="/modules/library-utilities/standard-variables.xsl"/>
    <xsl:include href="/modules/library-utilities/utilities.xsl"/>

    <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>

    <xsl:variable name="menu" as="element()*" select="/result/menus/menu/menuitems/menuitem"/>
    <xsl:variable name="number-of-columns" select="floor($config-region-width div 200)"/>
    <xsl:variable name="margin" select="20"/>
    <xsl:variable name="column-width" select="floor(($config-region-width - ($margin * ($number-of-columns - 1))) div $number-of-columns)"/>

    <xsl:template match="/">
        <xsl:if test="$menu">
            <ul id="sitemap" class="clearfix clear">
                <xsl:apply-templates select="$menu"/>
            </ul>
        </xsl:if>
    </xsl:template>

    <xsl:template match="menuitem">
        <li>
            <!--xsl:if test="($config-site/multilingual = 'true' and count(ancestor::menuitem) = 1) or (not($config-site/multilingual = 'true') and count(ancestor::menuitem) = 0)"-->
                <xsl:attribute name="class">
                    <xsl:text>append-bottom</xsl:text>
                    <xsl:if test="position() mod $number-of-columns = 1">
                        <xsl:text> clear</xsl:text>
                    </xsl:if>
                </xsl:attribute>
                <xsl:if test="$device-class = 'pc'">
                    <xsl:attribute name="style">
                        <xsl:value-of select="concat('width: ', $column-width, 'px;')"/>
                        <xsl:if test="position() mod $number-of-columns != 0">
                            <xsl:value-of select="concat(' margin-right: ', $margin, 'px;')"/>
                        </xsl:if>
                    </xsl:attribute>
                </xsl:if>
            <!--/xsl:if-->
            <xsl:choose>
                <xsl:when test="@type = 'label' or @type = 'section'">
                    <div>
                        <xsl:value-of select="util:menuitem-name(.)"/>
                    </div>
                </xsl:when>
                <xsl:otherwise>
                    <a href="{portal:createPageUrl(@key, ())}">
                        <xsl:if test="url/@newwindow = 'yes'">
                            <xsl:attribute name="rel">external</xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="util:menuitem-name(.)"/>
                    </a>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="menuitems/menuitem">
                <ul>
                    <xsl:apply-templates select="menuitems/menuitem"/>
                </ul>
            </xsl:if>
        </li>
    </xsl:template>

</xsl:stylesheet>
