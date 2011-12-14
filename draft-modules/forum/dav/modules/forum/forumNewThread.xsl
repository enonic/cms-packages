<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0"
                xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:saxon="http://saxon.sf.net/"
                xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xml" omit-xml-declaration="yes"/>
  <xsl:variable name="forumConfiguration" select="document('forumConfiguration.xml')"/>
  <xsl:param name="from_name" select="'Travel Forum'"/>
  <xsl:param name="from_email" select="'travel@example.com'"/>
  <xsl:param name="standard_receiver" select="'tsi@enonic.com'"/>
  <xsl:param name="mailSubject" select="'New Posting'"/>

  <xsl:variable name="catPage" select="$forumConfiguration/properties/property[@key = 'categoriesPage']/@value"/>
  <xsl:variable name="threadPage" select="$forumConfiguration/properties/property[@key = 'threadPage']/@value"/>
  <xsl:variable name="categoryInfo"
                select="saxon:parse(concat('&lt;info>', /verticaldata/categories/category/description, '&lt;/info>'))"/>
  <xsl:variable name="cat" select="/verticaldata/context/querystring/parameter[@name = 'cat']"/>
  <xsl:variable name="key" select="/verticaldata/context/querystring/parameter[@name = 'key']"/>
  <xsl:variable name="topkey">
    <xsl:choose>
      <xsl:when
              test="not(/verticaldata/contents/content/top = 'true') and string-length(/verticaldata/contents/content/contentdata/topkey/@key) > 0">
        <xsl:value-of select="/verticaldata/contents/content/contentdata/topkey/@key"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/verticaldata/contents/content[1]/@key"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="string-length($key) > 0">
        <xsl:call-template name="publishform_reply"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="publishform_new"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="publishform_new">
    <h1>
      New post
    </h1>
    <xsl:variable name="redirectUrl" select="portal:createPageUrl($catPage,('cat', /verticaldata/context/querystring/parameter[@name='cat']))"/>
    <form action="{portal:createServicesUrl('content','create', $redirectUrl, ())}" id="formPosting" method="post" name="formPosting" onsubmit="return forumValidator();">
      <div>
        <input name="categorykey" type="hidden" value="{$cat}"/>
        <input name="top" type="hidden" value="true"/>
        <xsl:call-template name="submittable"/>
      </div>
    </form>
  </xsl:template>

  <xsl:template name="publishform_reply">
    <h1>
      Post a reply "<xsl:value-of select="/verticaldata/contents/content/contentdata/title"/>"
    </h1>

    <xsl:variable name="redirectUrl" select="portal:createPageUrl($threadPage, ('cat',//parameter[@name='cat'],'thread',$topkey))"/>
    <form action="{portal:createServicesUrl('content','create', $redirectUrl, ())}" id="formPosting" method="post" name="formPosting" onsubmit="return forumValidator();">
      <div>
        <input name="categorykey" type="hidden" value="{/verticaldata/context/querystring/parameter[@name='cat']}"/>
        <input name="top" type="hidden" value="false"/>
        <input name="parentkey" type="hidden" value="{/verticaldata/contents/content/@key}"/>
        <input name="topkey" type="hidden" value="{$topkey}"/>
        <xsl:call-template name="submittable"/>
      </div>
    </form>
  </xsl:template>

  <xsl:template name="submittable">
    <!-- Sendmail options -->
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
    <input name="subject" type="hidden" value="New forum posting"/>
    <input name="category" type="hidden" value="{/verticaldata/categories/category/@name}"/>
    <input name="sort_order" type="hidden" value="author,category,title,body"/>
    <!-- /Sendmail options -->
    <table class="forumcontent post">
      <tr>
        <td>
          <xsl:text>Name</xsl:text>
          <span class="required">*</span>
        </td>
        <td>
          <input name="author" type="text"/>
        </td>
      </tr>
      <tr>
        <td>
          <xsl:text>E-mail</xsl:text>
          <span class="required">*</span>
        </td>
        <td>
          <input name="email" type="text"/>
        </td>
      </tr>
      <tr>
        <td>
          <xsl:text>Subject</xsl:text>
          <span class="required">*</span>
        </td>
        <td valign="top">
          <input id="title" name="title" type="text">
            <xsl:attribute name="value">
              <xsl:if test="string-length(/verticaldata/contents/content/contentdata/title) > 0">
                <xsl:text>Re:</xsl:text>
                <xsl:choose>
                  <xsl:when test="substring(/verticaldata/contents/content/contentdata/title, 1, 3) = 'Re: '">
                    <xsl:value-of select="substring(/verticaldata/contents/content/contentdata/title, 4)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="/verticaldata/contents/content/contentdata/title"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:if>
            </xsl:attribute>
          </input>
        </td>
      </tr>
      <tr>
        <td>
          <xsl:text>Content</xsl:text>
          <span class="required">*</span>
        </td>
        <td>
          <xsl:call-template name="tagList"/>
          <textarea id="body" name="body">
            <xsl:if test="/verticaldata/context/querystring/parameter[@name = 'quote'] = 'yes'">
              <xsl:value-of select="'&#xa;&#xa;&#xa;&#xa;[cite]'"/>
              <xsl:value-of disable-output-escaping="yes" select="/verticaldata/contents[1]/content/contentdata/body"/>
              <xsl:value-of select="'&#xa;[/cite]'"/>
            </xsl:if>
            <xsl:text> </xsl:text>
          </textarea>
          <br/>
          <div class="submitbuttons">
            <input class="postingbutton" type="submit" value="Submit"/>
          </div>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="tagList">
    <ul class="taglist">
      <li>
        <a href="javascript:addTag('[b]','[/b]');" title="Bold">
          <img alt="Bold" class="smiley"
               src="{portal:createResourceUrl('/_public/packages/site/images/icon_bold.png')}"/>
        </a>
      </li>
      <li>
        <a href="javascript:addTag('[i]','[/i]');" title="Italic">
          <img alt="Italic" class="smiley"
               src="{portal:createResourceUrl('/_public/packages/site/images/icon_italic.png')}"/>
        </a>
      </li>
      <li>
        <a href="javascript:addTag('[u]','[/u]');" title="Underlined">
          <img alt="Underlined" class="smiley"
               src="{portal:createResourceUrl('/_public/packages/site/images/icon_underline.png')}"/>
        </a>
      </li>
      <li>
        <a href="javascript:addTag('[strike]','[/strike]');" title="Strikethrough">
          <img alt="Strikethrough" class="smiley"
               src="{portal:createResourceUrl('/_public/packages/site/images/icon_strikethrough.png')}"/>
        </a>
      </li>
      <li>
        <a href="javascript:addTag('[sub]','[/sub]');" title="Subscript">
          <img alt="Subscript" class="smiley"
               src="{portal:createResourceUrl('/_public/packages/site/images/icon_subscript.png')}"/>
        </a>
      </li>
      <li style="margin-right: 20px;">
        <a href="javascript:addTag('[sup]','[/sup]');" title="Superscript">
          <img alt="Superscript" class="smiley"
               src="{portal:createResourceUrl('/_public/packages/site/images/icon_superscript.png')}"/>
        </a>
      </li>
      <li>
        <a href="javascript:addTag('',':)');" title="Smiley face">
          <img alt=":)" class="smiley"
               src="{portal:createResourceUrl('/_public/packages/site/images/smile.png')}"/>
        </a>
      </li>
      <li>
        <a href="javascript:addTag('',':(');" title="Sad face">
          <img alt=":)(" class="smiley"
               src="{portal:createResourceUrl('/_public/packages/site/images/unhappy.png')}"/>
        </a>
      </li>
      <li>
        <a href="javascript:addTag('',':D');" title="Happy face">
          <img alt=":D" class="smiley"
               src="{portal:createResourceUrl('/_public/packages/site/images/happy.png')}"/>
        </a>
      </li>
      <li>
        <a href="javascript:addTag('',':p');" title="Tongue face">
          <img alt=":p" class="smiley"
               src="{portal:createResourceUrl('/_public/packages/site/images/tongue.png')}"/>
        </a>
      </li>
      <li style="margin-right: 20px;">
        <a href="javascript:addTag('',':o');" title="Surprised face">
          <img alt=":o" class="smiley"
               src="{portal:createResourceUrl('/_public/packages/site/images/surprised.png')}"/>
        </a>
      </li>
      <li>
        <select name="codes" onchange="openFunction(this);">
          <option value="#">- Insert program code -</option>
          <option value="addTag('[code]','[/code]');">Unformatted code</option>
          <option value="addTag('[code=c]','[/code]');">C++</option>
          <option value="addTag('[code=csharp]','[/code]');">C#</option>
          <option value="addTag('[code=css]','[/code]');">CSS</option>
          <option value="addTag('[code=delphi]','[/code]');">Delphi</option>
          <option value="addTag('[code=html]','[/code]');">HTML</option>
          <option value="addTag('[code=java]','[/code]');">Java</option>
          <option value="addTag('[code=js]','[/code]');">JavaScript</option>
          <option value="addTag('[code=py]','[/code]');">Python</option>
          <option value="addTag('[code=ruby]','[/code]');">Ruby</option>
          <option value="addTag('[code=sql]','[/code]');">SQL</option>
          <option value="addTag('[code=vb]','[/code]');">VB, VB.NET</option>
          <option value="addTag('[code=xml]','[/code]');">XML</option>
          <option value="addTag('[code=xslt]','[/code]');">XSLT</option>
        </select>
      </li>
    </ul>
  </xsl:template>
</xsl:stylesheet>