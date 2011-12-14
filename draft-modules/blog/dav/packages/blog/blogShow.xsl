<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="xs portal" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>
  <xsl:include href="/libraries/common.xsl"/>
  <xsl:include href="/libraries/editorElements.xsl"/>
  <xsl:include href="/libraries/formatDate.xsl"/>
  <xsl:param name="showRelatedArticle">
    <type>page</type>
  </xsl:param>
  <xsl:param name="loginPage">
    <type>page</type>
  </xsl:param>
  <xsl:param name="categorykey">
    <type>category</type>
  </xsl:param>
  <xsl:variable name="language" select="/verticaldata/context/@languagecode"/>
  <!-- variables needed for blogg -->
  <xsl:variable name="currentPageId" select="/verticaldata/context/querystring/parameter[@name = 'id']"/>
  <xsl:variable name="currentPageContent" select="/verticaldata/context/querystring/parameter[@name = 'key']"/>
  <xsl:variable name="success" select="/verticaldata/context/querystring/parameter[@name = 'success']"/>
  <xsl:variable name="error" select="/verticaldata/context/querystring/parameter[@name = 'error']"/>

  <xsl:template match="/">
    <xsl:if test="/verticaldata/contents/content">
      <div id="blogg">
        <xsl:apply-templates select="/verticaldata/contents/content"/>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="content">
    <h1><xsl:value-of select="title"/></h1>
    <xsl:if test="/verticaldata/contents/relatedcontents/content[@key = current()/contentdata/article/images/image/@key] or contentdata/author/@key">
      <div id="relations">
        <xsl:attribute name="style">
        	<xsl:value-of select="concat('width: ', '310', 'px')"/>
        </xsl:attribute>
        <xsl:call-template name="editor"/>
        <xsl:if test="/verticaldata/contents/relatedcontents/content[@key = current()/contentdata/article/images/image/@key]">
          <div class="images">
            <xsl:for-each select="contentdata/article/images/image[@key = /verticaldata/contents/relatedcontents/content/@key]">
              <xsl:variable name="currentImage" select="/verticaldata/contents/relatedcontents/content[@key = current()/@key]"/>
              <div class="image">
                <xsl:attribute name="style">
                  <xsl:value-of select="concat('width: ', '310', 'px')"/>
                </xsl:attribute>
                <xsl:call-template name="displayImage">
                  <xsl:with-param name="image" select="$currentImage"/>
                  <xsl:with-param name="imageMaxWidth" select="310"/>
                </xsl:call-template>
                <xsl:if test="text != ''">
                  <div class="text">
                    <xsl:value-of select="text"/>
                  </div>
                </xsl:if>
              </div>
            </xsl:for-each>
          </div>
        </xsl:if>
      </div><!-- end of relations -->
    </xsl:if>
    <xsl:if test="string-length(contentdata/article/preface) > 0">
      <p class="preface">
        <xsl:call-template name="replaceSubstring">
          <xsl:with-param name="inputString" select="contentdata/article/preface"/>
        </xsl:call-template>
      </p>
    </xsl:if>
    <xsl:if test="contentdata/article/text/*|contentdata/article/text/text()">
      <div class="editor">
        <xsl:apply-templates select="contentdata/article/text"/>
        <!-- look for this templates in editorElements.xsl -->
      </div>
    </xsl:if>
    <xsl:if test="contentdata/links/link/url != ''">
      <xsl:call-template name="relatedLinks"/>
    </xsl:if>
    <xsl:if test="/verticaldata/contents/relatedcontents/content[@key = current()/contentdata/articles/content/@key]">
      <xsl:call-template name="relatedArticles"/>
    </xsl:if>
    <xsl:if test="/verticaldata/contents/relatedcontents/content[@key = current()/contentdata/files/file/@key]">
      <xsl:call-template name="relatedFiles"/>
    </xsl:if>
    <xsl:call-template name="comments"/>
    <div id="back-top"><a href="javascript:history.back()">&lt;&lt; Back</a> | <a href="{portal:createContentUrl($currentPageContent,())}#top">Go to top</a></div>
  </xsl:template>

  <xsl:template name="relatedLinks">
    <div class="related-frame">
      <h4>Related links</h4>
      <div class="related-inner">
        <ul class="related">
        <xsl:for-each select="contentdata/links/link">
          <li>
            <xsl:choose>
              <xsl:when test="position() mod 2 = 0 and position() = last()">
                <xsl:attribute name="class">dark last</xsl:attribute>
              </xsl:when>
              <xsl:when test="position() mod 2 = 0 and position() != last()">
                <xsl:attribute name="class">dark</xsl:attribute>
              </xsl:when>
              <xsl:when test="position() = last()">
                <xsl:attribute name="class">last</xsl:attribute>
              </xsl:when>
            </xsl:choose>
            <a href="{url}">
              <xsl:if test="target = 'new'"><xsl:attribute name="rel">external</xsl:attribute><xsl:attribute name="class">external</xsl:attribute></xsl:if>
              <xsl:choose>
                <xsl:when test="description != ''">
                  <xsl:attribute name="title"><xsl:value-of select="description"/></xsl:attribute>
                  <xsl:value-of select="description"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="url"/>
                </xsl:otherwise>
              </xsl:choose>
            </a>
          </li>
        </xsl:for-each>
        </ul>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="relatedArticles">
    <div class="related-frame">
      <h4>Related articles</h4>
      <div class="related-inner">
        <ul class="related">
          <xsl:for-each select="contentdata/articles/content[@key = /verticaldata/contents/relatedcontents/content/@key]">
            <xsl:variable name="currentItem" select="/verticaldata/contents/relatedcontents/content[@key = current()/@key]"/>
            <xsl:variable name="articleUrl" select="portal:createContentUrl($currentItem/@key, ())"/>
            <li>
              <xsl:choose>
                <xsl:when test="position() mod 2 = 0 and position() = last()">
                  <xsl:attribute name="class">dark last</xsl:attribute>
                </xsl:when>
                <xsl:when test="position() mod 2 = 0 and position() != last()">
                  <xsl:attribute name="class">dark</xsl:attribute>
                </xsl:when>
                <xsl:when test="position() = last()">
                  <xsl:attribute name="class">last</xsl:attribute>
                </xsl:when>
              </xsl:choose>
              <a>
                <xsl:attribute name="href">
                  <xsl:choose>
                    <xsl:when test="$currentItem/sectionnames/sectionname"><xsl:value-of select="$articleUrl"/></xsl:when>
                    <xsl:otherwise>page?id=<xsl:value-of select="$showRelatedArticle"/>&amp;key=<xsl:value-of select="@key"/></xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
              <xsl:value-of select="$currentItem/title"/></a>
            </li>
          </xsl:for-each>
        </ul>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="relatedFiles">
    <div class="related-frame">
      <h4>Related files</h4>
      <div class="related-inner">
        <ul class="related">
        <xsl:for-each select="contentdata/files/file">
          <xsl:variable name="currentFile" select="/verticaldata/contents/relatedcontents/content[@key = current()/@key]"/>
          <li>
            <xsl:choose>
              <xsl:when test="position() mod 2 = 0 and position() = last()">
                <xsl:attribute name="class">dark last</xsl:attribute>
              </xsl:when>
              <xsl:when test="position() mod 2 = 0 and position() != last()">
                <xsl:attribute name="class">dark</xsl:attribute>
              </xsl:when>
              <xsl:when test="position() = last()">
                <xsl:attribute name="class">last</xsl:attribute>
              </xsl:when>
            </xsl:choose>
            <xsl:call-template name="getIconImage"><xsl:with-param name="filename" select="$currentFile/title"/></xsl:call-template>
            <a href="{portal:createBinaryUrl($currentFile/contentdata/binarydata/@key, ('download','true'))}">
            <xsl:choose>
              <xsl:when test="description != ''">
                <xsl:call-template name="cropText">
                  <xsl:with-param name="sourceText" select="description"/>
                  <xsl:with-param name="numCharacters" select="200"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$currentFile/title"/>
              </xsl:otherwise>
            </xsl:choose>
            </a><xsl:text> </xsl:text>(<xsl:call-template name="convertBytes"><xsl:with-param name="bytes" select="$currentFile/binaries/binary/@filesize"/></xsl:call-template>)
          </li>
        </xsl:for-each>
        </ul>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="comments">
  <div id="comments">
    <h3>Comments</h3>
    <xsl:choose>
      <xsl:when test="not(current()/relatedcontentkeys/relatedcontentkey[@key = /verticaldata/contents/relatedcontents/content[@contenttype = 'comment']/@key])">
        <p class="firstcomment">Be the first to comment this article</p>
      </xsl:when>
      <xsl:when test="/verticaldata/contents/relatedcontents/content[@key = current()/relatedcontentkeys/relatedcontentkey/@key and @contenttype = 'comment']">
        <xsl:for-each select="current()/relatedcontentkeys/relatedcontentkey[@key = /verticaldata/contents/relatedcontents/content[@contenttype = 'comment']/@key]">
          <xsl:sort order="ascending" select="@key"/>
          <xsl:variable name="currentComment" select="/verticaldata/contents/relatedcontents/content[@key = current()/@key]"/>
          <div class="comment">
            <xsl:if test="position() = last()">
              <xsl:attribute name="class">comment last</xsl:attribute>
            </xsl:if>
            <p class="commentby">Commented by <a href="mailto:{$currentComment/contentdata/email}" title="Send e-mail to {$currentComment/contentdata/name}"><xsl:value-of select="$currentComment/contentdata/name"/></a>
              <xsl:text> </xsl:text>
              <xsl:call-template name="formatDate">
                <xsl:with-param name="date" select="$currentComment/@publishfrom"/>
                <xsl:with-param name="format" select="'long'"/>
                <xsl:with-param name="includeTime" select="'true'"/>
              </xsl:call-template>
            </p>
            <p>
              <xsl:call-template name="replaceSubstring">
                <xsl:with-param name="inputString" select="$currentComment/contentdata/comment"/>
              </xsl:call-template>
            </p>
          </div>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise/>
      </xsl:choose>
      <div id="miniblog">
        <xsl:choose>
          <xsl:when test="/verticaldata/context/user">
            <script src="/_public/libraries/scripts/prototype-1.6.0.js" type="text/javascript"><xsl:comment>//</xsl:comment></script>
            <script src="/_public/libraries/scripts/validation-1.5.4.1.js" type="text/javascript"><xsl:comment>//</xsl:comment></script>
            <form action="{portal:createServicesUrl('content','create', ())}" id="form" method="post">
              <div class="form-content">
                <input name="categorykey" type="hidden" value="{$categorykey}"/>
                <input name="redirect" type="hidden" value="{portal:createContentUrl($currentPageContent,('success','true'))}"/>
                <input name="redirecterror" type="hidden" value="{portal:createContentUrl($currentPageContent,('error','true'))}"/>
                <input name="related" type="hidden" value="{@key}"/>
                <input name="heading" type="hidden" value="{title}"/>
                <h4><span>Write a comment to this article</span></h4>
  			        <table cellspacing="0" class="vs-form blog">
                  <tr>
                    <th class="left">Name <span class="required">*</span></th>
                    <td><input class="text required disabled" id="input_name" readonly="readonly" name="name" type="text" value="{/verticaldata/context/user/block/firstname} {/verticaldata/context/user/block/surname}"/></td>
                  </tr> 
                  <tr>
                    <th class="left">E-mail <span class="required">*</span></th>
                    <td><input class="text required disabled" id="input_email" name="email" readonly="readonly" type="text" value="{/verticaldata/context/user/block/email}"/></td>
                  </tr> 
                  <tr>
                    <th class="left comfield">Comment <span class="required">*</span></th>
                    <td>
                      <xsl:element name="textarea">
                        <xsl:attribute name="cols">10</xsl:attribute>
                        <xsl:attribute name="rows">5</xsl:attribute>
                        <xsl:attribute name="id">input_comment</xsl:attribute>
                        <xsl:attribute name="name">comment</xsl:attribute>
                        <xsl:attribute name="class">required</xsl:attribute>
                        <xsl:attribute name="title">Write a comment for this article</xsl:attribute>
                      </xsl:element>
                    </td>
                  </tr>
                </table>
                <p class="enter-button">
                  <input type="submit" value="Post a comment"/>
                  <input onclick="valid.reset(); return false" type="reset" value="Clear form"/>
                </p>
              </div><!-- /end of form-content -->
            </form> 
            <script type="text/javascript">
              <xsl:comment>  
                var valid = new Validation('form');
              //</xsl:comment>
            </script>    
          </xsl:when>
          <xsl:otherwise>
            <a href="{portal:createPageUrl($loginPage, ('callback',@key))}" title="You need to log in to be able to comment">
              You need to log in to be able to comment
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="editor">
    <div class="publisher">
      <xsl:choose>
        <xsl:when test="/verticaldata/contents/relatedcontents/content[@key = current()/contentdata/author/@key]">
          <xsl:variable name="currentAuthor" select="/verticaldata/contents/relatedcontents/content[@key = current()/contentdata/author/@key]/contentdata/thumbimage/@key"/>
          <img src="{portal:createBinaryUrl(/verticaldata/contents/relatedcontents/content[@key = $currentAuthor]/contentdata/images/image[width=50]/binarydata/@key)}" alt=""/>
          <xsl:text>Text by: </xsl:text>
          <xsl:apply-templates mode="author" select="/verticaldata/contents/relatedcontents/content[@key = current()/contentdata/author/@key]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Text by: </xsl:text><xsl:value-of select="owner"/>
        </xsl:otherwise>
      </xsl:choose>
      <span class="byline">
        Published
        <xsl:call-template name="formatDate">
          <xsl:with-param name="date" select="@publishfrom"/>
          <xsl:with-param name="format" select="'short'"/>
        </xsl:call-template>
      </span>
    </div>
  </xsl:template>

  <xsl:template match="content" mode="author">
    <xsl:variable name="currentAuthor" select="/verticaldata/contents/relatedcontents/content[@key = current()/@key]"/>
    <xsl:if test="$currentAuthor/contentdata/email != ''">
      <xsl:text disable-output-escaping="yes">&lt;a href="mailto:</xsl:text>
      <xsl:value-of select="$currentAuthor/contentdata/email"/>
      <xsl:text disable-output-escaping="yes">"&gt;</xsl:text>
    </xsl:if>
    <xsl:value-of select="concat($currentAuthor/contentdata/firstname, ' ', $currentAuthor/contentdata/surname)"/>
    <xsl:if test="$currentAuthor/contentdata/email != ''">
      <xsl:text disable-output-escaping="yes">&lt;/a&gt;</xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="position() = (last() - 1)">
        <xsl:value-of select="concat(' ', 'and', ' ')"/>
      </xsl:when>
      <xsl:when test="position() != last()">
        <xsl:text>, </xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>


</xsl:stylesheet>
