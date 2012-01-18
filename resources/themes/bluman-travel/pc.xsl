<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <xsl:template name="pc.body">
        <div id="page">
            <nav id="accessibility-links">
                <xsl:call-template name="accessibility.links"/>
            </nav>
            <noscript><p><xsl:value-of select="portal:localize('javascript-required')"/></p></noscript>
            <xsl:call-template name="pc.header" />
            <div id="west" class="transparent">
                <xsl:call-template name="region.render">
                    <xsl:with-param name="region" select="'west'" />
                </xsl:call-template>
            </div>
            <div class="center-container">
                    <div id="center">
                        <xsl:call-template name="region.render">
                            <xsl:with-param name="region" select="'center'" />
                            <xsl:with-param name="parameters" as="xs:anyAtomicType*">
                                <xsl:sequence select="'_config-region-width', xs:integer(500)"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <a href="{portal:createServicesUrl('portal','forceDeviceClass', ('deviceclass', 'mobile', 'lifetime', 'session'))}" class="change-device">
                            <img src="{portal:createResourceUrl('/_public/themes/bluman-travel/images/icon-mobile.png')}" alt="{portal:localize('Change-to-mobile-version')}"/>
                            <xsl:value-of select="portal:localize('Change-to-mobile-version')"/>
                        </a>
                    </div>
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
        
    </xsl:template>

    <!-- Header template -->
    <!-- Put your static header XSL/HTML here -->
    <xsl:template name="pc.header">
        <header id="header" role="banner">
            <a class="logo" href="{portal:createUrl($front-page)}">
                <img alt="{$site-name}-{portal:localize('logo')}" src="{portal:createResourceUrl(concat($theme-public, '/images/logo-small.png'))}" title="{$site-name}"/>
            </a>
            <div id="nav-wrapper" class="transparent">
                <nav accesskey="m" class="page" role="navigation">
                    <xsl:call-template name="menu.render">
                        <xsl:with-param name="menuitems" select="/result/menu/menus/menu/menuitems"/>
                        <xsl:with-param name="levels" select="3"/>
                        <xsl:with-param name="list-class" select="'mainmenu'" />
                    </xsl:call-template>
                </nav>
                <xsl:if test="$user or $login-page or $user">
                    <nav accesskey="l" class="login" role="navigation">
                        <xsl:call-template name="pc.userimage" />
                        <xsl:call-template name="pc.userinfo" />
                    </nav>
                </xsl:if>
            </div>
            <nav class="breadcrumbs transparent">
                <xsl:call-template name="breadcrumbs.print-crumbs">
                    <xsl:with-param name="path" select="/result/menu/menus/menu/menuitems/menuitem[@path = 'true']" />
                </xsl:call-template>
            </nav>    
        </header>
    </xsl:template>

    <xsl:template name="pc.userinfo">
        <xsl:if test="$user or $login-page or $sitemap-page != ''">
            <ul>
                <xsl:choose>
                    <!-- User logged in -->
                    <xsl:when test="$user">
                        <li>
                            <xsl:choose>
                                <xsl:when test="$login-page">
                                    <a href="{portal:createPageUrl($login-page/@key, ())}">
                                        <xsl:value-of select="$user/display-name"/>
                                    </a>
                                </xsl:when>
                                <xsl:otherwise>
                                    <div>
                                        <xsl:value-of select="$user/display-name"/>
                                    </div>
                                </xsl:otherwise>
                            </xsl:choose>
                        </li>
                        <li class="last">
                            <a href="{portal:createServicesUrl('user', 'logout')}" >
                                <xsl:value-of select="portal:localize('Logout')"/>
                            </a>
                        </li>
                    </xsl:when>
                    <!-- User not logged in -->
                    <xsl:when test="$login-page">
                        <li class="last">
                            <a href="{portal:createPageUrl($login-page/@key, ())}">
                                <xsl:value-of select="portal:localize('Login')"/>
                            </a>
                        </li>
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="$sitemap-page != ''">
                    <li class="last">
                        <a href="{portal:createUrl($sitemap-page)}">
                            <xsl:value-of select="portal:localize('Sitemap')"/>
                        </a>
                    </li>
                </xsl:if>
            </ul>
        </xsl:if>
    </xsl:template>

    <xsl:template name="pc.userimage">
        <img src="{if ($user/photo/@exists = 'true') then portal:createImageUrl(concat('user/', $user/@key), 'scalesquare(24);rounded(2)') else portal:createResourceUrl(concat($theme-public, '/images/dummy-user-smallest.png'))}" title="{$user/display-name}" alt="{concat(portal:localize('Image-of'), ' ', $user/display-name)}" class="user-image">
            <xsl:if test="$login-page">
                <xsl:attribute name="class">user-image clickable</xsl:attribute>
                <xsl:attribute name="onclick">
                    <xsl:value-of select="concat('location.href = &quot;', portal:createPageUrl($login-page/@key, ()), '&quot;;')"/>
                </xsl:attribute>
            </xsl:if>
        </img>
    </xsl:template>
</xsl:stylesheet>
