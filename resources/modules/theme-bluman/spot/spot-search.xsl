<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fw="http://www.enonic.com/cms/xslt/framework"
    xmlns:util="http://www.enonic.com/cms/xslt/utilities"
    xmlns:portal="http://www.enonic.com/cms/xslt/portal">
 
    <xsl:import href="/modules/library-stk/utilities/fw-variables.xsl"/>

    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="/result/context/querystring/parameter[@name = 'ajaxsearch']">
                <input type="hidden" id="contentKey" value="{/result/random-spot/contents/content/@key}"/>
                <input type="hidden" id="contentUrl" value="{portal:createContentUrl( /result/random-spot/contents/content/@key, '')}"/>
            </xsl:when>
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
                <xsl:value-of select="." />
                <xsl:if test="position() != last()">,</xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="tokenized-tags" select="distinct-values(tokenize(lower-case($tags), '[,\s]+'))" />
        
        <div id="bluman-form" role="search">
            <form id="search-form" method="post" action="#">
                <xsl:if test="$fw:device-class = 'mobile'">
                    <xsl:attribute name="class">form-stacked</xsl:attribute>
                </xsl:if>
                <fieldset>
                    <legend>Search for spots</legend>
<!--                    <div class="clearfix">
                        <p>Our favorite spots in:</p>
                        <label for="locationKey" class="no-show">Select city</label>
                        <select name="locationKey" class="span3">
                            <option value="">Select destination</option>
                            <xsl:for-each select="/result/spots/menuitems/menuitem">
                                <xsl:choose>
                                    <xsl:when test="display-name=/result/context/resource/display-name">
                                        <option selected="true" value="{@key}">
                                            <xsl:value-of select="display-name"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{@key}">
                                            <xsl:value-of select="display-name"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:apply-templates select="menuitems/menuitem" mode="cities"/>
                            </xsl:for-each>
                        </select>
                    </div>-->
                    <p>Fornuftig utsagn</p>
                    <div class="clearfix">
                        <!--<p>for:</p>
                        <ul class="inputs-list">
                            <xsl:for-each select="$tokenized-tags">
                                <xsl:sort />
                                <li>
                                    <label>
                                        <input type="checkbox" value="{.}"/>
                                        <span style="text-transform:capitalize;">
                                            <xsl:value-of select="."/>
                                        </span>
                                    </label>
                                </li>
                            </xsl:for-each>
                        </ul>-->
                        <select name="spottags" multiple="multiple" data-placeholder="Start typing">
                            <xsl:for-each select="$tokenized-tags">
                                <option value="{.}" selected="selected"><xsl:value-of select="."></xsl:value-of></option>
                            </xsl:for-each>
                        </select>
                    </div>
                    <!--<span>
                        <input type="hidden" id="spottags" name="spottags" value="TEST"/>
                    </span>-->
                    <input id="find-bluman-button" type="submit" class="btn primary" value="Go"/>
                </fieldset>
            </form>
            <div id="appendRandomSpotHere">
                <xsl:comment> // </xsl:comment>
            </div>
        </div>
        <xsl:if test="$fw:device-class != 'mobile'">
            <div class="collapse-search">
                <a href="#" id="hide-form" style="color:white;">Collapse</a>
            </div>
        </xsl:if>
        <xsl:call-template name="spot-search-scripts">
            <xsl:with-param name="portletUrl" select="$portletUrl"/>
        </xsl:call-template>
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
                    console.log(data);
                });
            });
        </script>
<!--        <script type="text/javascript">
              var foundSpot = new Boolean(0);
              $(document).ready(function(){
                    /*Maintain a comma separated list of spottags used in datasource to filter random spot when form is submitted*/
                    $('#taglist').click(function(){
                        $('#spottags').val('');
                        $('#taglist ').each(function(){
                            if(!$('#spottags').val())
                                $('#spottags').val($('#spottags').val() + $(this).val());
                            else
                                $('#spottags').val($('#spottags').val() + ',' + $(this).val());
                        });
                    });

                    /*Submit ajax query to find random spot (contentKey) in selected city, we need this to get correct http url for spot*/
                    $("#find-bluman-button").click(function() {
                         if ($("#bluman-form select[name=locationKey] ").find("option:selected").val()!=''){
                            console.log("find random spot with ajax");
                            $.get("<xsl:value-of select="$portletUrl"/>", {locationKey: $('#bluman-form select[name=locationKey]').find("option:selected").val(), spottags: $('#bluman-form #spottags').val(), ajaxsearch: "true"},
                               function(data){
                                    console.log(data);
                                    $('#appendRandomSpotHere').children('input').remove();
                                    $('#appendRandomSpotHere').append(data);
                                    if (!$('#contentKey').val()){
                                        console.log('No spots found, try a new search!');
                                    }else{
                                        $('#myForm').attr('action', $('#contentUrl').val());
                                        foundSpot = new Boolean(1);
                                        $('#myForm').submit();
                                    }
                               }
                            );
                        }
                        else{
                            console.log('No location selected!');
                        }
                        return foundSpot.valueOf();
                    });
                 });
            </script>-->
    </xsl:template>
</xsl:stylesheet>