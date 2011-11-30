<?xml version="1.0" encoding="UTF-8"?>

<!--
    **************************************************
    
    google.xsl
    version: ###VERSION-NUMBER-IS-INSERTED-HERE###
    
    **************************************************
-->

<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fw="http://www.enonic.com/cms/xslt/framework"
    xmlns:util="http://www.enonic.com/cms/xslt/utilities">
    
    <xsl:import href="/libraries/utilities/utilities.xsl"/>
    
    <xsl:template name="util:google.analytics">
        <xsl:variable name="google-analytics-tracker" select="util:get-scoped-parameter('google-analytics-tracker', $fw:path, $fw:config-parameter)" as="xs:string?"/>
        <xsl:if test="$google-analytics-tracker != ''">
            <script type="text/javascript">
                var _gaq = _gaq || [];
                _gaq.push(['_setAccount', '<xsl:value-of select="$google-analytics-tracker"/>']);
                _gaq.push(['_trackPageview']);

                (function() {
                  var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
                  ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
                  var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
                })();
            </script>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>