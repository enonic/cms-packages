<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:util="enonic:utilities" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:output encoding="utf-8" indent="yes" method="xhtml" omit-xml-declaration="yes"/>

  <xsl:include href="/modules/library-utilities/utilities.xsl"/>
  <xsl:include href="/modules/library-utilities/xhtml.xsl"/>

  <xsl:param as="xs:integer" name="region-width" select="325"/>
  <xsl:param as="xs:integer" name="region-width-right" select="163"/>

  <xsl:variable name="text" select="/result/contents[1]/content[1]"/>
  <xsl:variable name="language" select="/result/context/@languagecode"/>

  <xsl:template match="/">
    <html lang="en" xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <title>Newsletter - Enonic Travels</title>
        <style type="text/css">
          body {
              background-color: #eeece5;
              font-size: 12px;
              line-height: 16px;
              color: #332f2d;
              margin: 0;
              padding: 20px;
              font-family: 'Trebuchet MS', Verdana, Arial, Helvetica, sans-serif;
          }
          td {
              padding:0;
          }
          td, p {
              font-size: 12px;
              line-height: 16px;
              color: #332f2d;
              font-family: 'Trebuchet MS', Verdana, Arial, Helvetica, sans-serif;
          }
          img {
              border:0px;
          }
          a img {
              border:0px;
          }
          a {
              color:#335ab3;
              text-decoration:underline;
          }
          h1 {
              font-size:28px;
              line-height:32px;
              margin-top:0;
              font-weight:normal;
          }
          h2 {
              font-size:18px;
              font-weight:normal;
              line-height:22px;
              margin:0 0 4px 0;
              font-weight:normal;
          }
          h3 {
              font-size:16px;
              font-weight:normal;
          }
          h4 {
              font-size:14px;
              margin-bottom:0;
              font-weight:500;
          }
          h5 {
              font-size:13px;
              font-weight:500;
              margin:7px 0 3px
          }
          h6 {
              font-size:12px;
          }
          h1, h2, h3, h4 {
              font-family:Georgia,Times,serif;
              color:#332f2d;
          }
          p.preface {
              font-size:16px;
              line-height:20px;
              font-weight:normal;
              font-family:Georgia,Times,serif;
              color:#332f2d;
          }
          table.tbl-main {
              border:7px solid #332f2d;
              border-collapse:collapse;
              border-spacing:0;
          }
          table.tbl-main table {
              border:none;
              border-collapse:collapse;
              border-spacing:0;
          }
          table.tbl-main table td {
              border:none;
              border-collapse:collapse;
              border-spacing:0;
          }
          table.tbl-main td {
              border:7px solid #332f2d;
              border-collapse:collapse;
              border-spacing:0;
              padding:0;
          }
          table.tbl-main td div.upper {
              padding:15px 20px;
          }
          table.tbl-main td div.inner {
              padding:15px;
          }
          table.tbl-main td div.inner h4 {
              margin-top:0;
              margin-bottom:14px;
          }
          table.tbl-main td div.inner p {
              margin:0;
          }
          table.tbl-main table.tbl-event {
              border:1px solid #4b72be;
          }
          .date {
              font-weight: bold;
              text-decoration: none;
          }
          .day {
              color: #4b72bf;
              text-align: center;
              font-size: 14px;
              display:block;
          }
          .month {
              color: #ffffff;
              text-align: center;
              text-transform: uppercase;
              display:block;
          }</style>
      </head>
      <body leftmargin="0" marginwidth="0" topmargin="0" marginheight="0" offset="0" bgcolor="#EEECE5">

        <table width="100%" cellpadding="0" cellspacing="0" bgcolor="#EEECE5">
          <tr>
            <td valign="top" align="center">

              <table width="600" cellpadding="0" cellspacing="0" style="border:7px solid #332f2d" class="tbl-main">
                <tr>
                  <td colspan="2" align="left" valign="middle" width="600">
                    <a href="{portal:createUrl('/')}">
                      <IMG SRC="{portal:createResourceUrl('/_public/modules/newsletter/images/newsletter-heading.jpg')}" width="586" height="87" BORDER="0" title="Enonic Travels" alt="Enonic Travels" align="center"/>
                    </a>
                  </td>
                </tr>

                <tr>
                  <td bgcolor="#FFFFFF" rowspan="2" valign="top" width="400">
                    <table width="100%" cellspacing="0" cellpadding="20" border="0" style="border:none;">
                      <tr>
                        <td valign="top" align="left" style="padding:20px;">
                          <!-- <div class="upper">-->
                          <!-- Nyhetsbrevtekst her -->
                          <h1>
                            <xsl:value-of select="$text/title"/>
                          </h1>
                          <xsl:if test="contentdata/preface">
                            <p class="preface">
                              <span class="byline">
                                <xsl:value-of select="util:format-date(@publishfrom, $language, 'short', true())"/>
                              </span>
                              <xsl:value-of disable-output-escaping="yes" select="replace(contentdata/preface, '\n', '&lt;br /&gt;')"/>
                            </p>
                          </xsl:if>
                          <xsl:call-template name="related-content">
                            <xsl:with-param name="size" select="'regular'"/>
                          </xsl:call-template>
                          <xsl:if test="$text/contentdata/text/*|$text/contentdata/text/text()">
                            <div>
                              <xsl:call-template name="xhtml.process">
                                <xsl:with-param name="document" select="$text/contentdata/text"/>
                                <xsl:with-param name="image" tunnel="yes" select="/result/contents/relatedcontents/content"/>
                              </xsl:call-template>
                            </div>
                          </xsl:if>
                          <!--</div>-->
                        </td>
                      </tr>
                    </table>
                  </td>
                  <td width="200" valign="top" style="background-color:#FFFFFF;">
                    <table width="100%" cellspacing="0" cellpadding="15" border="0" style="border:none;">
                      <tr>
                        <td valign="top" align="left" style="padding:15px;">
                          <!-- <div class="inner">-->
                          <h2>Latest news</h2>
                          <xsl:apply-templates select="/result/contents[2]/content" mode="latest-articles"/>
                          <!-- </div>-->
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr>
                  <td width="200" valign="top" style="background-color:#FFFFFF;">
                    <table width="100%" cellspacing="0" cellpadding="15" border="0" style="border:none;">
                      <tr>
                        <td valign="top" align="left" style="padding:15px;">
                          <h2>Next events</h2>
                          <table cellpadding="5" cellspacing="0">
                            <xsl:apply-templates select="/result/contents[3]/content" mode="next-events"/>
                          </table>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>

            </td>
          </tr>
        </table>

      </body>
    </html>

  </xsl:template>

  <xsl:template match="content" mode="latest-articles">
    <xsl:if test="/result/contents/relatedcontents/content[@key = current()/contentdata/image[1]/image/@key]">
      <a href="{portal:createContentUrl(@key,())}" title="{title}">
        <xsl:call-template name="image.display-image">
          <xsl:with-param name="size" select="'wide'"/>
          <xsl:with-param name="image" select="/result/contents/relatedcontents/content[@key = current()/contentdata/image[1]/image/@key]"/>
        </xsl:call-template>
      </a>
    </xsl:if>
    <p>
      <span class="byline">
        <xsl:value-of select="util:format-date(@publishfrom, $language, 'short', true())"/>
      </span>
    </p>
    <h4>
      <a href="{portal:createContentUrl(@key,())}">
        <xsl:value-of select="title"/>
      </a>
    </h4>
  </xsl:template>

  <xsl:template match="content" mode="next-events">
    <xsl:variable name="start-date" select="contentdata/start-date"/>
    <tr>
      <td width="50" align="left">
        <table width="38" class="tbl-event" cellspacing="0" cellpadding="0" border="1" bgcolor="#4b72bf" style="border:1px solid #4b72bf;">
          <tr>
            <td valign="middle" align="center" width="100%" height="25" bgcolor="#4b72bf" style="background-color:#4b72bf;">
              <table cellpadding="0" cellspacing="0" width="36" height="24" bgcolor="#ffffff">
                <tr>
                  <td bgcolor="#ffffff" valign="middle" align="center">
                    <a href="{portal:createContentUrl(@key)}" title="{title}" class="date" style="color:#4b72bf;">
                      <span class="day">
                        <xsl:value-of select="day-from-date(xs:date($start-date))"/>
                      </span>
                    </a>
                  </td>
                </tr>
              </table>

            </td>
          </tr>
          <tr>
            <td valign="middle" align="center" width="100%" height="15" bgcolor="#4b72bf" style="background-color:#4b72bf;color:#fff;">
              <a href="{portal:createContentUrl(@key)}" title="{title}" class="date" style="color:#ffffff;">
                <span class="month" style="color:#fff">
                  <xsl:value-of select="format-date(xs:date($start-date), '[MN,*-3]', $language, (), ())"/>
                </span>
              </a>
            </td>
          </tr>
        </table>
      </td>
      <td valign="middle">
        <h4>
          <a href="{portal:createContentUrl(@key)}">
            <xsl:value-of select="title"/>
          </a>
        </h4>
      </td>
    </tr>
    <tr>
      <td colspan="2">&#160;</td>
    </tr>
  </xsl:template>

  <xsl:template match="content" mode="next-events-old">
    <xsl:variable name="start-date" select="contentdata/start-date"/>
    <div class="item">
      <a href="{portal:createContentUrl(@key)}" title="{title}" class="date">
        <span class="day">
          <xsl:value-of select="day-from-date(xs:date($start-date))"/>
        </span>
        <span class="month">
          <xsl:value-of select="format-date(xs:date($start-date), '[MN,*-3]', $language, (), ())"/>
        </span>
      </a>
      <h4>
        <a href="{portal:createContentUrl(@key)}">
          <xsl:value-of select="title"/>
        </a>
      </h4>
    </div>
  </xsl:template>

  <xsl:template name="related-content">
    <xsl:param name="size"/>
    <xsl:param name="start" select="1"/>
    <xsl:if test="/result/contents/relatedcontents/content[@key = current()/contentdata/image[1]/image/@key] or contentdata/link/url != '' or /result/contents/relatedcontents/content[@key = current()/contentdata/articles/content/@key] or /result/contents/relatedcontents/content[@key = current()/contentdata/file/file/file/@key]">
      <div class="related" style="float:right;margin-left:20px;">

        <xsl:if test="/result/contents/relatedcontents/content[@key = current()/contentdata/image[1]/image/@key]">
          <xsl:for-each select="contentdata/image[1 and image/@key = /result/contents/relatedcontents/content/@key]">
            <div class="image">
              <xsl:call-template name="image.display-image">
                <xsl:with-param name="image" select="/result/contents/relatedcontents/content[@key = current()/image/@key]"/>
                <xsl:with-param name="size" select="$size"/>
              </xsl:call-template>
              <xsl:value-of select="image_text"/>
            </div>
          </xsl:for-each>
        </xsl:if>
        <xsl:if test="contentdata/link/url != ''">
          <h4>Related links</h4>
          <ul>
            <xsl:for-each select="contentdata/link[url != '']">
              <li>
                <a href="{url}">
                  <xsl:if test="target = 'new'">
                    <xsl:attribute name="rel">external</xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="if (description != '') then description else url"/>
                </a>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:if>
        <xsl:if test="/result/contents/relatedcontents/content[@key = current()/contentdata/articles/content/@key]">
          <h4>Related articles</h4>
          <ul>
            <xsl:for-each select="contentdata/articles/content[@key = /result/contents/relatedcontents/content/@key]">
              <xsl:variable name="current-article" select="/result/contents/relatedcontents/content[@key = current()/@key]"/>
              <li>
                <a href="{portal:createContentUrl($current-article/@key, ())}">
                  <xsl:value-of select="$current-article/title"/>
                </a>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:if>
        <xsl:if test="/result/contents/relatedcontents/content[@key = current()/contentdata/file/file/file/@key]">
          <h4>Related files</h4>
          <ul>
            <xsl:for-each select="contentdata/file/file/file[@key = /result/contents/relatedcontents/content/@key]">
              <xsl:variable name="current-file" select="/result/contents/relatedcontents/content[@key = current()/@key]"/>
              <li>
                <a href="{portal:createBinaryUrl($current-file/contentdata/binarydata/@key, ('download', 'true'))}">
                  <xsl:call-template name="utilities.icon-image">
                    <xsl:with-param name="file-name" select="$current-file/title"/>
                  </xsl:call-template>
                  <xsl:value-of select="$current-file/title"/>
                </a>
                <xsl:value-of select="concat(' (', util:format-bytes($current-file/binaries/binary/@filesize), ')')"/>
                <xsl:if test="$current-file/contentdata/description != ''">
                  <br/>
                  <xsl:value-of select="util:crop-text($current-file/contentdata/description, 200)"/>
                </xsl:if>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:if>
      </div>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
