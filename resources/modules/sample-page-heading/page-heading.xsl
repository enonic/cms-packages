<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:fw="http://www.enonic.com/cms/xslt/framework"
   xmlns:util="http://www.enonic.com/cms/xslt/utilities">

   <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>

   <xsl:include href="/modules/library-utilities/fw-variables.xsl"/>
   <xsl:include href="/modules/library-utilities/system.xsl"/>

   <xsl:template match="/">
      <h1>
         <xsl:value-of select="util:menuitem-name(/result/context/resource)"/>
      </h1>
   </xsl:template>

</xsl:stylesheet>
