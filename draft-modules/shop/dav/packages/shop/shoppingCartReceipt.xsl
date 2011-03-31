<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="xs portal" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>
  <xsl:template match="/">
    <h1>Receipt</h1>
    <p>
      Thank you. Your order is received
    </p>
    <p>
      The order number is: <xsl:value-of select="/verticaldata/context/querystring/parameter[@name = 'key']"/>
    </p>
  </xsl:template>
</xsl:stylesheet>