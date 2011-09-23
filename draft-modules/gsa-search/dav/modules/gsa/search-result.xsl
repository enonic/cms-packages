<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
                xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:saxon="http://saxon.sf.net/"
                xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="enonic:utilities">

    <xsl:import href="/libraries/utilities/standard-variables.xsl"/>

    <!-- Content type templates -->
    <xsl:import href="/modules/article/article-gsa-result-template.xsl"/>
    <xsl:import href="/modules/events/event-gsa-result-template.xsl"/>

    <xsl:include href="/libraries/utilities/navigation-menu.xsl"/>
    <xsl:include href="/libraries/utilities/utilities.xsl"/>

    <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>

    <xsl:param name="pages-in-navigation" as="xs:integer" select="10"/>
    <xsl:variable name="page-id" select="/result/context/querystring/parameter[@name='id']"/>
    <xsl:variable name="with-all-these-words" select="/result/context/querystring/parameter[@name='as_q']"/>
    <xsl:variable name="exact-wording-or-phrase" select="/result/context/querystring/parameter[@name='as_epq']"/>
    <xsl:variable name="one-or-more-of-these-words" select="/result/context/querystring/parameter[@name='as_oq']"/>
    <xsl:variable name="unwanted-words" select="/result/context/querystring/parameter[@name='as_eq']"/>
    <xsl:variable name="query" select="/result/context/querystring/parameter[@name='q']"/>
    <xsl:variable name="url-parameters"
                  select="/result/context/querystring/parameter[not(@name = 'index' or @name = 'id')]"/>
    <xsl:variable name="results" select="/result/gsa-search/GSP/RES/R"/>
    <xsl:variable name="filter">
        <xsl:choose>
            <xsl:when test="exists(/result/gsa-plugin/GSP/RES/FI)">
                <xsl:text>true</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>false</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="is-adv-search"
                  select="$with-all-these-words != '' or $exact-wording-or-phrase != '' or $one-or-more-of-these-words != '' or $unwanted-words != ''"/>
    <xsl:variable name="total-query-term">
        <xsl:if test="$query != ''">
            <xsl:value-of select="$query"/>
        </xsl:if>
        <xsl:if test="$with-all-these-words != ''">
            <xsl:value-of select="$with-all-these-words"/>
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:if test="$exact-wording-or-phrase != ''">
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$exact-wording-or-phrase"/>
            <xsl:text>" </xsl:text>
        </xsl:if>
        <xsl:if test="$one-or-more-of-these-words != ''">
            <xsl:for-each select="tokenize($one-or-more-of-these-words, ' ')">
                <xsl:value-of select="."/>
                <xsl:if test="position() != last()">
                    <xsl:text> OR </xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:if test="$unwanted-words != ''">
            <xsl:for-each select="tokenize($unwanted-words, ' ')">
                <xsl:text>-</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text> </xsl:text>
            </xsl:for-each>
        </xsl:if>
    </xsl:variable>
    <xsl:variable name="suggestion" select="/result/gsa-search/GSP/Spelling/Suggestion/@q"/>
    <xsl:variable name="index-temp" select="/result/context/querystring/parameter[@name='index']"/>
    <xsl:variable name="index">
        <xsl:choose>
            <xsl:when test="$index-temp != '' and string(number($index-temp)) != 'NaN'">
                <xsl:value-of select="number($index-temp)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="0"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="google-prev-url" select="/result/gsa-search/GSP/RES/NB/PU"/>
    <xsl:variable name="google-next-url" select="/result/gsa-search/GSP/RES/NB/NU"/>
    <xsl:variable name="index-of-first-result" as="xs:integer">
        <xsl:choose>
            <xsl:when test="/result/gsa-search/GSP/RES/@SN">
                <xsl:value-of select="/result/gsa-search/GSP/RES/@SN"/>
            </xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="index-of-last-result" as="xs:integer">
        <xsl:choose>
            <xsl:when test="/result/gsa-search/GSP/RES/@EN">
                <xsl:value-of select="/result/gsa-search/GSP/RES/@EN"/>
            </xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="total-count" as="xs:integer">
        <xsl:choose>
            <xsl:when test="/result/gsa-search/GSP/RES/M">
                <xsl:value-of select="/result/gsa-search/GSP/RES/M"/>
            </xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="contents-per-page" as="xs:integer">
        <xsl:choose>
            <xsl:when test="/result/gsa-search/GSP/PARAM[@name = 'num']/@value">
                <xsl:value-of select="/result/gsa-search/GSP/PARAM[@name = 'num']/@value"/>
            </xsl:when>
            <xsl:otherwise>10</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="content-count" as="xs:integer">
        <xsl:choose>
            <xsl:when test="$index-of-last-result gt $index-of-first-result and $total-count gt 0">
                <xsl:value-of select="$index-of-last-result - ($index-of-first-result - 1)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$index-of-first-result"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:call-template name="javascript"/>
        <xsl:call-template name="search-form"/>
        <div id="gsa-search">
            <p class="clear" id="navigation-header">
                <xsl:if test="$total-count gt 0">
                    <xsl:value-of
                            select="portal:localize('GSA-results-text', ($index-of-first-result, $index-of-last-result, $total-count, normalize-space($total-query-term)))"
                            disable-output-escaping="yes"/>
                </xsl:if>
                <span>
                    <xsl:text> </xsl:text>
                    <strong>
                        <a href="javascript:" id="gsa-toggle-adv-search-button">
                            <xsl:choose>
                                <xsl:when test="$is-adv-search">
                                    <xsl:value-of select="portal:localize('GSA-hide-advanced-search')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="portal:localize('GSA-show-advanced-search')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </a>
                    </strong>
                </span>
            </p>
            <xsl:if test="/result/gsa-search/GSP/Spelling/Suggestion">
                <p class="large">
                    <xsl:value-of select="portal:localize('GSA-did-you-mean')"/>
                    <xsl:text>: </xsl:text>
                    <a href="{portal:createPageUrl($page-id, ('q', $suggestion))}">
                        <xsl:value-of select="$suggestion"/>
                    </a>
                    <xsl:text>?</xsl:text>
                </p>
            </xsl:if>

            <xsl:choose>
                <xsl:when test="$results">
                    <xsl:if test="$filter = 'true' and count($results) &lt; $total-count">
                        <!-- TODO: Alle tilgjenglige søkeparametere må være med her -->
                        <p class="clear">
                            <xsl:value-of select="portal:localize('GSA-some-results-are-excluded', $total-count)"
                                          disable-output-escaping="yes"/>
                            <xsl:text> </xsl:text>
                            <!--a href="{portal:createPageUrl($page-id,(
                            'q', $query,
                            'as_q', $with-all-these-words,
                            'as_epq',$exact-wording-or-phrase,
                            'as_oq', $one-or-more-of-these-words,
                            'as_eq', $unwanted-words,
                            'filter', '0'))}"
                               title="{portal:localize('GSA-repeat-search-with-excluded-results')}">
                                <xsl:value-of select="portal:localize('GSA-repeat-search-with-excluded-results')"/>
                            </a-->
                          <a href="{portal:createPageUrl($page-id,('q', $query))}"
                             title="{portal:localize('GSA-repeat-search-with-excluded-results')}">
                              <xsl:value-of select="portal:localize('GSA-repeat-search-with-excluded-results')"/>
                          </a>

                        </p>
                    </xsl:if>
                    <xsl:if test="$filter = 'false'">
                        <xsl:call-template name="navigation-menu.navigation-menu">
                            <xsl:with-param name="parameters" tunnel="yes" select="$url-parameters"/>
                            <xsl:with-param name="index" tunnel="yes" select="$index"/>
                            <xsl:with-param name="content-count" select="$content-count"/>
                            <xsl:with-param name="total-count" tunnel="yes" select="$total-count"/>
                            <xsl:with-param name="contents-per-page" tunnel="yes" select="$contents-per-page"/>
                        </xsl:call-template>
                    </xsl:if>
                    <div class="list clear clearfix append-bottom">
                        <xsl:apply-templates select="$results"/>
                    </div>
                    <xsl:if test="$filter = 'false'">
                        <xsl:call-template name="navigation-menu.navigation-menu">
                            <xsl:with-param name="parameters" tunnel="yes" select="$url-parameters"/>
                            <xsl:with-param name="index" tunnel="yes" select="$index"/>
                            <xsl:with-param name="content-count" select="$content-count"/>
                            <xsl:with-param name="total-count" tunnel="yes" select="$total-count"/>
                            <xsl:with-param name="contents-per-page" tunnel="yes" select="$contents-per-page"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="$total-count gt 0">
                        <p>
                            <xsl:value-of select="portal:localize('GSA-did-not-match-any-documents', $query)"
                                          disable-output-escaping="yes"/>
                        </p>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>

    <xsl:template match="R">
        <xsl:variable name="mime" select="substring-after(@MIME, 'application/')"/>
        <xsl:variable name="url" select="U"/>
        <xsl:variable name="meta-content-key" select="current()/MT[@N = '_key']/@V"/>
        <xsl:variable name="meta-content-type" select="current()/MT[@N = '_cty']/@V"/>
        <div class="item">
            <xsl:if test="position() = 1">
                <xsl:attribute name="class">item first</xsl:attribute>
            </xsl:if>
            <xsl:if test="position() = last()">
                <xsl:attribute name="class">item last</xsl:attribute>
            </xsl:if>

            <xsl:variable name="content">
                <xsl:apply-templates select="/result/gsa-search/contents/content[@key = $meta-content-key]"/>
            </xsl:variable>

            <xsl:choose>
                <xsl:when test="$content != /result/gsa-search/contents/content[@key = $meta-content-key]">
                    <xsl:copy-of select="$content"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="tooltip">
                        <xsl:call-template name="str-remove-bold">
                            <xsl:with-param name="str" select="T"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="title">
                        <xsl:call-template name="str-replace-bold-with-strong">
                            <xsl:with-param name="str" select="T"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <h2 class="bottom">
                        <xsl:if test="$mime != ''">
                            <span class="small">
                                [<xsl:value-of select="upper-case($mime)"/>]
                            </span>
                        </xsl:if>
                        <a href="{$url}" title="{$tooltip}">
                            <xsl:value-of disable-output-escaping="yes" select="$title"/>
                        </a>
                    </h2>
                    <div>
                        <xsl:variable name="abstract">
                            <xsl:call-template name="str-replace-bold-with-strong">
                                <xsl:with-param name="str" select="replace(S, '&lt;br&gt;', '')"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of disable-output-escaping="yes" select="$abstract"/>
                    </div>
                    <div class="quiet">
                        <xsl:value-of select="U"/>
                    </div>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>

    <xsl:template name="search-form">
        <div id="gsa-adv-search-form">
            <xsl:if test="not($is-adv-search)">
                <xsl:attribute name="class">
                    <xsl:text>hide</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <form action="{portal:createPageUrl($page-id, ())}">
                <fieldset>
                    <legend>
                        <xsl:value-of select="portal:localize('GSA-advanced-search')"/>
                    </legend>
                    <div>
                        <label for="as_q">
                            <xsl:value-of select="portal:localize('GSA-with-all-these-words')"/>
                        </label>
                        <input name="as_q" id="as_q" type="text" class="text" value="{$with-all-these-words}"/>
                        <div class="clear"> </div>
                        <label for="as_epq">
                            <xsl:value-of select="portal:localize('GSA-with-exact-wording-phrase')"/>
                        </label>
                        <input id="as_epq" class="text" type="text" name="as_epq" value="{$exact-wording-or-phrase}"/>
                        <label for="as_oq">
                            <xsl:value-of select="portal:localize('GSA-with-some-of-the-words')"/>
                        </label>
                        <input class="text" type="text" name="as_oq" id="as_oq" value="{$one-or-more-of-these-words}"/>
                        <label for="as_eq">
                            <xsl:value-of select="portal:localize('GSA-unwanted-words')"/>
                        </label>
                        <input class="text" type="text" name="as_eq" id="as_eq" value="{$unwanted-words}"/>
                        <div class="clear"> </div>
                    </div>
                </fieldset>
                <p class="clearfix float-right">
                    <input type="submit" value="{portal:localize('GSA-search')}" class="button"/>
                </p>
            </form>
        </div>
    </xsl:template>

    <xsl:template name="str-remove-bold">
        <xsl:param name="str"/>
        <xsl:variable name="str-2" select="replace($str, '&lt;b&gt;', '')"/>
        <xsl:variable name="str-3" select="replace($str-2, '&lt;/b&gt;', '')"/>
        <xsl:value-of select="$str-3"/>
    </xsl:template>

    <xsl:template name="str-replace-bold-with-strong">
        <xsl:param name="str"/>
        <xsl:variable name="str-2" select="replace($str, '&lt;b&gt;', '&lt;strong&gt;')"/>
        <xsl:variable name="str-3" select="replace($str-2, '&lt;/b&gt;', '&lt;/strong&gt;')"/>
        <xsl:value-of select="$str-3"/>
    </xsl:template>

    <xsl:template name="javascript">
    <script type="text/javascript">
      <xsl:comment>
        var GSASearch = {
          form : {
            slideUp : function() {
              jQuery('#gsa-adv-search-form').slideUp('slow', function() {
                jQuery('#gsa-toggle-adv-search-button').text('<xsl:value-of select="portal:localize('GSA-show-advanced-search')"/>');
              });
            },

            slideDown : function() {
              jQuery('#gsa-adv-search-form').slideDown('slow', function() {
                jQuery('#gsa-toggle-adv-search-button').text('<xsl:value-of select="portal:localize('GSA-hide-advanced-search')"/>');
              });
            }
          }
        }

        /**
         * Document ready
         *
         * Bind click events to the show-adv-search-button.
         */
        jQuery(document).ready(function() {
        <xsl:text>jQuery('#gsa-toggle-adv-search-button').toggle(</xsl:text>
        <xsl:choose>
          <xsl:when test="$is-adv-search">
            <xsl:text>GSASearch.form.slideUp, GSASearch.form.slideDown</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>GSASearch.form.slideDown, GSASearch.form.slideUp</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>);</xsl:text>
        });
      </xsl:comment>
    </script>
    </xsl:template>
</xsl:stylesheet>