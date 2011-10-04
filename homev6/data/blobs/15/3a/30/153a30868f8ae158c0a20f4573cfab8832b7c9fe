<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:util="enonic:utilities" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="/libraries/utilities/standard-variables.xsl"/>
	<xsl:include href="/libraries/utilities/utilities.xsl"/>

	<xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>

	<xsl:param name="comments-folder">
		<type>category</type>
	</xsl:param>

	<xsl:variable name="error-content-create" select="/result/context/querystring/parameter[@name = 'error_content_create']"/>
	<xsl:variable name="session-parameter" select="/result/context/session/attribute[@name = 'error_content_create']/form/parameter"/>
	<xsl:variable name="user-image-filters">
		<xsl:choose>
			<xsl:when test="$device-class = 'mobile'">scalesquare(28);rounded(2)</xsl:when>
			<xsl:otherwise>scalesquare(48);rounded(2)</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:template match="/">
		<div id="comments" class="clear">
			<h2>
				<xsl:value-of select="portal:localize('Comments')"/>
			</h2>
			<xsl:if test="/result/contents/content">
				<div class="list clear append-bottom">
					<xsl:apply-templates select="/result/contents/content"/>
				</div>
			</xsl:if>
			<form action="{portal:createServicesUrl('content', 'create', concat(portal:createContentUrl(/result/context/resource/@key), '#last-comment'), ())}" id="comments-form" method="post">
				<fieldset>
					<legend>
						<xsl:value-of select="portal:localize('Your-comment')"/>
					</legend>
					<xsl:if test="$error-content-create = 405">
						<div class="error">
							<xsl:value-of select="portal:localize('user-error-405')"/>
						</div>
					</xsl:if>
					<input type="hidden" name="categorykey" value="{$comments-folder}"/>
					<input type="hidden" name="commented-content-heading" value="{util:menuitem-name(/result/context/resource)}"/>
					<input type="hidden" name="commented-content" value="{/result/context/resource/@key}"/>
					<label for="comments-name">
						<xsl:value-of select="portal:localize('Name')"/>
					</label>
					<input type="text" id="comments-name" name="name" class="text required">
						<xsl:choose>
							<xsl:when test="$user">
								<xsl:attribute name="readonly">readonly</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:value-of select="$user/display-name"/>
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="$error-content-create = 405">
								<xsl:attribute name="value">
									<xsl:value-of select="$session-parameter[@name = 'name']"/>
								</xsl:attribute>
							</xsl:when>
						</xsl:choose>
					</input>
					<label for="comments-email">
						<xsl:value-of select="portal:localize('E-mail')"/>
					</label>
					<input type="text" id="comments-email" name="email" class="text required email">
						<xsl:choose>
							<xsl:when test="$user">
								<xsl:attribute name="readonly">readonly</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:value-of select="$user/email"/>
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="$error-content-create = 405">
								<xsl:attribute name="value">
									<xsl:value-of select="$session-parameter[@name = 'email']"/>
								</xsl:attribute>
							</xsl:when>
						</xsl:choose>
					</input>
					<label for="comments-comment">
						<xsl:value-of select="portal:localize('Comment')"/>
					</label>
					<textarea rows="5" cols="5" id="comments-comment" name="comment" class="required">
						<xsl:if test="$error-content-create = 405">
							<xsl:value-of select="$session-parameter[@name = 'comment']"/>
						</xsl:if>
					</textarea>
					<xsl:if test="not($user)">
						<img src="{portal:createCaptchaImageUrl()}" alt="{portal:localize('Captcha-image')}" class="clear" id="comments-captcha-image"/>
						<a href="#" onclick="reloadCaptcha('comments-captcha-image');return false;" class="clear">
							<xsl:value-of select="portal:localize('New-image')"/>
						</a>
						<label for="comments-captcha">
							<span class="tooltip" title="{concat(portal:localize('Repeat-text'), ' - ', portal:localize('helptext-captcha'))}">
								<xsl:value-of select="portal:localize('Validation')"/>
							</span>
						</label>
						<input type="text" id="comments-captcha" name="{portal:createCaptchaFormInputName()}" class="text required tooltip" title="{concat(portal:localize('Repeat-text'), ' - ', portal:localize('helptext-captcha'))}"/>
					</xsl:if>
				</fieldset>
				<p class="clearfix">
					<input type="submit" class="button" value="{portal:localize('Send')}"/>
				</p>
			</form>
		</div>
		<xsl:if test="$error-content-create = 405">
			<script type="text/javascript">
				<xsl:comment>
					location.href = location.href.split('#')[0] + '#comments-form';
				//</xsl:comment>
			</script>
		</xsl:if>
	</xsl:template>

	<xsl:template match="content">
		<div class="item">
			<xsl:if test="position() = 1">
				<xsl:attribute name="class">item first</xsl:attribute>
			</xsl:if>
			<xsl:if test="position() = last()">
				<xsl:attribute name="id">last-comment</xsl:attribute>
			</xsl:if>
			<h4 class="float-right">
				<xsl:value-of select="util:format-date(@publishfrom, /result/context/@languagecode, (), true())"/>
			</h4>
			<img title="{owner/display-name}" alt="{concat(portal:localize('Image-of'), ' ', owner/display-name)}">
				<xsl:attribute name="src">
					<xsl:choose>
						<xsl:when test="owner/photo/@exists = 'true'">
							<xsl:value-of select="portal:createImageUrl(concat('user/', owner/@key), $user-image-filters)"/>
						</xsl:when>
						<xsl:when test="$device-class = 'mobile'">
							<xsl:value-of select="portal:createResourceUrl(concat($theme-public, '/images/dummy-user-smallest.png'))"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="portal:createResourceUrl(concat($theme-public, '/images/dummy-user-small.png'))"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</img>
			<h4>
				<xsl:value-of select="portal:localize('Commented-by')"/>
				<xsl:text> </xsl:text>
				<a href="mailto:{contentdata/email}">
					<xsl:value-of select="contentdata/name"/>
				</a>
			</h4>
			<p class="clear">
				<xsl:value-of select="contentdata/comment"/>
			</p>
		</div>
	</xsl:template>

</xsl:stylesheet>
