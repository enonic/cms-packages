<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:portal="http://www.enonic.com/cms/xslt/portal"
    xmlns:util="http://www.enonic.com/cms/xslt/utilities"
    xmlns:fw="http://www.enonic.com/cms/xslt/framework">
    
    <xsl:import href="/libraries/utilities/fw-variables.xsl"/>
    
    <xsl:template name="breadcrumbs.print-crumbs">
        <xsl:param name="path" as="element()*"/>

        <!-- Breadcrumb trail -->
        <nav id="breadcrumb-trail">
            <xsl:value-of select="concat(portal:localize('You-are-here'), ': ')"/>
            <!-- Always start with front page -->
            <ol>
                <li>
                    <xsl:choose>
                        <xsl:when
                            test="$path[(show-in-menu = 'true' or (position() = last() and @type = 'menuitem')) and not(@key = $fw:front-page)]">
                            <a href="{$fw:front-page}">
                                <xsl:value-of select="$fw:site-name"/>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="class">current</xsl:attribute>
                            <xsl:value-of select="$fw:site-name"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </li>
                <xsl:for-each
                    select="$path[(show-in-menu = 'true' or (position() = last() and @type = 'menuitem')) and not(@key = $fw:front-page)]">
                    <li>
                        <xsl:choose>
                            <xsl:when
                                test="type = 'label' or type = 'section' or (position() = last() and @key = $fw:current-resource/@key)">
                                <xsl:attribute name="class">current</xsl:attribute>
                                <xsl:value-of select="util:menuitem-name(.)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <a href="{portal:createPageUrl(@key, ())}">
                                    <xsl:value-of select="util:menuitem-name(.)"/>
                                </a>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                    <xsl:if test="position() = last() and @key != $fw:current-resource/@key">
                        <li class="current">
                            <xsl:value-of select="util:menuitem-name($fw:current-resource)"/>
                        </li>
                    </xsl:if>
                </xsl:for-each>
            </ol>
        </nav>
    </xsl:template>

</xsl:stylesheet>
