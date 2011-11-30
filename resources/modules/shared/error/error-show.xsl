<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
    xmlns="http://www.w3.org/1999/xhtml" version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fw="http://www.enonic.com/cms/xslt/framework"
    xmlns:portal="http://www.enonic.com/cms/xslt/portal"
    xmlns:util="http://www.enonic.com/cms/xslt/utilities">    
    
    <xsl:import href="/libraries/utilities/fw-variables.xsl"/>
    <xsl:import href="/libraries/utilities/error.xsl"/>
    
    <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>
    
    <xsl:template match="/">
        <xsl:call-template name="util:error.handle"/>
    </xsl:template>
    
</xsl:stylesheet>
