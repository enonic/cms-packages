<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0"
                xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:saxon="http://saxon.sf.net/"
                xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xml"/>
  <xsl:variable name="forumConfiguration" select="document('forumConfiguration.xml')"/>
  <xsl:param name="from_name" select="'MySite Forum'"/>
  <xsl:param name="from_email" select="'me@mysite.com'"/>
  <xsl:param name="standard_receiver" select="'tsi@enonic.com'"/>
  <xsl:variable name="successPage" select="$forumConfiguration/properties/property[@key = 'reportSuccessPage']/@value"/>
  <xsl:variable name="errorPage" select="$forumConfiguration/properties/property[@key = 'reportErrorPage']/@value"/>
  <xsl:variable name="totalCount" select="/verticaldata/contents/@totalcount"/>
  <xsl:variable name="contentCount" select="count(/verticaldata/contents/content)"/>
  <xsl:variable name="key" select="/verticaldata/context/querystring/parameter[@name = 'key']"/>
  <xsl:variable name="categoryInfo"
                select="saxon:parse(concat('&lt;info>', /verticaldata/categories/category/description, '&lt;/info>'))"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="/verticaldata/contents/content">
        <div class="threadtitle">
          <strong>
            Report this posting to the forum moderators:
          </strong>
          <br/>
          <xsl:value-of select="/verticaldata/contents/content/title"/>
        </div>
        <xsl:variable name="redirectUrl" select="concat('page?id=',$successPage,'&amp;success=true')"/>
        <form action="{portal:createServicesUrl('sendmail','send', $redirectUrl, ())}" method="post">
          <div>
            <strong>
              <xsl:text>Your comment: </xsl:text>
            </strong>
            <br/>
            <textarea name="Comment">
              <xsl:text> </xsl:text>
            </textarea>
            <br/>
            <xsl:choose>
              <xsl:when test="$categoryInfo/info/receivers/receiver">
                <xsl:for-each select="$categoryInfo/info/receivers/receiver">
                  <input name="to" type="hidden" value="{.}"/>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <input name="to" type="hidden" value="{$standard_receiver}"/>
              </xsl:otherwise>
            </xsl:choose>
            <input name="from_email" type="hidden" value="{$from_email}"/>
            <input name="from_name" type="hidden" value="{$from_name}"/>
            <input name="sort_order" type="hidden" value="Posting,Category,Key,Reporter,Comment"/>
            <input name="subject" type="hidden" value="Bad forum posting reported"/>
            <input name="Key" type="hidden" value="{$key}"/>
            <input name="Posting" type="hidden" value="{/verticaldata/contents/content/title}"/>
            <input name="Category" type="hidden" value="{/verticaldata/categories/category/@name}"/>
            <input name="Reporter" type="hidden" value="{/verticaldata/context/user/@fullname}"/>
            <input name="Send" type="submit" value="Report"/>
          </div>
        </form>
      </xsl:when>
      <xsl:when test="/verticaldata/context/querystring/parameter[@name = 'success'] = 'true'">
        <div class="threadtitle">
          <strong>
            Thank you for submitting your report.
          </strong>
          <br/>
          <a href="javascript:window.close();">
            Close window
          </a>
        </div>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>