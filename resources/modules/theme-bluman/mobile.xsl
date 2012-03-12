<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fw="http://www.enonic.com/cms/xslt/framework" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:util="http://www.enonic.com/cms/xslt/utilities">

    <xsl:template name="mobile.body">
        <div id="outer-container">
            <!-- Header with logo and search box -->
            <xsl:call-template name="mobile.header"/>

            <nav class="mobile-navigation">
                <xsl:call-template name="menu.render">
                    <xsl:with-param name="menuitems" select="/result/menu/menus/menu/menuitems"/>
                    <xsl:with-param name="levels" select="3"/>
                    <xsl:with-param name="list-id" select="''"/>
                    <xsl:with-param name="list-class" select="'mobile-menu'"/>
                    <xsl:with-param name="expand" select="true()"/>
                </xsl:call-template>
            </nav>
            <xsl:call-template name="util:region.render">
                <xsl:with-param name="region-name" select="'west'"/>
            </xsl:call-template>
            <div id="container">
                
                <xsl:call-template name="util:region.render">
                    <xsl:with-param name="region-name" select="'center'"/>
                </xsl:call-template>
                <xsl:call-template name="mobile.front-page-images"/>
                <xsl:if test="portal:isWindowEmpty( /result/context/page/regions/region[ name = 'east' ]/windows/window/@key )">
                    <xsl:call-template name="util:region.render">
                        <xsl:with-param name="region-name" select="'east'"/>
                    </xsl:call-template>
                </xsl:if>
            </div>
        </div>
        <!-- Footer -->
        <xsl:call-template name="mobile.footer"/>
    </xsl:template>


    <xsl:template name="mobile.header">
        <header id="header">
            <a href="{portal:createUrl($fw:front-page)}">
                <img alt="{$fw:site-name}-{portal:localize('logo')}" id="logo" src="{portal:createResourceUrl('/_public/themes/bluman-travel/images/logo-small.png')}" title="{$fw:site-name}"/>
            </a>
            <a href="#" class="toggle search"> Toggle search </a>
            <a href="#" class="toggle menu"> Toggle menu </a>
        </header>
    </xsl:template>


    <xsl:template name="mobile.footer">
        <footer id="footer">
            <p>
                <a href="{portal:createServicesUrl('portal','forceDeviceClass', ('deviceclass', 'pc', 'lifetime', 'session'))}" class="change-device">
                    <xsl:value-of select="portal:localize('Change-to-pc-version')"/>
                </a>
            </p>
        </footer>
    </xsl:template>


    <xsl:template name="mobile.front-page-images">
        <!-- Only show on frontpage -->
        <xsl:if test="$fw:current-resource/@key =  /result/context/site/front-page/resource/@key">
            <h3 style="margin-bottom:10px;">Utvalgte spots</h3>
            <xsl:variable name="slideshow-images" select="/result/slideshow-images/contents"/>
            <div id="slider" style="width:320px;">
                <ul class="spot image list">
                    <xsl:for-each select="$slideshow-images/content/contentdata/image">
                        <li class="spot">
                            <xsl:if test="position() != 1">
                                <xsl:attribute name="style">display:none;</xsl:attribute>
                            </xsl:if>
                            <img src="{portal:createImageUrl(image/@key, ('scaleblock(320, 120)'), '' , 'jpg' , 80 )}" data-imagekey="{image/@key}" width="320" height="120"/>
                            <div class="content">
                                <h3>
                                    <a href="{portal:createContentUrl(../../@key)}"><xsl:value-of select="image_text"/></a>
                                </h3>
                            </div>
                        </li>
                    </xsl:for-each>
                </ul>
                <span class="position">
                    <xsl:for-each select="$slideshow-images/content/contentdata/image">
                        <em>
                            <xsl:if test="position() = 1">
                                <xsl:attribute name="class">on</xsl:attribute>
                            </xsl:if>•</em>
                    </xsl:for-each>
                </span>
            </div>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
