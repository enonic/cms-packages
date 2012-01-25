<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:util="enonic:utilities" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:import href="/libraries/utilities/fw-variables.xsl"/>
    <!--<xsl:include href="/libraries/utilities/utilities.xsl"/>-->

    <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>

    <xsl:param name="facebook-share-url" select="'http://www.facebook.com/share.php?u='"/>
    <xsl:param name="twitter-share-url" select="'http://twitter.com/home?status='"/>
    <xsl:param name="digg-share-url" select="'http://digg.com/submit?phase=2'"/>
    <xsl:param name="delicious-share-url" select="'http://del.icio.us/post'"/>

    <xsl:variable name="site-name" select="/result/context/site/name"/>
    <xsl:variable name="current-url" select="/result/context/querystring/@url"/>

    <xsl:template match="/">
            <ul class="share-bar vertical">
                <li class="twitter">
                    <div>
                        <a href="https://twitter.com/share" class="twitter-share-button" data-count="horizontal">Tweet</a><script type="text/javascript" src="//platform.twitter.com/widgets.js"></script>
                    </div>
                </li>
                <li class="googleplus">
                    <div>
                        <div class="g-plusone" data-size="medium"></div>
                        <script type="text/javascript">
                          (function() {
                            var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
                            po.src = 'https://apis.google.com/js/plusone.js';
                            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
                          })();
                        </script>
                    </div>
                </li>
                <li class="fblike">
                    <div>
                        <div class="fb-like" data-href="{$current-url}" data-send="false" data-layout="button_count" data-width="25" data-show-faces="false"></div>
                        <div id="fb-root"></div>
                        <script>(function(d, s, id) {
                          var js, fjs = d.getElementsByTagName(s)[0];
                          if (d.getElementById(id)) {return;}
                          js = d.createElement(s); js.id = id;
                          js.src = "//connect.facebook.net/nb_NO/all.js#xfbml=1";
                          fjs.parentNode.insertBefore(js, fjs);
                          }(document, 'script', 'facebook-jssdk'));</script>
                    </div>
                </li>
            </ul>
    </xsl:template>

</xsl:stylesheet>
