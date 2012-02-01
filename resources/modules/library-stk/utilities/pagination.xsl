<?xml version="1.0" encoding="UTF-8"?>

<!--
	**************************************************
	
	pagination.xsl
	version: ###VERSION-NUMBER-IS-INSERTED-HERE###
	
	**************************************************
-->

<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fw="http://www.enonic.com/cms/xslt/framework"
	xmlns:portal="http://www.enonic.com/cms/xslt/portal"
	xmlns:util="http://www.enonic.com/cms/xslt/utilities">
	
	<xsl:import href="/modules/library-stk/utilities/fw-variables.xsl"/>
	
	<xsl:template name="util:pagination.header">
		<xsl:param name="contents" as="element()"/>
		<xsl:param name="index" as="xs:integer?" select="xs:integer($contents/@index)"/>
		<xsl:param name="content-count" as="xs:integer?" select="xs:integer($contents/@resultcount)"/>
		<xsl:param name="total-count" as="xs:integer?" select="xs:integer($contents/@totalcount)"/>
		<xsl:param name="contents-per-page" as="xs:integer?" select="xs:integer($contents/@count)"/>
		<xsl:if test="$total-count gt $contents-per-page">
			<div class="pagination-header">
				<xsl:variable name="range">
					<xsl:value-of select="$index + 1"/>
					<xsl:if test="$content-count gt 1">
						<xsl:value-of select="concat(' - ', $index + $content-count)"/>
					</xsl:if>
				</xsl:variable>
				<xsl:value-of select="portal:localize('util.pagination.header-text', ($range, $total-count))"/>
			</div>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="util:pagination.menu">
		<xsl:param name="contents" as="element()"/>
		<xsl:param name="index" as="xs:integer?" select="xs:integer($contents/@index)"/>
		<xsl:param name="content-count" as="xs:integer?" select="xs:integer($contents/@resultcount)"/>
		<xsl:param name="total-count" as="xs:integer?" select="xs:integer($contents/@totalcount)"/>
		<xsl:param name="contents-per-page" as="xs:integer?" select="xs:integer($contents/@count)"/>
		<xsl:param name="parameters" as="element()*" select="$fw:querystring-parameter[not(@name = 'index' or @name = 'id' or starts-with(@name, '_config-'))]"/>
		<xsl:param name="pages-in-pagination" select="10" as="xs:integer"/>
		<xsl:param name="index-parameter-name" select="'index'" as="xs:string"/>
		<xsl:if test="$total-count gt $contents-per-page">
			<nav class="pagination">
				<ol>
					<!-- First page -->
					<xsl:if test="$index gt 0">
						<li class="end first button">
							<a href="{util:pagination.construct-url(0, $parameters, $index-parameter-name)}" title="{portal:localize('util.pagination.first-page')}">
								<xsl:value-of select="portal:localize('util.pagination.first-page')"/>
							</a>
						</li>
					</xsl:if>
					<!-- Previous page -->
					<xsl:if test="($index - $contents-per-page) ge 0">
						<li class="previous button">
							<a href="{util:pagination.construct-url($index - $contents-per-page, $parameters, $index-parameter-name)}" title="{portal:localize('util.pagination.previous-page')}">
								<xsl:value-of select="portal:localize('util.pagination.previous-page')"/>
							</a>
						</li>
					</xsl:if>
					<!-- Middle pagination part -->
					<xsl:variable name="tmp" select="floor(($total-count - ($index + 1)) div $contents-per-page) - floor(($pages-in-pagination - 1) div 2)"/>
					<xsl:variable name="tmp2" select="if ($tmp gt 0) then 0 else $tmp"/>
					<xsl:variable name="tmp3" select="$index - (floor($pages-in-pagination div 2) * $contents-per-page) + ($tmp2 * $contents-per-page)"/>
					<xsl:call-template name="util:pagination.menu-middle">
						<xsl:with-param name="start" tunnel="yes" select="if ($tmp3 lt 0) then 0 else $tmp3"/>
						<xsl:with-param name="max-count" tunnel="yes" select="$pages-in-pagination"/>
						<xsl:with-param name="parameters" tunnel="yes" select="$parameters"/>
						<xsl:with-param name="index" tunnel="yes" select="$index"/>
						<xsl:with-param name="total-count" tunnel="yes" select="$total-count"/>
						<xsl:with-param name="contents-per-page" tunnel="yes" select="$contents-per-page"/>
						<xsl:with-param name="index-parameter-name" tunnel="yes" select="'index'" as="xs:string"/>
					</xsl:call-template>
					<!-- Next page -->
					<xsl:if test="$index + $contents-per-page lt $total-count">
						<li class="next button">
							<a href="{util:pagination.construct-url($index + $contents-per-page, $parameters, $index-parameter-name)}" title="{portal:localize('util.pagination.next-page')}">
								<xsl:value-of select="portal:localize('util.pagination.next-page')"/>
							</a>
						</li>
					</xsl:if>
					<!-- Last page -->
					<xsl:if test="$index + $contents-per-page lt $total-count">
						<li class="end last button">
							<a href="{util:pagination.construct-url(xs:integer(ceiling(($total-count div $contents-per-page) - 1) * $contents-per-page), $parameters, $index-parameter-name)}" title="{portal:localize('util.pagination.last-page')}">
								<xsl:value-of select="portal:localize('util.pagination.last-page')"/>
							</a>
						</li>
					</xsl:if>
				</ol>
			</nav>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="util:pagination.menu-middle">
		<xsl:param name="parameters" tunnel="yes" as="element()*"/>
		<xsl:param name="index" tunnel="yes" as="xs:integer"/>
		<xsl:param name="total-count" tunnel="yes" as="xs:integer"/>
		<xsl:param name="contents-per-page" tunnel="yes" as="xs:integer"/>
		<xsl:param name="index-parameter-name" tunnel="yes" select="'index'" as="xs:string"/>
		<xsl:param name="start" tunnel="yes"/>
		<xsl:param name="max-count" tunnel="yes"/>
		<xsl:param name="counter" select="1"/>
		<xsl:if test="$counter le $max-count and (($start + (($counter - 1) * $contents-per-page)) lt $total-count)">
			<li>
				<xsl:attribute name="class">
					<xsl:text>number</xsl:text>
					<xsl:if test="$counter = 1">
						<xsl:text> first-page</xsl:text>
					</xsl:if>
					<xsl:if test="$start + (($counter - 1) * $contents-per-page) = $index">
						<xsl:text> active</xsl:text>
					</xsl:if>
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="$start + (($counter - 1) * $contents-per-page) = $index">
						<span>
							<xsl:value-of select="($start div $contents-per-page) + $counter"/>
						</span>
					</xsl:when>
					<xsl:otherwise>
						<a href="{util:pagination.construct-url(xs:integer($start + (($counter - 1) * $contents-per-page)), $parameters, $index-parameter-name)}">
							<xsl:value-of select="($start div $contents-per-page) + $counter"/>
						</a>
					</xsl:otherwise>
				</xsl:choose>
			</li>
			<xsl:call-template name="util:pagination.menu-middle">
				<xsl:with-param name="counter" select="$counter + 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:function name="util:pagination.construct-url" as="xs:string">
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
