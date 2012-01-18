<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:util="enonic:utilities" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <xsl:template name="mobile.body">
        <div id="outer-container">
        <!-- Header with logo and search box -->
        <xsl:call-template name="mobile.header" />
        

        <nav class="mobile-navigation">
            <xsl:call-template name="menu.render">
                <xsl:with-param name="menuitems" select="/result/menu/menus/menu/menuitems"/>
                <xsl:with-param name="levels" select="3"/>
                <xsl:with-param name="list-id" select="''" />
                <xsl:with-param name="list-class" select="'mobile-menu'" />
                <xsl:with-param name="expand" select="true()" />
            </xsl:call-template>
        </nav>
        <div id="west">
            <xsl:call-template name="region.render">
                <xsl:with-param name="region" select="'west'" />
            </xsl:call-template>
        </div>
            <div id="container">
                <!--<xsl:if test="portal:isWindowEmpty( /result/context/page/regions/region[ name = 'center' ]/windows/window/@key, ('_config-region-width', 500) ) = false()">-->
                <div id="center">
                    <xsl:call-template name="region.render">
                        <xsl:with-param name="region" select="'center'" />
                        <xsl:with-param name="parameters" as="xs:anyAtomicType*">
                            <xsl:sequence select="'_config-region-width', xs:integer(500)"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </div>
                <!--</xsl:if>-->
                <xsl:if test="portal:isWindowEmpty( /result/context/page/regions/region[ name = 'east' ]/windows/window/@key, ('_config-region-width', 180) ) = false()">
                    <div id="east">
                        <xsl:call-template name="region.render">
                            <xsl:with-param name="region" select="'east'" />
                            <xsl:with-param name="parameters" as="xs:anyAtomicType*">
                                <xsl:sequence select="'_config-region-width', xs:integer(180)"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </div>
                </xsl:if>
            </div>            
        </div>
        <!-- Footer -->
        <xsl:call-template name="mobile.footer" />
    </xsl:template>

    <xsl:template name="mobile.header">
        <header id="header">
            <a href="{portal:createUrl($front-page)}">
                <img alt="{$site-name}-{portal:localize('logo')}" id="logo" src="{portal:createResourceUrl('/_public/themes/bluman-travel/images/logo-small.png')}" title="{$site-name}"/>
            </a>
            <a href="#" class="toggle search">
                Toggle search
            </a>
            <a href="#" class="toggle menu">
                Toggle menu
            </a>
        </header>
    </xsl:template>

    <xsl:template name="mobile.footer">
        <footer id="footer">
            <p>
                <a href="{portal:createServicesUrl('portal','forceDeviceClass', ('deviceclass', 'pc', 'lifetime', 'session'))}" class="change-device">
                    <img src="{portal:createResourceUrl('/_public/themes/bluman-travel/images/icon-pc.png')}" alt="{portal:localize('Change-to-pc-version')}"/>
                    <xsl:value-of select="portal:localize('Change-to-pc-version')"/>
                </a>
            </p>
        </footer>
    </xsl:template>

</xsl:stylesheet>
