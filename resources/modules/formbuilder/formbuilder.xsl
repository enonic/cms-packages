<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="/libraries/utilities/standard-variables.xsl"/>
  <xsl:include href="/libraries/utilities/process-html-area.xsl"/>

  <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>
  
  <xsl:variable name="current-menuitem" select="/result/menuitems/menuitem"/>
  <xsl:variable name="form" select="$current-menuitem/data/form"/>
  <xsl:variable name="form-id" select="$current-menuitem/@key"/>
  <xsl:variable name="error" as="element()*" select="/result/context/querystring/parameter[@name = 'error_form_create']"/>

  <xsl:template match="/">
    <div class="clear append-bottom">
      <xsl:choose>
        <!-- Display confirmation -->
        <xsl:when test="/result/context/querystring/parameter[@name = 'success'] = 'create'">
          <xsl:call-template name="process-html-area.process-html-area">
            <xsl:with-param name="region-width" tunnel="yes" select="$region-width"/>
            <xsl:with-param name="filter" tunnel="yes" select="$config-filter"/>
            <xsl:with-param name="imagesize" tunnel="yes" select="$config-imagesize"/>
            <xsl:with-param name="document" select="$current-menuitem/data/form/confirmation"/>
            <xsl:with-param name="image" tunnel="yes" select="/result/contents/relatedcontents/content"/>
          </xsl:call-template>
        </xsl:when>
        <!-- Error on submit -->
        <xsl:when test="$error">
          <xsl:call-template name="display-form">
            <xsl:with-param name="form" select="/result/context/session/attribute[@name = 'error_form_create']/content/contentdata/form"/>
            <xsl:with-param name="error-handling" select="true()" tunnel="yes"/>
          </xsl:call-template>
        </xsl:when>
        <!-- Display form -->
        <xsl:otherwise>
          <xsl:call-template name="display-form">
            <xsl:with-param name="form" select="$current-menuitem/data/form"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>

  <xsl:template name="display-form">
    <xsl:param name="form"/>
    <xsl:param name="error-handling" select="false()" tunnel="yes"/>
    <xsl:call-template name="process-html-area.process-html-area">
      <xsl:with-param name="region-width" tunnel="yes" select="$region-width"/>
      <xsl:with-param name="filter" tunnel="yes" select="$config-filter"/>
      <xsl:with-param name="imagesize" tunnel="yes" select="$config-imagesize"/>
      <xsl:with-param name="document" select="$current-menuitem/document"/>
      <xsl:with-param name="image" tunnel="yes" select="/result/contents/relatedcontents/content"/>
    </xsl:call-template>
    <form action="{portal:createServicesUrl('form', 'create', portal:createPageUrl(portal:getPageKey(), ('success', 'create')), ())}" enctype="multipart/form-data" method="post">
      <fieldset>
        <legend>
          <xsl:value-of select="$form/title"/>
        </legend>
        <xsl:if test="$error">
          <div class="error">
            <xsl:for-each select="$error">
              <xsl:value-of select="portal:localize(concat('user-error-', .))"/>
              <xsl:if test="position() != last()">
                <br/>
              </xsl:if>
            </xsl:for-each>
          </div>
        </xsl:if>
        <input name="_form_id" type="hidden" value="{$form-id}"/>
        <input name="categorykey" type="hidden" value="{$form/@categorykey}"/>
        <xsl:for-each select="$form/recipients/e-mail">
          <input name="{concat($form-id, '_form_recipient')}" type="hidden" value="{.}"/>
        </xsl:for-each>
        <xsl:apply-templates select="$form/item"/>
        <xsl:if test="not($user)">
          <img src="{portal:createCaptchaImageUrl()}" alt="{portal:localize('Captcha-image')}" class="clear" id="formbuilder-captcha-image"/>
          <a href="#" onclick="reloadCaptcha('formbuilder-captcha-image');return false;" class="clear">
            <xsl:value-of select="portal:localize('New-image')"/>
          </a>
          <xsl:if test="$error = 405">
            <label class="error">
              <xsl:value-of select="portal:localize('user-error-405')"/>
            </label>
          </xsl:if>
          <label for="formbuilder-captcha">
            <span class="tooltip" title="{concat(portal:localize('Repeat-text'), ' - ', portal:localize('helptext-captcha'))}">
              <xsl:value-of select="portal:localize('Validation')"/>
            </span>
          </label>
          <input type="text" id="formbuilder-captcha" name="{portal:createCaptchaFormInputName()}" class="text required tooltip{if ($error = 405) then ' error' else ''}" title="{concat(portal:localize('Repeat-text'), ' - ', portal:localize('helptext-captcha'))}"/>
        </xsl:if>
      </fieldset>
      <p class="clearfix">
        <input type="submit" class="button" value="{portal:localize('Submit')}"/>
        <input type="reset" class="button" value="{portal:localize('Reset')}"/>
      </p>
    </form>
  </xsl:template>

  <xsl:template match="item">
    <xsl:param name="error-handling" tunnel="yes"/>
    <xsl:variable name="input-id" select="concat('form_', $form-id, '_elm_', position())"/>
    <xsl:variable name="input-name" select="concat($form-id, '_form_', position())"/>
    <!-- Error handling -->
    <xsl:if test="error">
      <label class="error">
        <xsl:choose>
          <xsl:when test="error[@id = 1]">
            <xsl:value-of select="portal:localize('jquery-validate-required')"/>
          </xsl:when>
          <xsl:when test="error[@id = 2]">
            <xsl:choose>
              <xsl:when test="@validationtype = 'email'">
                <xsl:value-of select="portal:localize('jquery-validate-email')"/>
              </xsl:when>
              <xsl:when test="@validationtype = 'integer'">
                <xsl:value-of select="portal:localize('jquery-validate-digits')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="portal:localize('jquery-validate-custom-regexp')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
        </xsl:choose>
      </label>
    </xsl:if>
    <xsl:if test="not(@type = 'separator')">
      <label for="{$input-id}">
        <xsl:if test="@type = 'checkboxes' or @type = 'radiobuttons'">
          <xsl:attribute name="for">
            <xsl:value-of select="concat($input-id, '_1')"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="@type = 'checkbox'">
          <xsl:attribute name="class">checkbox</xsl:attribute>
          <xsl:text disable-output-escaping="yes">&lt;span&gt;</xsl:text>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="help">
            <span class="tooltip" title="{help}">
              <xsl:value-of select="@label"/>              
            </span>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@label"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="@type = 'checkbox'">
          <xsl:text disable-output-escaping="yes">&lt;/span&gt;</xsl:text>
        </xsl:if>
        <!-- Checkbox -->
        <xsl:if test="@type = 'checkbox'">
          <input id="{$input-id}" name="{$input-name}" type="checkbox" class="checkbox">
            <xsl:if test="help">
              <xsl:attribute name="class">checkbox tooltip</xsl:attribute>
              <xsl:attribute name="title">
                <xsl:value-of select="help"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="data = 1 or (not(data) and @default = 'checked')">
              <xsl:attribute name="checked">checked</xsl:attribute>
            </xsl:if>
          </input>
        </xsl:if>
      </label>
    </xsl:if>
    <xsl:choose>
      <!-- Separator -->
      <xsl:when test="@type = 'separator'">
        <div class="{if (help) then 'separator tooltip' else 'separator'}">
          <xsl:if test="help">
            <xsl:attribute name="title">
              <xsl:value-of select="help"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:value-of select="@label"/>
        </div>
      </xsl:when>
      <!-- Text box -->
      <xsl:when test="@type = 'text'">
        <input class="{if (help) then 'text tooltip' else 'text'}{if (error) then ' error' else ''}{if (@required = 'true') then ' required' else ''}{if (@validationtype = 'integer') then ' digits' else ''}{if (@validationtype = 'email') then ' email' else ''}" id="{$input-id}" name="{$input-name}" type="text">
          <xsl:if test="help">
            <xsl:attribute name="title">
              <xsl:value-of select="help"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="data">
            <xsl:attribute name="value">
              <xsl:value-of select="data"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="@width and $device-class != 'mobile'">
            <xsl:attribute name="style">
              <xsl:value-of select="concat('width: ', @width, 'px;')"/>
            </xsl:attribute>
          </xsl:if>
        </input>
      </xsl:when>
      <!-- Textarea -->
      <xsl:when test="@type = 'textarea'">
        <textarea rows="6" cols="30" id="{$input-id}" name="{$input-name}">
          <xsl:if test="help or error or @required = 'true'">
            <xsl:attribute name="class">
              <xsl:if test="help">
                <xsl:text>tooltip</xsl:text>
              </xsl:if>
              <xsl:if test="error">
                <xsl:text> error</xsl:text>
              </xsl:if>
              <xsl:if test="@required = 'true'">
                <xsl:text> required</xsl:text>
              </xsl:if>
            </xsl:attribute>
            <xsl:if test="help">
              <xsl:attribute name="title">
                <xsl:value-of select="help"/>
              </xsl:attribute>
            </xsl:if>
          </xsl:if>
          <xsl:if test="(@width and $device-class != 'mobile') or @height">
            <xsl:attribute name="style">
              <xsl:if test="@width and $device-class != 'mobile'">
                <xsl:value-of select="concat('width: ', @width, 'px;')"/>
              </xsl:if>
              <xsl:if test="@height">
                <xsl:value-of select="concat('height: ', @height, 'px;')"/>
              </xsl:if>
            </xsl:attribute>
          </xsl:if>
          <xsl:value-of select="data"/>
        </textarea>
      </xsl:when>
      <!-- Checkboxes -->
      <xsl:when test="@type = 'checkboxes'">
        <xsl:for-each select="data/option">
          <xsl:variable name="id" select="concat($input-id, '_', position())"/>
          <label for="{$id}" class="radio">
            <xsl:if test="position() &gt; 1">
              <xsl:attribute name="class">
                <xsl:text>radio clear</xsl:text>
                <xsl:if test="position() = last()">
                  <xsl:text> last</xsl:text>
                </xsl:if>
              </xsl:attribute>
            </xsl:if>
            <input id="{$id}" name="{$input-name}" type="checkbox" class="checkbox" value="{@value}">
              <xsl:if test="(not($error-handling) and @default = 'true') or ($error-handling and @selected = 'true')">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            <xsl:value-of select="@value"/>
          </label>
        </xsl:for-each>
      </xsl:when>
      <!-- Radio buttons -->
      <xsl:when test="@type = 'radiobuttons'">
        <xsl:for-each select="data/option">
          <xsl:variable name="id" select="concat($input-id, '_', position())"/>
          <label for="{$id}" class="radio">
            <xsl:if test="position() &gt; 1">
              <xsl:attribute name="class">
                <xsl:text>radio clear</xsl:text>
                <xsl:if test="position() = last()">
                  <xsl:text> last</xsl:text>
                </xsl:if>
              </xsl:attribute>
            </xsl:if>
            <input id="{$id}" name="{$input-name}" type="radio" class="radio" value="{@value}">
              <xsl:if test="position() = 1 and ../../@required = 'true'">
                <xsl:attribute name="class">
                  <xsl:text>radio required</xsl:text>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="(not($error-handling) and @default = 'true') or ($error-handling and @selected = 'true')">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            <xsl:value-of select="@value"/>
          </label>
        </xsl:for-each>
      </xsl:when>
      <!-- Dropdown -->
      <xsl:when test="@type = 'dropdown'">
        <select id="{$input-id}" name="{$input-name}">
          <xsl:if test="help or error or @required = 'true'">
            <xsl:attribute name="class">
              <xsl:if test="help">
                <xsl:text>tooltip</xsl:text>
              </xsl:if>
              <xsl:if test="error">
                <xsl:text> error</xsl:text>
              </xsl:if>
              <xsl:if test="@required = 'true'">
                <xsl:text> required</xsl:text>
              </xsl:if>
            </xsl:attribute>
            <xsl:if test="help">
              <xsl:attribute name="title">
                <xsl:value-of select="help"/>
              </xsl:attribute>
            </xsl:if>
          </xsl:if>
          <xsl:if test="not(@required = 'true')">
            <option value="">
              <xsl:value-of select="concat('-- ', portal:localize('Select'), ' --')"/>
            </option>
          </xsl:if>
          <xsl:for-each select="data/option">
            <option value="{@value}">
              <xsl:if test="(not($error-handling) and @default = 'true') or ($error-handling and @selected = 'true')">
                <xsl:attribute name="selected">selected</xsl:attribute>
              </xsl:if>
              <xsl:value-of select="@value"/>
            </option>
          </xsl:for-each>
        </select>
      </xsl:when>
      <!-- File attachment -->
      <xsl:when test="@type = 'fileattachment'">
        <input class="{if (help) then 'text tooltip' else 'text'}{if (error) then ' error' else ''}{if (@required = 'true') then ' required' else ''}" id="{$input-id}" name="{$input-name}" type="file">
          <xsl:if test="help">
            <xsl:attribute name="title">
              <xsl:value-of select="help"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="data">
            <xsl:attribute name="value">
              <xsl:value-of select="data"/>
            </xsl:attribute>
          </xsl:if>
        </input>
      </xsl:when>
    </xsl:choose>
    <xsl:if test="@title = 'true'">
      <input name="{concat($form-id, '_form_title')}" type="hidden" value="{$input-id}"/>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>