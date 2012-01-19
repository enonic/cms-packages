<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9  http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">

  <xsl:output encoding="UTF-8" indent="yes" method="xml" omit-xml-declaration="no"/>

  <xsl:param name="default-google-changefreq" select="'weekly'"/>

  <!--
    
    Override default change frequency for a single page by adding the page parameter 'google-changefreq' to that page.
    Valid values are: 'always', 'hourly', 'daily', 'weekly', 'monthly', 'yearly', 'never'
    
    Override default priority for a single page by adding the page parameter 'google-priority' to that page.
    Valid values range from 0.0 to 1.0. The default priority of a page is 0.5.
    
  -->

  <xsl:template match="/">
    <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
      <xsl:apply-templates select="/result/contents/content | /result/menus/menu/menuitems/menuitem[not(@type = 'label' or @type = 'section')]"/>
    </urlset>
  </xsl:template>

  <xsl:template match="menuitem | content">
    <url>
      <loc>
        <xsl:value-of select="if (name() = 'content') then portal:createContentUrl(@key, ()) else portal:createPageUrl(@key, ())"/>
      </loc>
      <lastmod>
        <xsl:value-of select="dateTime(xs:date(tokenize(@timestamp, '\s+')[1]), xs:time(concat(tokenize(@timestamp, '\s+')[2], ':00Z')))"/>
      </lastmod>
      <changefreq>
        <xsl:value-of select="if (parameters/parameter[@name = 'google-changefreq'] != '') then parameters/parameter[@name = 'google-changefreq'] else $default-google-changefreq"/>
      </changefreq>
      <xsl:if test="parameters/parameter[@name = 'google-priority'] != ''">
        <priority>
          <xsl:value-of select="parameters/parameter[@name = 'google-priority']"/>
        </priority>
      </xsl:if>
    </url>
    <xsl:if test="menuitems/menuitem[not(@type = 'label' or @type = 'section')]">
      <xsl:apply-templates select="menuitems/menuitem[not(@type = 'label' or @type = 'section')]"/>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
