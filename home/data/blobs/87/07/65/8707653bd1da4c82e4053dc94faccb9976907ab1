<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- Google analytics -->
    <xsl:template name="google-analytics.google-analytics">
        <xsl:param name="google-tracker"/>
        <script type="text/javascript">
            var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
            document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
        </script>
        <script type="text/javascript">
            try {
            <xsl:value-of select="concat('var pageTracker = _gat._getTracker(&quot;', $google-tracker, '&quot;);')"/>
            pageTracker._trackPageview();
            } catch(err) {}
        </script>
    </xsl:template>

</xsl:stylesheet>
