<xsl:stylesheet version="1.0"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:portal="http://www.enonic.com/cms/xslt/portal"
                xmlns:util="enonic:utilities"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="/libraries/utilities/standard-variables.xsl"/>

    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="/result/context/querystring/parameter[@name = 'ajaxsearch']">
                <xsl:variable name="randomContentKey" select="/result/random-spot/contents/content/@key" />
                <xsl:variable name="spot" select="/result/context/querystring/parameter[@name='spot']" />
                <xsl:variable name="country" select="/result/context/querystring/parameter[@name='country']" />
                <xsl:variable name="spottags" select="/result/context/querystring/parameter[@name='spottags']" />
                <xsl:variable name="contentRedirectUrl">
                    <xsl:choose>
                        <xsl:when test="$spottags!=''">
                            <xsl:value-of select="portal:createContentUrl( $randomContentKey, ('spottags',$spottags,'country',$country,'spot',$spot))" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="portal:createContentUrl( $randomContentKey, ('country',$country,'spot',$spot))" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <div id="contentRedirectUrl"><xsl:value-of select="$contentRedirectUrl" /></div>
            </xsl:when>
            <xsl:otherwise>
             <xsl:call-template name="welcome-page" />
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="welcome-page">
            <div id="bluman-form">
                <fieldset>
                    <legend>Find <span class="bluman">Blumans</span> favourite spots in:</legend>
                    <select id="spot-select" name="spot-select">
                        <xsl:for-each select="/result/spots/menuitems/menuitem">
                            <optgroup label="{display-name}">
                                <xsl:for-each select="menuitems/menuitem">
                                    <option value="{name}"><xsl:value-of select="display-name" /></option>
                                </xsl:for-each>
                            </optgroup>
                        </xsl:for-each>
                    </select>
                </fieldset>
                <fieldset>
                    <legend>when he is looking for:</legend>
                    <select id="spottags-select" name="spottags-select">
                        <xsl:for-each select="/result/tags/contents/content">
                            <option value="{@key}"><xsl:value-of select="display-name" /></option>
                        </xsl:for-each>
                    </select>
                </fieldset>
                <a id="find_bluman_button" class="large blue awesome">Find Bluman</a>
                <!--<a href="#" id="find_blueman"><img src="{portal:createResourceUrl(concat($theme-public, '/images/find_blueman_submit_button.png'))}" alt="" /></a>-->
                <span id="contentRedirectUrl" style="visibility: hidden;"></span>
            </div>
        <xsl:call-template name="welcome-page-scripts" />
    </xsl:template>

    <xsl:template name="welcome-page-scripts">
            <xsl:variable name="windowKey" select="/result/context/window/@key"/>
            <xsl:variable name="portletKey" select="/result/context/window/portlet/@key"/>
            <xsl:variable name="portletUrl" select="portal:createWindowUrl($windowKey,(''))"/>
            <script  type="text/javascript">
                $(document).ready(function(){
                    $("#spot-select").multiselect({
                        header: "Find bluman in:",
                        multiple: false,
                        header: "Select a city",
                        noneSelectedText: "Select destination city",
                        selectedList: 1
                    });

                    $("#spottags-select").multiselect({
                        header: "Tick off all your interests",
                        noneSelectedText: "Select interests here"
                    });

                    $("#find_bluman_button").click(function() {
                        var country;
                        $("#spot-select").find("option:selected").each(function(){
                            country = $(this).parent().attr("label").toLowerCase();
                        });
                        var spottags = escape($("#spottags-select").multiselect("getChecked").map(function(){
                           return this.value.toLowerCase();
                        }).get());
                        $.get("<xsl:value-of select="$portletUrl" />", {country: country, spottags: spottags, spot: $("#spot-select").val(), ajaxsearch: "true"},
                           function(data){
                                $('#contentRedirectUrl').html(data);
                                window.location = $('#contentRedirectUrl').text();
                           }
                        );
                    });
                 });
            </script>
    </xsl:template>
</xsl:stylesheet>