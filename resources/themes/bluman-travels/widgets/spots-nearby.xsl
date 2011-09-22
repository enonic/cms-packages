<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:util="enonic:utilities"
                xmlns:portal="http://www.enonic.com/cms/xslt/portal"
                xmlns:math="http://exslt.org/math"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:import href="/libraries/utilities/standard-variables.xsl"/>
    <xsl:include href="/libraries/utilities/utilities.xsl"/>
    <xsl:include href="/libraries/utilities/frame.xsl"/>

    <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>

    <xsl:template match="/">
        <xsl:call-template name="jquery-scripts" />
        <xsl:if test="/result/spots-nearby/contents/content">
            <div class="spots-nearby-container">
                <div id="spots-info" class="spots-info">
                    <p class="infoText">
                        You<xsl:choose><xsl:when test="/result/context/querystring/parameter[@name='spot']"> searched </xsl:when><xsl:otherwise> browsed </xsl:otherwise></xsl:choose>
                      <xsl:text> for spots in </xsl:text>
                        <xsl:choose>
                            <xsl:when test="/result/context/querystring/parameter[@name='spot'] and /result/context/querystring/parameter[@name='country']">
                                <span><xsl:value-of select="/result/context/querystring/parameter[@name='spot']" /></span>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="/result/context/resource/display-name" />
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="/result/context/querystring/parameter[@name='spottag']">
                            <xsl:text> related to </xsl:text>
                            <xsl:variable name="numberOfTags" select="count(/result/context/querystring/parameter[@name='spottag'])" />
                            <xsl:for-each select="/result/context/querystring/parameter[@name='spottag']">
                                <xsl:variable name="spottagId" select="." />
                                <span><xsl:value-of select="/result/tags/contents/content[@contenttype='Spottag' and @key=$spottagId]/name" /></span>
                                <xsl:choose>
                                     <xsl:when test="position()+1=$numberOfTags">
                                        <xsl:text> or </xsl:text>
                                    </xsl:when>
                                    <xsl:when test="not(position()=last())">
                                        <xsl:text>, </xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>.</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:if>
                    </p>
                    <p class="youMightAlsoLike blumancolor">Spots nearby -></p>
                </div>
                <div class="spots-nearby">
                    <ul id="sdt_menu" class="sdt_menu">
                        <xsl:apply-templates select="/result/spots-nearby/contents/content" mode="spots-nearby"/>
                    </ul>
                </div>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="content" mode="spots-nearby">
           <li class="spot-nearby">
                <a href="{portal:createContentUrl(@key,(''))}">
                    <img alt="{title}" src="{portal:createImageUrl(contentdata/image[1]/image/@key, 'scalesquare(170);rounded(2)')}" />
                    <span class="sdt_active"></span>
                    <span class="sdt_wrap">
                        <span class="sdt_link"><xsl:value-of select="display-name" /></span>
                        <span class="sdt_descr"><xsl:value-of select="location/site/contentlocation/@menuitemname" /> </span>
                    </span>
                </a>
            </li>
    </xsl:template>

    <xsl:template name="jquery-scripts">
        <script type="text/javascript">
            $(document).ready(function(){
                /**
                * for each menu element, on mouseenter,
                * we enlarge the image, and show both sdt_active span and
                * sdt_wrap span. If the element has a sub menu (sdt_box),
                * then we slide it - if the element is the last one in the menu
                * we slide it to the left, otherwise to the right
                */
                $('.spot-nearby').bind('mouseenter',function(){
					var $elem = $(this);
					$elem.find('img')
						 .stop(true)
						 .animate({
							'width':'170px',
							'height':'170px',
							'top':'85px',
                            'left':'0'
						 },400,'easeOutBack')
						 .andSelf()
						 .find('.sdt_active')
					     .stop(true)
						 .animate({'height':'170px'},300,function(){
                            var $sub_menu = $elem.find('.sdt_box');
                            if($sub_menu.length){
                                var left = '170px';
                                if($elem.parent().children().length == $elem.index()+1)
                                    left = '-170px';
                                $sub_menu.show().animate({'left':left},200);
                            }
					});
				}).bind('mouseleave',function(){
					var $elem = $(this);
					var $sub_menu = $elem.find('.sdt_box');
					if($sub_menu.length)
						$sub_menu.hide().css('left','0px');

					$elem.find('.sdt_active')
						 .stop(true)
						 .animate({'height':'0px'},300)
						 .andSelf().find('img')
						 .stop(true)
						 .animate({
							'width':'0px',
							'height':'0px',
							'left':'85px'},400)
						 .andSelf()
						 .find('.sdt_wrap')
						 .stop(true)
						 .animate({'top':'25px'},500);
				});
            });
        </script>
    </xsl:template>
</xsl:stylesheet>
