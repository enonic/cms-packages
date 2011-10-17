<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:util="enonic:utilities" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:import href="/libraries/utilities/standard-variables.xsl"/>
    <xsl:include href="/libraries/utilities/utilities.xsl"/>

    <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>

    <xsl:param name="facebook-share-url" select="'http://www.facebook.com/share.php?u='"/>
    <xsl:param name="twitter-share-url" select="'http://twitter.com/home?status='"/>
    <xsl:param name="digg-share-url" select="'http://digg.com/submit?phase=2'"/>
    <xsl:param name="delicious-share-url" select="'http://del.icio.us/post'"/>

    <xsl:variable name="site-name" select="/result/context/site/name"/>
    <xsl:variable name="session-parameter" select="/result/context/session/attribute[@name = 'error_sendmail_send']/form/parameter"/>
    <xsl:variable name="error-sendmail-send" select="/result/context/querystring/parameter[@name = 'error_sendmail_send']"/>
    <xsl:variable name="current-url" select="/result/context/querystring/@url"/>

    <xsl:template match="/">
        <script type="text/javascript">
            <xsl:comment>
            
                $(function() {
                    
                    $('a.tip').click(function (event) {
                        event.preventDefault();
                        $('#share-bar-tip-dialog').dialog('open');
                    });
                    
                    $('#share-bar-tip-dialog').dialog({
                        autoOpen: false,
                        bgiframe: true,
                        <xsl:choose>
                            <xsl:when test="$device-class = 'mobile'">
                                <xsl:value-of select="concat('width: ', $region-width, ',')"/>
                                position: [$('#share-bar-tip-dialog').position().left, $('#share-bar-tip-dialog').position().top], height: $('#tip-form').outerHeight() + 220,
                            </xsl:when>
                            <xsl:otherwise>width: 500, height: $('#tip-form').outerHeight() + 100,</xsl:otherwise>
                        </xsl:choose>
                        modal: true,
                        close: function() {
                            $('#tip-form > .text, #tip-form > textarea').val('');
                        }
                    });
                        
                    $('#tip-form').validate({
                        ignoreTitle: true,
                        errorPlacement: function(label, element) {},
                        submitHandler: function (form) {
                            <xsl:value-of select="concat('$(&quot;#tip-tip&quot;).val(&quot;\n', portal:localize('Hi'), '!\n\n&quot; + $(&quot;#tip-from-name&quot;).val() + &quot; ', portal:localize('tip-mail-text', ($site-name, util:menuitem-name(/result/context/resource), $current-url)), '\n\n&quot; + $(&quot;#tip-from-name&quot;).val() + &quot; ', portal:localize('writes'), ':\n\n&quot; + $(&quot;#tip-message&quot;).val());')"/>
                            $.post($('#tip-form').attr('action'), $('#tip-form').serialize(), function (data) {
                                var result = $(data).find('#tip-form');
                                if ($(result).find('div.error').length != 0) {
                                    $('#tip-form').html(result.html());
                                    reloadCaptcha('tip-captcha-image');
                                } else {
                                    <xsl:text disable-output-escaping="yes">$('#tip-form').html('&lt;div class="success"&gt;</xsl:text>
                                    <xsl:value-of select="portal:localize('Your-tip-is-sent')"/>
                                    <xsl:text disable-output-escaping="yes">&lt;/div&gt;');</xsl:text>
                                    setTimeout(function() {
                                        $('#share-bar-tip-dialog').dialog('close');
                                        $('#tip-form').html(result.html());
                                        reloadCaptcha('tip-captcha-image');
                                    } , 2000);
                                }
                            });
                        }
                    });
                        
                });

            //</xsl:comment>
        </script>
        <div id="share-bar-tip-dialog" title="{portal:localize('Tip-a-friend')}">
            <form action="{portal:createServicesUrl('sendmail', 'send')}" method="post" id="tip-form" class="dont-validate">
                <fieldset>
                    <xsl:if test="$error-sendmail-send != ''">
                        <div class="error">
                            <xsl:value-of select="portal:localize(concat('sendmail-error-', $error-sendmail-send))"/>
                        </div>
                    </xsl:if>
                    <input name="subject" type="hidden" value="{portal:localize('tip-mail-subject', ($site-name))}"/>
                    <input name="{portal:localize('Tip')}" id="tip-tip" type="hidden"/>
                    <input name="sort_order" type="hidden" value="{portal:localize('Tip')}"/>
                    <label for="tip-to">
                        <xsl:value-of select="portal:localize('Recipient-email')"/>
                    </label>
                    <input type="text" id="tip-to" name="to" class="text email required">
                        <xsl:if test="$error-sendmail-send = 405">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$session-parameter[@name = 'to']"/>
                            </xsl:attribute>
                        </xsl:if>
                    </input>
                    <label for="tip-from-name">
                        <xsl:value-of select="portal:localize('Your-name')"/>
                    </label>
                    <input type="text" id="tip-from-name" name="from_name" class="text required">
                        <xsl:if test="$error-sendmail-send = 405">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$session-parameter[@name = 'from_name']"/>
                            </xsl:attribute>
                        </xsl:if>
                    </input>
                    <label for="tip-from-email">
                        <xsl:value-of select="portal:localize('Your-email')"/>
                    </label>
                    <input type="text" id="tip-from-email" name="from_email" class="text email required">
                        <xsl:if test="$error-sendmail-send = 405">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$session-parameter[@name = 'from_email']"/>
                            </xsl:attribute>
                        </xsl:if>
                    </input>
                    <label for="tip-message">
                        <xsl:value-of select="portal:localize('Message')"/>
                    </label>
                    <textarea id="tip-message" name="message" cols="5" rows="5">
                        <xsl:if test="$error-sendmail-send = 405">
                            <xsl:value-of select="$session-parameter[@name = 'message']"/>
                        </xsl:if>
                    </textarea>
                    <xsl:if test="not($user)">
                        <img src="{portal:createCaptchaImageUrl()}" alt="{portal:localize('Captcha-image')}" class="clear" id="tip-captcha-image"/>
                        <a href="#" onclick="reloadCaptcha('tip-captcha-image');return false;" class="clear">
                            <xsl:value-of select="portal:localize('New-image')"/>
                        </a>
                        <label for="tip-captcha">
                            <span class="tooltip" title="{concat(portal:localize('Repeat-text'), ' - ', portal:localize('helptext-captcha'))}">
                                <xsl:value-of select="portal:localize('Validation')"/>
                            </span>
                        </label>
                        <input type="text" id="tip-captcha" name="{portal:createCaptchaFormInputName()}" class="text required tooltip" title="{concat(portal:localize('Repeat-text'), ' - ', portal:localize('helptext-captcha'))}"/>
                    </xsl:if>
                    <input type="submit" class="button clear" value="{portal:localize('Send')}"/>
                    <input type="reset" class="button" value="{portal:localize('Reset')}"/>
                    <input type="button" class="button" value="{portal:localize('Cancel')}" onclick="$('#share-bar-tip-dialog').dialog('close');"/>
                </fieldset>
            </form>
        </div>
        <ul class="menu horizontal clear clearfix append-bottom share-bar">
            <xsl:if test="$device-class = 'mobile'">
                <xsl:attribute name="class">menu clear clearfix append-bottom share-bar</xsl:attribute>
            </xsl:if>
            <li class="first">
                <span>
                    <xsl:value-of select="concat(portal:localize('Share-this-content'), ':')"/>
                </span>
            </li>
            <li>
                <a href="#" class="tip">
                    <xsl:value-of select="portal:localize('Tip-a-friend')"/>
                </a>
            </li>
            <li>
                <a href="{concat($facebook-share-url, $current-url)}" class="facebook" rel="external">Facebook</a>
            </li>
            <li>
                <a href="{concat($twitter-share-url, util:menuitem-name(/result/context/resource), ' ', $current-url)}" class="twitter" rel="external">Twitter</a>
            </li>
            <li>
                <a href="{concat($digg-share-url, '&amp;url=', $current-url, '&amp;title=', util:menuitem-name(/result/context/resource))}" class="digg" rel="external">Digg</a>
            </li>
            <li>
                <a href="{concat($delicious-share-url, '?url=', $current-url, '&amp;title=', util:menuitem-name(/result/context/resource))}" class="delicious" rel="external">Delicious</a>
            </li>
        </ul>
    </xsl:template>

</xsl:stylesheet>
