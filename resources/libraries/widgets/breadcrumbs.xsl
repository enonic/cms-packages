<?xml version="1.0"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:util="enonic:utilities">
<!--<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:util="enonic:utilities">-->

    <!-- In order to use this widget, include standard-variables as well -->
    <xsl:template name="breadcrumbs.print-crumbs">
        <xsl:param name="path" as="element()*"/>
        <!-- Breadcrumb trail -->
        <div id="breadcrumb-trail">
            <xsl:value-of select="concat(portal:localize('You-are-here'), ': ')"/>
            <!-- Always start with front page -->
            <xsl:choose>
                <xsl:when
                    test="$path[(show-in-menu = 'true' or (position() = last() and @type = 'menuitem')) and not(@key = $front-page)]">
                    <a href="{portal:createPageUrl(/result/context/site/front-page/resource/@key, ())}">
                        <xsl:value-of select="$site-name"/>
                    </a>
                    <xsl:text> / </xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$site-name"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:call-template name="breadcrumbs.print-name" >
                <xsl:with-param name="this" select="$path" />
            </xsl:call-template>
        </div>
    </xsl:template>
    
    <xsl:template name="breadcrumbs.print-name">
        <xsl:param name="this" />
        <xsl:choose>
            <xsl:when test="count($this/menuitems/menuitem[@path = 'true']) != 0">
                <a href="{portal:createPageUrl($this/@key, ())}">
                    <xsl:value-of select="$this/display-name" />
                </a>
                <xsl:text> / </xsl:text>
                <xsl:call-template name="breadcrumbs.print-name">
                    <xsl:with-param name="this" select="$this/menuitems/menuitem[@path = 'true']" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$this/display-name" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
