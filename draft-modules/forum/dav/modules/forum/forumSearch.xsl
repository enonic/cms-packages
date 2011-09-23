<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:saxon="http://icl.com/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xml" omit-xml-declaration="yes"/>
  <xsl:variable name="forumConfiguration" select="document('forumConfiguration.xml')"/>
  <xsl:variable name="searchPage" select="$forumConfiguration/properties/property[@key = 'searchResultPage']/@value"/>
  <xsl:template match="/">
    <div>
      <form action="page" method="get">
        <div>
          <input name="id" type="hidden" value="{$searchPage}"/>
          <input id="query" name="query" style="width: 67px;" type="text"
                 value="{/verticaldata/context/querystring/parameter[@name = 'query']}"/>
          <input class="search-button" type="submit" value="Search"/>
        </div>
      </form>
    </div>
  </xsl:template>
</xsl:stylesheet>