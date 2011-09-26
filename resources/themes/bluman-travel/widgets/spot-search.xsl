<xsl:stylesheet version="1.0"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:portal="http://www.enonic.com/cms/xslt/portal"
                xmlns:util="enonic:utilities"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="../../../libraries/utilities/standard-variables.xsl"/>

    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="/result/context/querystring/parameter[@name = 'ajaxsearch']">
                <input type="hidden" id="contentKey" value="{/result/random-spot/contents/content/@key}" />
                <input type="hidden" id="contentUrl" value="{portal:createContentUrl( /result/random-spot/contents/content/@key, '')}" />
            </xsl:when>
            <xsl:otherwise>
             <xsl:call-template name="spot-search" />
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="spot-search">
            <div id="bluman-form-container">
                <form id="bluman-form" method="post" action="">
                    <div id="appendRandomSpotHere"></div>
                    <fieldset>
                        <legend>Find <span class="bluman">Blumans</span> favourite spots in:</legend>
                        <select id="spot" name="spot" class="selectBox selectBox-dropdown">
                            <xsl:for-each select="/result/spots/menuitems/menuitem">
                                <optgroup label="{display-name}">
                                    <xsl:for-each select="menuitems/menuitem">
                                        <xsl:choose>
                                            <xsl:when test="display-name=/result/context/resource/display-name">
                                                <option selected="true" value="{name}"><xsl:value-of select="display-name" /></option>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <option value="{name}"><xsl:value-of select="display-name" /></option>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each>
                               </optgroup>
                            </xsl:for-each>
                        </select>
                        <input type="hidden" value="spottags" />
                    </fieldset>
                    <fieldset>
                    <legend>when he is looking for:</legend>
                    <xsl:for-each select="/result/tags/contents/content">
                        <div>
                            <input type="checkbox" name="spottag" value="{@key}" />
                            <span><xsl:value-of select="name" /></span>
                        </div>
                   </xsl:for-each>
                   <input type="hidden" id="spottags" name="spottags" />
                   <input type="hidden" id="country" name="country" />
                </fieldset>
                </form>
                <xsl:for-each select="/result/background-images/contents/relatedcontents/content[@contenttype='Image']">
                    <xsl:if test="position()=1">
                        <input type="hidden" id="backgroundImage" value="{portal:createImageUrl(@key, '')}" />
                    </xsl:if>
                </xsl:for-each>
                <div><a id="find_bluman_button" class="large blue awesome">Find Bluman</a></div>
                <div id="no-such-spots-message">Message goes here</div>
            </div>
        <xsl:call-template name="welcome-page-scripts" />
    </xsl:template>

    <xsl:template name="welcome-page-scripts">
            <xsl:variable name="windowKey" select="/result/context/window/@key"/>
            <xsl:variable name="portletKey" select="/result/context/window/portlet/@key"/>
            <xsl:variable name="portletUrl" select="portal:createWindowUrl($windowKey,(''))"/>
            <script  type="text/javascript">
                $(document).ready(function(){
                    changeBkg($('#backgroundImage').val());
                    function changeBkg(url){
                        $('#background').css("background-image",'url('+url+')');
                        $('#background').css("background-size",'cover');
                    }
                    $('#spot').selectBox();
                    /*Maintain a comma separated list of spottags used in datasource to filter random spot when form is submitted*/
                    $('#bluman-form :checkbox').click(function(){
                        $('#spottags').val('');
                        $('#bluman-form :checkbox:checked').each(function(){
                            if(!$('#spottags').val())
                                $('#spottags').val($('#spottags').val() + $(this).val());
                            else
                                $('#spottags').val($('#spottags').val() + ',' + $(this).val());
                        });
                    });
                    /*Submit ajax query to find random spot (contentKey) in selected city, we need this to get correct http url for spot*/
                    $("#find_bluman_button").click(function() {
                        /*Set country from optgroup (parent of selected city) in selectbox*/
                        $("#bluman-form #spot ").find("option:selected").each(function(){
                            $('#bluman-form #country').val($(this).parent().attr("label").toLowerCase());
                        });
                        $.get("<xsl:value-of select="$portletUrl" />", {country: $('#bluman-form #country').val(), spottags: $('#bluman-form #spottags').val(), spot: $('#bluman-form #spot').val(), ajaxsearch: "true"},
                           function(data){
                                $('#appendRandomSpotHere').children('input').remove();
                                $('#appendRandomSpotHere').append(data);
                                if (!$('#contentKey').val()){
                                    $('#no-such-spots-message').html("<p>There is no such spots! Try to tick of more interests, or none at all.</p>");
                                    $('#no-such-spots-message').css({opacity: 0.0, visibility: "visible"}).animate({opacity: 1.0}, 3500).animate({opacity:0}, 3500);
                                }else{
                                    $('#bluman-form').attr('action', $('#contentUrl').val());
                                    $('#bluman-form').submit();
                                }
                           }
                        );
                    });
                 });
            </script>
    </xsl:template>
</xsl:stylesheet>