<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">

   <xsl:template name="error-handler.error-handler">
      <xsl:param name="error" as="element()?"/>
      <xsl:param name="url" as="xs:string?"/>
      <xsl:param name="exception-message" as="xs:string?"/>
      <xsl:param name="admin-name" as="xs:string"/>
      <xsl:param name="admin-email" as="xs:string"/>
      <div class="error">
         <h2>
            <xsl:value-of select="portal:localize(concat('fatal-error-heading-', $error))"/>
         </h2>
         <p>
            <xsl:value-of select="portal:localize(concat('fatal-error-', $error))"/>
            <xsl:if test="$exception-message != ''">
               <br/>
               <strong>Exeption message: </strong>
               <xsl:value-of select="$exception-message"/>
            </xsl:if>
            <xsl:if test="$url != ''">
               <br/>
               <strong>URL: </strong>
               <xsl:value-of select="$url"/>
            </xsl:if>
         </p>
      </div>
      <p>
         <xsl:value-of select="concat(portal:localize('fatal-error-general-text'), ' ')"/>
         <a href="mailto:{$admin-email}">
            <xsl:value-of select="$admin-name"/>
         </a>
      </p>
   </xsl:template>

</xsl:stylesheet>
