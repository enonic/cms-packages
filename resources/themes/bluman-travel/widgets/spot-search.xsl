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
                            <option value="">Select city</option>
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
                    </fieldset>
                    <span>
                        <input type="hidden" id="spottags" name="spottags" />
                        <input type="hidden" id="country" name="country" />
                    </span>
                </form>
                <div>when he is looking for:</div>
                <xsl:for-each select="/result/tags/contents/content">
                    <div>
                        <input type="checkbox" value="{@key}" />
                        <span><xsl:value-of select="name" /></span>
                    </div>
               </xsl:for-each>
                <div><a id="find_bluman_button" class="large blue awesome">Find Bluman</a></div>
                <div id="no-such-spots-message">Message goes here</div>
            </div>
        <xsl:call-template name="spot-search-scripts" />
    </xsl:template>

    <xsl:template name="spot-search-scripts">

            <script  type="text/javascript">
              $(document).ready(function(){
                    $('#spot').selectBox();
                    /*Maintain a comma separated list of spottags used in datasource to filter random spot when form is submitted*/
                    $('#bluman-form-container :checkbox').click(function(){
                        $('#spottags').val('');
                        $('#bluman-form-container :checkbox:checked').each(function(){
                            if(!$('#spottags').val())
                                $('#spottags').val($('#spottags').val() + $(this).val());
                            else
                                $('#spottags').val($('#spottags').val() + ',' + $(this).val());
                        });
                    });

                    <xsl:variable name="windowKey" select="/result/context/window/@key"/>
                    <xsl:variable name="portletKey" select="/result/context/window/portlet/@key"/>
                    <xsl:variable name="portletUrl" select="portal:createWindowUrl($windowKey,(''))"/>
                    /*Submit ajax query to find random spot (contentKey) in selected city, we need this to get correct http url for spot*/
                    $("#find_bluman_button").click(function() {
                         if ($("#bluman-form #spot ").find("option:selected").val()!=''){
                            /*Set country from optgroup (parent of selected city) in selectbox*/
                            $("#bluman-form #spot ").find("option:selected").each(function(){
                                $('#bluman-form #country').val($(this).parent().attr("label").toLowerCase());
                            });
                            $.get("<xsl:value-of select="$portletUrl" />", {country: $('#bluman-form #country').val(), spottags: $('#bluman-form #spottags').val(), spot: $('#bluman-form #spot').val(), ajaxsearch: "true"},
                               function(data){
                                    $('#appendRandomSpotHere').children('input').remove();
                                    $('#appendRandomSpotHere').append(data);
                                    if (!$('#contentKey').val()){
                                        jAlert('No spots found, try a new search!', 'No spots');
                                    }else{
                                        $('#bluman-form').attr('action', $('#contentUrl').val());
                                        $('#bluman-form').submit();
                                    }
                               }
                            );
                        }
                        else{
                            jAlert('No city selected!', 'Error');
                        }
                    });
                 });
            </script>
    </xsl:template>
</xsl:stylesheet>