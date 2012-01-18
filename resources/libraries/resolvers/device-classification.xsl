<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" media-type="text" method="text" omit-xml-declaration="yes"/>
  <xsl:template match="/">
    <xsl:variable name="user-agent" select="lower-case(/context/request/user-agent)"/>
    <xsl:choose>
      <xsl:when test="matches($user-agent, 'windows ce; ppc;|windows ce; smartphone;|windows ce; iemobile|palm os|palm|hiptop|avantgo|plucker|xiino|blazer|elaine|iphone|android|opera mini|blackberry|up.browser|up.link|mmp|symbian|smartphone|midp|wap|vodafone|o2|pocket|kindle|mobile|pda|psp|treo')">
        <xsl:text>mobile</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>pc</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
