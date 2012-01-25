<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fw="http://www.enonic.com/cms/xslt/framework" xmlns:util="http://www.enonic.com/cms/xslt/utilities" xmlns:portal="http://www.enonic.com/cms/xslt/portal">

    <xsl:template name="pc.body">
        <div id="page">
            <xsl:call-template name="util:accessibility.links"/>
            <noscript>
                <p>
                    <xsl:value-of select="portal:localize('javascript-required')"/>
                </p>
            </noscript>
            <xsl:call-template name="pc.header"/>
            <xsl:call-template name="fw:region.render">
                <xsl:with-param name="region-name" select="'west'"/>
            </xsl:call-template>
            <div class="container">
                <div class="center-wrapper">
                    <xsl:variable name="mobile-version">
                        <a href="{portal:createServicesUrl('portal','forceDeviceClass', ('deviceclass', 'mobile', 'lifetime', 'session'))}" class="change-device">
                            <xsl:value-of select="portal:localize('Change-to-mobile-version')"/>
                        </a>
                    </xsl:variable>
                    <xsl:call-template name="fw:region.render">
                        <xsl:with-param name="region-name" select="'center'"/>
                        <xsl:with-param name="content-append" select="$mobile-version"/>
                    </xsl:call-template>

                </div>
            <xsl:if test="portal:isWindowEmpty( /result/context/page/regions/region[ name = 'east' ]/windows/window/@key ) = false()">
                <xsl:call-template name="fw:region.render">
                    <xsl:with-param name="region-name" select="'east'"/>
                </xsl:call-template>
            </xsl:if>
            </div>
        </div>

    </xsl:template>


    <!-- Header template -->
    <!-- Put your static header XSL/HTML here -->
    <xsl:template name="pc.header">
        <header id="header" role="banner">
            <a class="logo" href="{portal:createUrl($fw:front-page)}">
                <img alt="{$fw:site-name}-{portal:localize('logo')}" src="{portal:createResourceUrl(concat($fw:theme-public, '/images/logo-small.png'))}" title="{$fw:site-name}"/>
            </a>
            <div id="nav-wrapper" class="transparent">
                <nav accesskey="m" class="page" role="navigation">
                    <xsl:call-template name="menu.render">
                        <xsl:with-param name="menuitems" select="/result/menu/menus/menu/menuitems"/>
                        <xsl:with-param name="levels" select="3"/>
                        <xsl:with-param name="list-class" select="'mainmenu'"/>
                    </xsl:call-template>
                </nav>
                <xsl:if test="$fw:user or $fw:login-page">
                    <nav accesskey="l" class="login" role="navigation">
                        <xsl:call-template name="pc.userimage"/>
                        <xsl:call-template name="pc.userinfo"/>
                    </nav>
                </xsl:if>
            </div>
            <xsl:call-template name="breadcrumbs.print-crumbs">
                <xsl:with-param name="path" select="/result/menu/menus/menu/menuitems/menuitem[@path = 'true']"/>
                <xsl:with-param name="class" select="'transparent'" />
            </xsl:call-template>            
        </header>
    </xsl:template>


    <xsl:template name="pc.userinfo">
        <xsl:if test="$fw:user or $fw:login-page or $fw:sitemap-page != ''">
            <ul>
                <xsl:choose>
                    <!-- User logged in -->
                    <xsl:when test="$fw:user">
                        <li>
                            <xsl:choose>
                                <xsl:when test="$fw:login-page">
                                    <a href="{portal:createPageUrl($fw:login-page/@key, ())}">
                                        <xsl:value-of select="$fw:user/display-name"/>
                                    </a>
                                </xsl:when>
                                <xsl:otherwise>
                                    <div>
                                        <xsl:value-of select="$fw:user/display-name"/>
                                    </div>
                                </xsl:otherwise>
                            </xsl:choose>
                        </li>
                        <li class="last">
                            <a href="{portal:createServicesUrl('user', 'logout')}">
                                <xsl:value-of select="portal:localize('Logout')"/>
                            </a>
                        </li>
                    </xsl:when>
                    <!-- User not logged in -->
                    <xsl:when test="$fw:login-page">
                        <li class="last">
                            <a href="{portal:createPageUrl($fw:login-page/@key, ())}">
                                <xsl:value-of select="portal:localize('Login')"/>
                            </a>
                        </li>
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="$fw:sitemap-page != ''">
                    <li class="last">
                        <a href="{portal:createUrl($fw:sitemap-page)}">
                            <xsl:value-of select="portal:localize('Sitemap')"/>
                        </a>
                    </li>
                </xsl:if>
            </ul>
        </xsl:if>
    </xsl:template>


    <xsl:template name="pc.userimage">
        <img src="{if ($fw:user/photo/@exists = 'true') then portal:createImageUrl(concat('user/', $fw:user/@key), 'scalesquare(24);rounded(2)') else portal:createResourceUrl(concat($fw:theme-public, '/images/dummy-user-smallest.png'))}" title="{$fw:user/display-name}" alt="{concat(portal:localize('Image-of'), ' ', $fw:user/display-name)}" class="user-image">
            <xsl:if test="$fw:login-page">
                <xsl:attribute name="class">user-image clickable</xsl:attribute>
                <xsl:attribute name="onclick">
                    <xsl:value-of select="concat('location.href = &quot;', portal:createPageUrl($fw:login-page/@key, ()), '&quot;;')"/>
                </xsl:attribute>
            </xsl:if>
        </img>
    </xsl:template>


    <xsl:template name="pc.background-images">
        <xsl:variable name="slideshow-images" select="/result/slideshow-images/contents"/>
        <div class="slideshow">
            <xsl:for-each select="$slideshow-images/content/contentdata/image/image">
                <xsl:variable name="image-data" select="$slideshow-images/relatedcontents/content[current()/@key = @key]/contentdata/images/image"/>
                <img src="{portal:createImageUrl(@key, (''), '' , 'jpg' , 40 )}" data-imagekey="{@key}" width="{$image-data/width}" height="{$image-data/height}"/>
            </xsl:for-each>
        </div>
        <ul class="slideshow-pager">
            <xsl:for-each select="$slideshow-images/content/contentdata/image/image">
                <li>

                    <a href="#">
                        <img src="{portal:createImageUrl(@key, ('scaleblock(45, 45)'))}" height="45" width="45" style="display:block;"/>
                    </a>
                </li>
            </xsl:for-each>
        </ul>
        <div class="slideshow-description">
            <img src="{portal:createResourceUrl('/_public/themes/bluman-travel/images/arrow-right-icon-blue.png')}" class="collapse-ss-description"/>
            <ul>
                <xsl:for-each select="$slideshow-images/content">

                    <xsl:for-each select="contentdata/image">
                        <xsl:variable name="spot-name" select="../../display-name"/>
                        <xsl:variable name="joint-string" select="concat(image_text, ../../display-name)"/>
                        <li data-imagekey="{image/@key}">
                            <xsl:if test="position() != 1">
                                <xsl:attribute name="style"> display:none; </xsl:attribute>
                            </xsl:if> "<xsl:value-of select="image_text"/>", <xsl:text> </xsl:text>
                            <a href="{portal:createContentUrl(../../@key)}">
                                <xsl:value-of select="if (string-length($joint-string) > 40) then concat(substring(../../display-name, 0, 15), '...') else ../../display-name"/>
                            </a>
                        </li>
                    </xsl:for-each>

                </xsl:for-each>
            </ul>
        </div>
    </xsl:template>
</xsl:stylesheet>
