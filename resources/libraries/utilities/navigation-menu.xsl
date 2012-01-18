<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:util="enonic:utilities" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">

	<xsl:template name="navigation-menu.navigation-header">
		<xsl:param name="index" as="xs:integer"/>
		<xsl:param name="content-count" as="xs:integer"/>
		<xsl:param name="total-count" as="xs:integer"/>
		<xsl:param name="contents-per-page" as="xs:integer"/>
		<xsl:if test="$total-count &gt; $contents-per-page">
			<div id="navigation-header" class="clear">
				<xsl:variable name="range">
					<xsl:value-of select="$index + 1"/>
					<xsl:if test="$content-count > 1">
						<xsl:value-of select="concat(' - ', $index + $content-count)"/>
					</xsl:if>
				</xsl:variable>
				<xsl:value-of select="portal:localize('navigation-menu-header-text', ($range, $total-count))"/>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template name="navigation-menu.navigation-menu">
		<xsl:param name="parameters" tunnel="yes" as="element()*"/>
		<xsl:param name="index" tunnel="yes" as="xs:integer"/>
		<xsl:param name="content-count" as="xs:integer"/>
		<xsl:param name="total-count" tunnel="yes" as="xs:integer"/>
		<xsl:param name="contents-per-page" tunnel="yes" as="xs:integer"/>
		<xsl:param name="pages-in-navigation" select="10" as="xs:integer"/>
		<xsl:param name="button-first" select="'|«'" as="xs:string"/>
		<xsl:param name="button-previous" select="'«'" as="xs:string"/>
		<xsl:param name="button-next" select="'»'" as="xs:string"/>
		<xsl:param name="button-last" select="'»|'" as="xs:string"/>
		<xsl:param name="index-parameter-name" tunnel="yes" select="'index'" as="xs:string"/>
		<xsl:if test="$total-count &gt; $contents-per-page">
			<div class="pagination">
				<ul>
					<!-- First page -->
					 
						<xsl:choose>
							<xsl:when test="$index > 0">
								<li>
									<a href="{util:construct-navigation-url(0, $parameters, $index-parameter-name)}">
										<xsl:value-of select="$button-first"/>
									</a>
								</li>
							</xsl:when>
							<xsl:otherwise>
								<li class="prev disabled">
									<a href="#" class="prev disabled">
										<xsl:value-of select="$button-first"/>
									</a>
								</li>
							</xsl:otherwise>
						</xsl:choose>
					<!-- Previous page -->
						<xsl:choose>
							<xsl:when test="$index - $contents-per-page >= 0">
								<li>
									<a href="{util:construct-navigation-url($index - $contents-per-page, $parameters, $index-parameter-name)}">
										<xsl:value-of select="concat($button-previous, ' ', portal:localize('Previous'))"/>
									</a>
								</li>
							</xsl:when>
							<xsl:otherwise>
								<li class="prev disabled">
									<a href="#">
										<xsl:value-of select="concat($button-previous, ' ', portal:localize('Previous'))"/>
									</a>
								</li>
							</xsl:otherwise>
						</xsl:choose>

					<!-- Middle navigation part -->
					<xsl:variable name="tmp" select="floor(($total-count - ($index + 1)) div $contents-per-page) - floor(($pages-in-navigation - 1) div 2)"/>
					<xsl:variable name="tmp2" select="if ($tmp > 0) then 0 else $tmp"/>
					<xsl:variable name="tmp3" select="$index - (floor($pages-in-navigation div 2) * $contents-per-page) + ($tmp2 * $contents-per-page)"/>
					<xsl:call-template name="navigation-menu.navigation-menu-middle">
						<xsl:with-param name="start" tunnel="yes" select="if ($tmp3 &lt; 0) then 0 else $tmp3"/>
						<xsl:with-param name="max-count" tunnel="yes" select="$pages-in-navigation"/>
					</xsl:call-template>
					<!-- Next page -->
						<xsl:choose>
							<xsl:when test="$index + $contents-per-page &lt; $total-count">
								<li class="next">
									<a href="{util:construct-navigation-url($index + $contents-per-page, $parameters, $index-parameter-name)}">
										<xsl:value-of select="concat(portal:localize('Next'), ' ', $button-next)"/>
									</a>
								</li>
							</xsl:when>
							<xsl:otherwise>
								<li class="">
									<a href="#">
										<xsl:value-of select="concat(portal:localize('Next'), ' ', $button-next)"/>
									</a>
								</li>
							</xsl:otherwise>
						</xsl:choose>
					<!-- Last page -->
					
						<xsl:choose>
							<xsl:when test="$index + $contents-per-page &lt; $total-count">
								<li class="next">
									<a href="{util:construct-navigation-url(xs:integer(ceiling(($total-count div $contents-per-page) - 1) * $contents-per-page), $parameters, $index-parameter-name)}">
										<xsl:value-of select="$button-last"/>
									</a>
								</li>
							</xsl:when>
							<xsl:otherwise>
								<li class="next disabled">
									<a href="#">
										<xsl:value-of select="$button-last"/>
									</a>
								</li>
							</xsl:otherwise>
						</xsl:choose>
					
				</ul>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template name="navigation-menu.navigation-menu-middle">
		<xsl:param name="parameters" tunnel="yes" as="element()*"/>
		<xsl:param name="index" tunnel="yes" as="xs:integer"/>
		<xsl:param name="total-count" tunnel="yes" as="xs:integer"/>
		<xsl:param name="contents-per-page" tunnel="yes" as="xs:integer"/>
		<xsl:param name="index-parameter-name" tunnel="yes" select="'index'" as="xs:string"/>
		<xsl:param name="start" tunnel="yes"/>
		<xsl:param name="max-count" tunnel="yes"/>
		<xsl:param name="counter" select="1"/>
		<xsl:if test="$counter &lt;= $max-count and (($start + (($counter - 1) * $contents-per-page)) &lt; $total-count)">
			
				<xsl:choose>
					<xsl:when test="$start + (($counter - 1) * $contents-per-page) = $index">
						<li class="active">
							<a href="#">
								<xsl:value-of select="($start div $contents-per-page) + $counter"/>
							</a>
						</li>
					</xsl:when>
					<xsl:otherwise>
					<li>
						<a href="{util:construct-navigation-url(xs:integer($start + (($counter - 1) * $contents-per-page)), $parameters, $index-parameter-name)}">
							<xsl:value-of select="($start div $contents-per-page) + $counter"/>
						</a>
					</li>
					</xsl:otherwise>
				</xsl:choose>
			<xsl:call-template name="navigation-menu.navigation-menu-middle">
				<xsl:with-param name="counter" select="$counter + 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:function name="util:construct-navigation-url" as="xs:string">
		<xsl:param name="index" as="xs:integer"/>
		<xsl:param name="parameters" as="element()*"/>
		<xsl:param name="index-parameter-name" as="xs:string"/>
		<xsl:variable name="final-parameters" as="xs:anyAtomicType+">
			<xsl:for-each select="$parameters[not(@name = $index-parameter-name)]">
				<xsl:sequence select="@name, ."/>
			</xsl:for-each>
			<xsl:sequence select="$index-parameter-name, $index"/>
		</xsl:variable>
		<xsl:value-of select="portal:createPageUrl($final-parameters)"/>
	</xsl:function>

</xsl:stylesheet>
