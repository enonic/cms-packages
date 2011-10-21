<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <xsl:template name="pc.body">
        <div id="page">
            <nav id="accessibility-links-container">
                <xsl:call-template name="accessibility.links"/>
            </nav>
            <noscript><p><xsl:value-of select="portal:localize('javascript-required')"/></p></noscript>
            <xsl:call-template name="pc.header" />
            <div id="container">
                <xsl:call-template name="spot-slideshow">
                    <xsl:with-param name="slideshow-images" select="/result/slideshow-images" />
                </xsl:call-template>
                <!-- Renders all regions defined in theme.xml -->
                <xsl:call-template name="region.renderall">
                    <xsl:with-param name="layout" select="$layout" as="xs:string"/>
                </xsl:call-template>
            </div>
            <xsl:call-template name="pc.footer"/>
        </div>


        <!-- If google tracker is set in config.xml, renders analytics code -->
        <xsl:if test="$google-tracker/text()">
            <xsl:call-template name="google.analytics">
                <xsl:with-param name="google-tracker" select="$google-tracker"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Header template -->
    <!-- Put your static header XSL/HTML here -->
    <xsl:template name="pc.header">
        <header id="header" role="banner">
            <a class="screen" href="{portal:createUrl($front-page)}">
                <img alt="{$site-name}-{portal:localize('logo')}" id="logo-screen" src="{portal:createResourceUrl(concat($theme-public, '/images/logo-screen.png'))}" title="{$site-name}"/>
            </a>
            <nav accesskey="m" id="page-navigation" role="navigation">
                <xsl:call-template name="menu.render">
                    <xsl:with-param name="menuitems" select="/result/menu/menuitems"/>
                    <xsl:with-param name="levels" select="1"/>
                </xsl:call-template>
            </nav>
            <xsl:if test="$user or $login-page or $user">
                <nav accesskey="l" id="login-navigation" role="navigation">
                    <xsl:call-template name="pc.userimage" />
                    <xsl:call-template name="pc.userinfo" />
                </nav>
            </xsl:if>
        </header>
    </xsl:template>



    <!-- Footer template -->
    <!-- Put your static footer XSL/HTML here -->
    <xsl:template name="pc.footer">
        <footer id="footer" role="contentinfo">
            <nav id="device-navigation" role="navigation">
                <a href="{portal:createServicesUrl('portal','forceDeviceClass', ('deviceclass', 'mobile', 'lifetime', 'session'))}" class="change-device-to-mobile" rel="nofollow">
                    <xsl:value-of select="portal:localize('Change-to-mobile-version')"/>
                </a>
            </nav>
            <xsl:if test="$current-resource/path/resource[position() &gt; 1]">
                <nav id="breadcrumb-navigation" role="navigation">
                  <!-- Calls the breadcrumb widgets print-crumbs -->
                    <xsl:call-template name="breadcrumbs.print-crumbs">
                    <xsl:with-param name="path" select="$current-resource/path/resource[position() &gt; 1]" />
                  </xsl:call-template>
                </nav>
            </xsl:if>
            <!--<nav accesskey="s" id="spot-navigation" role="navigation">
                <xsl:call-template name="menu.render">
                    <xsl:with-param name="menuitems" select="/result/menu/menuitems/menuitem[@path='true' and name='spots']/menuitems"/>
                    <xsl:with-param name="levels" select="2"/>
                </xsl:call-template>
            </nav>-->
        </footer>
    </xsl:template>


    <xsl:template name="pc.userinfo">
        <xsl:if test="$user or $login-page or $sitemap-page != ''">
            <ul class="menu horizontal" role="navigation">
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
                        <li>
                            <a href="{portal:createServicesUrl('user', 'logout')}">
                                <xsl:value-of select="portal:localize('Logout')"/>
                            </a>
                        </li>
                    </xsl:when>
                    <!-- User not logged in -->
                    <xsl:when test="$login-page">
                        <li>
                            <a href="{portal:createPageUrl($login-page/@key, ())}">
                                <xsl:value-of select="portal:localize('Login')"/>
                            </a>
                        </li>
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="$sitemap-page != ''">
                    <li>
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
