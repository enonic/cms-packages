<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:portal="http://www.enonic.com/cms/xslt/portal"
    xmlns:util="http://www.enonic.com/cms/xslt/utilities"
    xmlns:fw="http://www.enonic.com/cms/xslt/framework">
    
    <xsl:import href="/modules/library-utilities/fw-variables.xsl"/>
    
    <xsl:template name="breadcrumbs.print-crumbs">
        <xsl:param name="path" as="element()*"/>
        <xsl:param name="class" as="xs:string" select="''" />

        <!-- Breadcrumb trail -->
        <nav class="breadcrumbs">
            <xsl:if test="normalize-space($class)">
                <xsl:attribute name="class">
                    <xsl:value-of select="concat('breadcrumbs ', normalize-space($class))" />
                </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="concat(portal:localize('You-are-here'), ': ')"/>
            <!-- Always start with front page -->
            <ol>
            <xsl:choose>
                <xsl:when
                    test="$path[(show-in-menu = 'true' or (position() = last() and @type = 'menuitem')) and not(@key = $fw:front-page)]">
                    <li>
                        <a href="{portal:createPageUrl(/result/context/site/front-page/resource/@key, ())}">
                            <xsl:value-of select="$fw:site-name"/>
                        </a>
                    </li>
                </xsl:when>
                <xsl:otherwise>
                    <li>
                        <xsl:value-of select="$fw:site-name"/>
                    </li>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:call-template name="breadcrumbs.print-name" >
                <xsl:with-param name="this" select="$path" />
            </xsl:call-template>
            </ol>
        </nav>
    </xsl:template>
    
    <xsl:template name="breadcrumbs.print-name">
        <xsl:param name="this" />
            <xsl:choose>
                <xsl:when test="count($this/menuitems/menuitem[@path = 'true']) != 0">
                    <li>
                        <xsl:if test="$this/@active = 'true'">
                            <xsl:attribute name="class" select="'current'" />
                        </xsl:if>
                        <a href="{portal:createPageUrl($this/@key, ())}">
                            <xsl:value-of select="$this/display-name" />
                        </a>
                    </li>
                    <xsl:call-template name="breadcrumbs.print-name">
                        <xsl:with-param name="this" select="$this/menuitems/menuitem[@path = 'true']" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <li>
                        <xsl:if test="$this/@active = 'true'">
                            <xsl:attribute name="class" select="'current'" />
                        </xsl:if>
                        <xsl:value-of select="$this/display-name" />
                    </li>
                </xsl:otherwise>
            </xsl:choose>
        
    </xsl:template>

</xsl:stylesheet>
