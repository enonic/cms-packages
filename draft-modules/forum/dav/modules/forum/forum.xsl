<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="portal" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>

  <xsl:template match="/">
    <div id="forum">
      <xsl:choose>
        <!-- Posting list -->
        <xsl:when test="/result/context/querystring/parameter[@name = 'topicKey'] != ''"> posting list </xsl:when>
        <!-- Topic list -->
        <xsl:when test="/result/context/querystring/parameter[@name = 'categoryKey'] != ''">
          <xsl:choose>
            <xsl:when test="/result/topics/contents/content">
              <h2>
                <xsl:value-of select="portal:localize('Topics')"/>
              </h2>
              <table>
                <thead>
                  <tr>
                    <th class="icons">
                      <xsl:comment>//</xsl:comment>
                    </th>
                    <th>
                      <xsl:value-of select="portal:localize('Topic')"/>
                    </th>
                    <th class="postings">
                      <xsl:value-of select="portal:localize('Postings')"/>
                    </th>
                    <th>
                      <xsl:value-of select="portal:localize('Started')"/>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <xsl:apply-templates select="/result/topics/contents/content" mode="categories"/>
                </tbody>
              </table>
            </xsl:when>
            <xsl:otherwise>
              <p>
                <xsl:value-of select="portal:localize('forum-no-topics')"/>
              </p>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <!-- Category list -->
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="/result/categories/contents/content">
              <table>
                <thead>
                  <tr>
                    <th class="icons">
                      <xsl:comment>//</xsl:comment>
                    </th>
                    <th>
                      <xsl:value-of select="portal:localize('Categories')"/>
                    </th>
                    <!--th>
                      <xsl:value-of select="portal:localize('Topics')"/>
                      </th-->
                    <th class="postings">
                      <xsl:value-of select="portal:localize('Postings')"/>
                    </th>
                    <!--th>
                      <xsl:value-of select="portal:localize('Latest-posting')"/>
                      </th-->
                  </tr>
                </thead>
                <tbody>
                  <xsl:apply-templates select="/result/categories/contents/content" mode="categories"/>
                </tbody>
              </table>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="portal:localize('forum-no-categories')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>

  <xsl:template match="content" mode="categories">
    <xsl:variable name="href" select="portal:createPageUrl(('categoryKey', @key))"/>
    <tr>
      <xsl:if test="position() mod 2 = 0">
        <xsl:attribute name="class">highlight</xsl:attribute>
      </xsl:if>
      <td>
        <a href="{$href}">
          <!-- Bruke config her!!
          <img class="icon" alt="{concat(portal:localize('Folder'), ' ', portal:localize('icon'))}" src="{portal:createResourceUrl('/_public/sites/advanced/images/icon-folder.png')}"/>
          -->
        </a>
      </td>
      <td>
        <a href="{$href}">
          <h2>
            <xsl:value-of select="title"/>
          </h2>
        </a>
        <p>
          <xsl:value-of select="contentdata/description"/>
        </p>
      </td>
      <!--td>
        ant tråder<br/>
        <xsl:value-of select="relatedcontentkeys/count"/>
      </td-->
      <td class="postings">
        <xsl:value-of select="relatedcontentkeys/@count"/>
      </td>
      <!--td>
        siste innlegg
      </td-->
    </tr>
  </xsl:template>

</xsl:stylesheet>
