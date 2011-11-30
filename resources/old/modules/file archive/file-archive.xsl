<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="enonic:utilities">
    
    <xsl:import href="/libraries/utilities/standard-variables.xsl"/>
    <xsl:include href="/libraries/utilities/utilities.xsl"/>
    
    <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>
    
    <xsl:template match="/">
        <div id="file-archive" class="clear clearfix append-bottom">
            <div class="column heading name">
                <span>
                    <xsl:value-of select="portal:localize('Name')"/>
                </span>
            </div>
            <div class="column heading date-modified">
                <span>
                    <xsl:value-of select="portal:localize('Date-modified')"/>
                </span>
            </div>
            <div class="column heading size">
                <span>
                    <xsl:value-of select="portal:localize('Size')"/>
                </span>
            </div>
            <div class="column heading kind">
                <span>
                    <xsl:value-of select="portal:localize('Kind')"/>
                </span>
            </div>
           <xsl:if test="/result/categories/category/categories/category or /result/contents/content[category/@key = /result/categories/category/@key]">
               <ul class="menu clear clearfix append-bottom">
                   <xsl:apply-templates select="/result/categories/category/categories/category[(@key = /result/contents/content/category/@key) or (categories/category)]">
                       <xsl:sort select="@name" order="ascending"/>
                   </xsl:apply-templates>
                   <xsl:apply-templates select="/result/contents/content[category/@key = /result/categories/category/@key]">
                       <xsl:sort select="title" order="ascending"/>
                   </xsl:apply-templates>
               </ul>
           </xsl:if>
        </div>
    </xsl:template>
    
    <xsl:template match="category | content">
        <li>
            <xsl:choose>
                <xsl:when test="name() = 'category'">
                    <xsl:attribute name="class">folder</xsl:attribute>
                    <div class="column name tooltip" title="{if (description != '') then description else @name}">
                        <span>
                            <img class="icon text" alt="{concat(portal:localize('Folder'), ' ', portal:localize('icon'))}" src="{portal:createResourceUrl(concat($path-to-skin, '/images/icon-folder.png'))}"/>
                            <xsl:value-of select="@name"/>
                        </span>
                    </div>
                    <div class="column date-modified">
                        <span>
                            <xsl:value-of select="util:format-date(@timestamp, $language, 'short', true())"/>
                        </span>
                    </div>
                    <div class="column size">
                        <span>--</span>
                    </div>
                    <div class="column kind">
                        <span>
                            <xsl:value-of select="portal:localize('Folder')"/>
                        </span>
                    </div>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="class">file</xsl:attribute>
                    <div class="column name tooltip" title="{if (contentdata/description != '') then contentdata/description else title}">
                        <span>
                            <xsl:call-template name="utilities.icon-image">
                                <xsl:with-param name="file-name" select="title"/>
                                <xsl:with-param name="icon-folder-path" select="concat($path-to-skin, '/images')"/>
                            </xsl:call-template>
                            <a href="{portal:createAttachmentUrl(@key, ('download', 'true'))}">
                                <xsl:value-of select="title"/>
                            </a>
                        </span>
                    </div>
                    <div class="column date-modified">
                        <span>
                            <xsl:value-of select="util:format-date(@timestamp, $language, 'short', true())"/>
                        </span>
                    </div>
                    <div class="column size">
                        <span>
                            <xsl:value-of select="util:format-bytes(binaries/binary[1]/@filesize)"/>
                        </span>
                    </div>
                    <div class="column kind">
                        <span>
                            <xsl:value-of select="util:file-type(title)"/>
                        </span>
                    </div>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="categories/category or /result/contents/content[category/@key = current()[name() = 'category']/@key]">
                <ul style="display: none;">
                    <xsl:apply-templates select="categories/category"/>
                    <xsl:apply-templates select="/result/contents/content[category/@key = current()[name() = 'category']/@key]"/>
                </ul>
            </xsl:if>
        </li>
    </xsl:template>
    
</xsl:stylesheet>