<?xml version="1.0" encoding="UTF-8"?>

<!--
   **************************************************
   
   error.xsl
   version: ###VERSION-NUMBER-IS-INSERTED-HERE###
   
   **************************************************
-->

<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:fw="http://www.enonic.com/cms/xslt/framework"
   xmlns:portal="http://www.enonic.com/cms/xslt/portal"
   xmlns:util="http://www.enonic.com/cms/xslt/utilities">
   
   <xsl:import href="/libraries/utilities/fw-variables.xsl"/>

   <xsl:template name="util:error.handle">
      <xsl:variable name="error" as="element()?" select="$fw:querystring-parameter[@name = 'http_status_code']"/>
      <xsl:variable name="url" as="xs:string?" select="/result/context/querystring/@url"/>
      <xsl:variable name="exception-message" as="xs:string?" select="$fw:querystring-parameter[@name = 'exception_message']"/>
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
      <xsl:if test="string($fw:site-admin-name) and string($fw:site-admin-email)">
         <p>
            <xsl:value-of select="concat(portal:localize('fatal-error-general-text'), ' ')"/>
            <a href="mailto:{$fw:site-admin-email}">
               <xsl:value-of select="$fw:site-admin-name"/>
            </a>
         </p>
      </xsl:if>
   </xsl:template>

</xsl:stylesheet>
