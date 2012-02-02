<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fw="http://www.enonic.com/cms/xslt/framework" xmlns:util="http://www.enonic.com/cms/xslt/utilities" xmlns:portal="http://www.enonic.com/cms/xslt/portal">

    <xsl:import href="/modules/library-utilities/fw-variables.xsl"/>
    
    <xsl:param name="no-result-key" select="43" as="xs:integer" />

    <xsl:template match="/">
        <xsl:choose>
            <!-- Create a form and submit it to redirect user -->
            <xsl:when test="$fw:querystring-parameter[@name = 'ajaxsearch'] != ''">
                <xsl:variable name="redirect-url">
                    <xsl:choose>
                        
                        <!-- Redirect to spot when spot is found -->
                        <xsl:when test="count(/result/random-spot/contents/content) gt 0">
                            <xsl:value-of select="portal:createContentUrl( /result/random-spot/contents/content/@key, '')" />
                        </xsl:when>
                        
                        <!-- Redirect to no-result page when no spot is found -->
                        <xsl:otherwise>
                            <xsl:value-of select="portal:createPageUrl($no-result-key, ())" />
                        </xsl:otherwise>
                        
                    </xsl:choose>
                </xsl:variable>
                
                <form action="{$redirect-url}" id="redirect" method="get">
                    <input type="hidden" name="tags" value="{$fw:querystring-parameter[@name='tags']}"/>
                </form>
                <script type="text/javascript">
                    $(function() {
                        $('#redirect').submit();
                    });
                </script>
            </xsl:when>
            <!-- Show search when no search was made, or no spot was found -->
            <xsl:otherwise>
                <xsl:call-template name="spot-search"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="spot-search">
        <xsl:variable name="windowKey" select="/result/context/window/@key"/>
        <xsl:variable name="portletKey" select="/result/context/window/portlet/@key"/>
        <xsl:variable name="portletUrl" select="portal:createWindowUrl($windowKey,(''))"/>
        <xsl:variable name="tags">
            <xsl:for-each select="/result/tags/contents/content/contentdata/tags">
                <xsl:value-of select="."/>
                <xsl:if test="position() != last()">,</xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="tokenized-tags" select="distinct-values(tokenize(lower-case($tags), '[,\s]+'))"/>
        <div class="search-container">
            <div id="bluman-form" role="search">
                <form id="search-form" method="post" action="#">
                    <xsl:if test="$fw:device-class = 'mobile'">
                        <xsl:attribute name="class">form-stacked</xsl:attribute>
                    </xsl:if>
                    <fieldset>
                        <legend>Search for spots</legend>
                        <p>Fornuftig utsagn</p>
                        <div class="clearfix">
                            <select name="tags" multiple="multiple" data-placeholder="Start typing">
                                <xsl:for-each select="$tokenized-tags">
                                    <xsl:variable name="selected-tags" select="$fw:querystring-parameter[@name = 'tags']"/>
                                    <option value="{.}">
                                        <xsl:if test="contains($selected-tags, .)">
                                            <xsl:attribute name="selected">selected</xsl:attribute>
                                        </xsl:if>
                                        <xsl:value-of select="concat(upper-case(substring(., 1, 1)), substring(., 2))"/>
                                    </option>
                                </xsl:for-each>
                            </select>
                        </div>
                        <div class="clearfix">
                            <input id="find-bluman-button" type="submit" class="btn primary" value="Go"/>
                        </div>
                        <xsl:if test="$fw:querystring-parameter[@name = 'ajaxsearch'] != ''">
                            <p class="search-result">
                                No results found
                            </p>
                        </xsl:if>
                    </fieldset>
                </form>
            </div>
            <xsl:if test="$fw:device-class != 'mobile'">
                <div class="collapse-search">
                    <a href="#" id="hide-form" style="color:white;">Collapse</a>
                </div>
            </xsl:if>
            <xsl:call-template name="spot-search-scripts">
                <xsl:with-param name="portletUrl" select="$portletUrl"/>
            </xsl:call-template>
        </div>
    </xsl:template>

    <xsl:template match="menuitem" mode="cities">
        <xsl:choose>
            <xsl:when test="display-name=/result/context/resource/display-name">
                <option selected="true" value="{@key}">
                    <xsl:text>- </xsl:text>
                    <xsl:value-of select="display-name"/>
                </option>
            </xsl:when>
            <xsl:otherwise>
                <option value="{@key}">
                    <xsl:text>- </xsl:text>
                    <xsl:value-of select="display-name"/>
                </option>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="spot-search-scripts">
        <xsl:param name="portletUrl"/>
        <script type="text/javascript">
            $(function() {
                $('#search-form').submit(function(e) {
                    e.preventDefault();
                    var form = $(this);
                    var str = form.find('select[name="tags"]').serialize();
                    $('.search-container').load('<xsl:value-of select="$portletUrl"/>', {
                        tags: getParamsAsCSV(str, 'tags', ' '),
                        ajaxsearch: 'true'
                    }, function() {
                        rebindForm();
                    });
                });
            });
        </script>
    </xsl:template>
</xsl:stylesheet>
