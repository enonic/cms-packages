<xsl:stylesheet exclude-result-prefixes="#all"
   xmlns="http://www.w3.org/1999/xhtml" version="2.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:fw="http://www.enonic.com/cms/xslt/framework"
   xmlns:portal="http://www.enonic.com/cms/xslt/portal"
   xmlns:util="http://www.enonic.com/cms/xslt/utilities">

   <xsl:template name="passport-lib.passport">
      <xsl:param name="user-image-src" tunnel="yes" as="xs:string?"/>
      <xsl:param name="dummy-user-image-src" tunnel="yes" as="xs:string?"/>
      <xsl:param name="user" as="element()?"/>
      <xsl:param name="email-login" tunnel="yes" as="xs:string?"/>
      <xsl:param name="edit-display-name" tunnel="yes" as="xs:string?"/>
      <xsl:param name="set-password" tunnel="yes" as="xs:string?"/>
      <xsl:param name="userstore" tunnel="yes" as="element()"/>
      <xsl:param name="time-zone" tunnel="yes" as="element()*"/>
      <xsl:param name="locale" tunnel="yes" as="element()*"/>
      <xsl:param name="country" tunnel="yes" as="element()*"/>
      <xsl:param name="language" as="xs:string?"/>
      <xsl:param name="error" tunnel="yes" as="element()?"/>
      <xsl:param name="success" tunnel="yes" as="element()?"/>
      <xsl:param name="session-parameter" tunnel="yes" as="element()*"/>
      <xsl:param name="group" as="element()*"/>
      <xsl:param name="join-group-key" tunnel="yes" as="element()*"/>
      <xsl:param name="admin-name" tunnel="yes" as="xs:string"/>
      <xsl:param name="admin-email" tunnel="yes" as="xs:string"/>
      <xsl:param name="site-name" as="xs:string"/>
      <xsl:variable name="operation">
         <xsl:choose>
            <xsl:when test="$error">
               <xsl:value-of select="substring-after($error/@name, 'error_user_')"/>
            </xsl:when>
            <xsl:when test="$success and not($success = 'resetpwd') and not($success = 'create')">
               <xsl:value-of select="$success"/>
            </xsl:when>
            <xsl:when test="$user">update</xsl:when>
            <xsl:otherwise>login</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <script type="text/javascript">
         <!--<xsl:comment>
            $(function() {
               <!-\- Selects correct tab -\->
               <xsl:value-of select="concat('$(&quot;.tabs&quot;).tabs(&quot;select&quot;, &quot;#passport-tabs-', $operation, '&quot;);')"/>
            });
            //</xsl:comment>-->
         //$('.tabs').tabs();
      </script>
      <div id="passport">
         <!-- Tabs -->
         <ul class="tabs" data-tabs="tabs">
            <xsl:choose>
               <!-- User logged in -->
               <xsl:when test="$user">
                  <li class="active">
                     <a href="#passport-tabs-update">
                        <xsl:value-of select="portal:localize('Update-account')"/>
                     </a>
                  </li>
                  <xsl:if test="$group">
                     <li>
                        <a href="#passport-tabs-setgroups">
                           <xsl:value-of select="portal:localize('Change-group-membership')"/>
                        </a>
                     </li>
                  </xsl:if>
                  <li>
                     <a href="#passport-tabs-changepwd">
                        <xsl:value-of select="portal:localize('Change-password')"/>
                     </a>
                  </li>
               </xsl:when>
               <!-- User not logged in -->
               <xsl:otherwise>
                  <li class="active">
                     <a href="#passport-tabs-login">
                        <xsl:value-of select="portal:localize('Login')"/>
                     </a>
                  </li>
                  <li>
                     <a href="#passport-tabs-create">
                        <xsl:value-of select="portal:localize('Register')"/>
                     </a>
                  </li>
                  <li>
                     <a href="#passport-tabs-resetpwd">
                        <xsl:value-of select="portal:localize('Forgot-your-password')"/>
                     </a>
                  </li>
               </xsl:otherwise>
            </xsl:choose>
         </ul>
         <!-- Tabs content -->
         <div class="tab-content">
         <xsl:choose>
            <!-- User logged in -->
            <xsl:when test="$user">
               <!-- Update account -->
               <div id="passport-tabs-update" class="active">
                  <xsl:call-template name="passport.user-feedback">
                     <xsl:with-param name="error-operation" select="'update'"/>
                  </xsl:call-template>
                  <xsl:call-template name="passport.user-form">
                     <xsl:with-param name="operation" select="'update'"/>
                  </xsl:call-template>
               </div>
               <!-- Change group membership -->
               <xsl:if test="$group">
                  <div id="passport-tabs-setgroups">
                     <xsl:call-template name="passport.user-feedback">
                        <xsl:with-param name="error-operation" select="'setgroups'"/>
                     </xsl:call-template>
                     <form action="{portal:createServicesUrl('user', 'setgroups', portal:createPageUrl(portal:getPageKey(), ('success', 'setgroups')), ())}" method="post">
                        <xsl:if test="$fw:device-class = 'mobile'">
                           <xsl:attribute name="class">form-stacked</xsl:attribute>
                        </xsl:if>
                        <fieldset>
                           <legend>
                              <xsl:value-of select="portal:localize('Groups')"/>
                           </legend>
                           <input name="allgroupkeys" type="hidden" value="{string-join($group/@key, ',')}"/>
                           <xsl:for-each select="$group">
                              <xsl:variable name="pos" select="position()"/>
                              <label for="passport-setgroups-group{@key}" class="checkbox">
                                 <span>
                                    <xsl:value-of select="."/>
                                 </span>
                                 <input name="joingroupkey" id="passport-setgroups-group{@key}" type="checkbox" class="checkbox" value="{@key}">
                                    <xsl:if test="$fw:user/groups/group[@key = current()/@key]">
                                       <xsl:attribute name="checked">checked</xsl:attribute>
                                    </xsl:if>
                                 </input>
                              </label>
                           </xsl:for-each>
                        </fieldset>
                        <div class="actions">
                           <input type="submit" class="btn" value="{portal:localize('Change')}"/>
                        </div>                           
                     </form>
                  </div>
               </xsl:if>
               <!-- Change password -->
               <div id="passport-tabs-changepwd">
                  <xsl:call-template name="passport.user-feedback">
                     <xsl:with-param name="error-operation" select="'changepwd'"/>
                  </xsl:call-template>
                  <form action="{portal:createServicesUrl('user', 'changepwd', portal:createPageUrl(portal:getPageKey(), ('success', 'changepwd')), ())}" method="post">
                     <xsl:if test="$fw:device-class = 'mobile'">
                        <xsl:attribute name="class">form-stacked</xsl:attribute>
                     </xsl:if>
                     <fieldset>
                        <legend>
                           <xsl:value-of select="portal:localize('Change-password')"/>
                        </legend>
                        
                        <div class="clearfix">
                           <label for="passport-changepwd-password">
                              <xsl:value-of select="portal:localize('Old-password')"/>
                           </label>
                           <div class="input">
                              <input type="password" id="passport-changepwd-password" name="password" class="text required"/>
                           </div>
                        </div>
                        
                        <div class="clearfix">
                           <label for="passport-changepwd-newpassword1">
                              <xsl:value-of select="portal:localize('New-password')"/>
                           </label>
                           <div class="input">
                              <input type="password" id="passport-changepwd-newpassword1" name="newpassword1" class="text required"/>
                           </div>
                        </div>
                        
                        <div class="clearfix">
                           <label for="passport-changepwd-newpassword2">
                              <xsl:value-of select="portal:localize('Repeat-new-password')"/>
                           </label>
                           <div class="input">
                              <input type="password" id="passport-changepwd-newpassword2" name="newpassword2" class="text required"/>
                           </div>
                        </div>
                        
                     </fieldset>
                     <div class="actions">
                        <input type="submit" class="btn" value="{portal:localize('Change')}"/>
                     </div>
                  </form>
               </div>
            </xsl:when>
            <!-- User not logged in -->
            <xsl:otherwise>
               <!-- Login -->
               <div id="passport-tabs-login" class="active">
                  <xsl:call-template name="passport.user-feedback">
                     <xsl:with-param name="error-operation" select="'login'"/>
                     <xsl:with-param name="success-operation" select="'create', 'resetpwd'"/>
                  </xsl:call-template>
                  <form action="{portal:createServicesUrl('user', 'login')}" method="post">
                     <xsl:if test="$fw:device-class = 'mobile'">
                        <xsl:attribute name="class">form-stacked</xsl:attribute>
                     </xsl:if>
                     <fieldset>
                        <legend>
                           <xsl:value-of select="portal:localize('Login')"/>
                        </legend>
                        <xsl:choose>
                           <xsl:when test="$email-login = 'true'">
                              <div class="clearfix">
                                 <label for="passport-login-email">
                                    <xsl:value-of select="portal:localize('E-mail')"/>
                                 </label>
                                 <div class="input">
                                    <input type="text" id="passport-login-email" name="email" class="text required email"/>
                                 </div>
                              </div>
                           </xsl:when>
                           <xsl:otherwise>
                              <div class="clearfix">
                                 <label for="passport-login-uid">
                                    <xsl:value-of select="portal:localize('Username')"/>
                                 </label>
                                 <div class="input">
                                    <input type="text" id="passport-login-uid" name="uid" class="text required"/>
                                 </div>
                              </div>
                           </xsl:otherwise>
                        </xsl:choose>
                        <div class="clearfix">
                           <label for="passport-login-password">
                              <xsl:value-of select="portal:localize('Password')"/>
                           </label>
                           <div class="input">
                              <input type="password" id="passport-login-password" name="password" class="text required"/>
                           </div>
                        </div>
                        
                        <div class="clearfix">
                           <label for="passport-login-rememberme" class="checkbox">
                              <span>
                                <span class="tooltip" title="{concat(portal:localize('Remember-me'), ' - ', portal:localize('helptext-remember-me'))}">
                                   <xsl:value-of select="portal:localize('Remember-me')"/>
                                </span>
                              </span>
                           </label>
                           <div class="input">
                              <input name="rememberme" id="passport-login-rememberme" type="checkbox" class="checkbox tooltip" value="true" title="{concat(portal:localize('Remember-me'), ' - ', portal:localize('helptext-remember-me'))}"/>
                           </div>
                        </div>
                     </fieldset>
                     <div class="actions">
                        <input type="submit" class="btn" value="{portal:localize('Login')}"/>
                     </div>
                  </form>
               </div>
               <!-- Register -->
               <div id="passport-tabs-create">
                  <xsl:call-template name="passport.user-feedback">
                     <xsl:with-param name="error-operation" select="'create'"/>
                     <xsl:with-param name="success-operation" select="''"/>
                  </xsl:call-template>
                  <xsl:call-template name="passport.user-form">
                     <xsl:with-param name="operation" select="'create'"/>
                  </xsl:call-template>
               </div>
               <!-- Forgot your password -->
               <div id="passport-tabs-resetpwd">
                  <xsl:if test="$email-login = 'true'">
                     <script type="text/javascript">
                        <xsl:comment>
                           $(function() {
                              $('#passport-resetpwd-form').submit(function () {
                                 var mailBody = $('#passport-resetpwd-mail-body').val();
                                 $('#passport-resetpwd-mail-body').val(mailBody.replace('%email%', $('#passport-resetpwd-id').val()));
                              });
                           });
                        //</xsl:comment>
                     </script>
                  </xsl:if>
                  <xsl:call-template name="passport.user-feedback">
                     <xsl:with-param name="error-operation" select="'resetpwd'"/>
                     <xsl:with-param name="success-operation" select="''"/>
                  </xsl:call-template>
                  <form action="{portal:createServicesUrl('user', 'resetpwd', portal:createPageUrl(portal:getPageKey(), ('success', 'resetpwd')), ())}" method="post" id="passport-resetpwd-form">
                     <xsl:if test="$fw:device-class = 'mobile'">
                        <xsl:attribute name="class">form-stacked</xsl:attribute>
                     </xsl:if>
                     <fieldset>
                        <legend>
                           <xsl:value-of select="portal:localize('Forgot-your-password')"/>
                        </legend>
                        
                        <input type="hidden" name="from_name" value="{$admin-name}"/>
                        <input type="hidden" name="from_email" value="{$admin-email}"/>
                        <input name="mail_subject" type="hidden" value="{portal:localize('Your-password')}"/>
                        <xsl:variable name="username">
                           <xsl:choose>
                              <xsl:when test="$email-login = 'true'">%email%</xsl:when>
                              <xsl:otherwise>%username%</xsl:otherwise>
                           </xsl:choose>
                        </xsl:variable>
                        <input name="mail_body" id="passport-resetpwd-mail-body" type="hidden" value="{portal:localize('resetpwd-mailbody', ($site-name, $username))}"/>
                        
                        <div class="clearfix">
                           <label for="passport-resetpwd-id">
                              <span class="tooltip" title="{concat(portal:localize('E-mail'), ' - ', portal:localize('user-notice-resetpwd'))}">
                                 <xsl:value-of select="portal:localize('E-mail')"/>
                              </span>
                           </label>
                           <div class="input">
                              <input type="text" id="passport-resetpwd-id" name="id" class="text email required tooltip" title="{concat(portal:localize('E-mail'), ' - ', portal:localize('user-notice-resetpwd'))}"/>
                           </div>
                        </div>
                        
                     </fieldset>
                     <div class="actions">
                        <input type="submit" class="btn" value="{portal:localize('Reset-password')}"/>
                     </div>
                  </form>
               </div>
            </xsl:otherwise>
         </xsl:choose>
         </div>
      </div>
   </xsl:template>

   <xsl:template name="passport.user-form">
      <xsl:param name="operation" as="xs:string"/>
      <xsl:param name="userstore" tunnel="yes" as="element()"/>
      <xsl:param name="join-group-key" tunnel="yes" as="element()*"/>
      <xsl:param name="admin-name" tunnel="yes" as="xs:string"/>
      <xsl:param name="admin-email" tunnel="yes" as="xs:string"/>
      <xsl:param name="email-login" tunnel="yes" as="xs:string?"/>
      <xsl:param name="edit-display-name" tunnel="yes" as="xs:string?"/>
      <xsl:param name="set-password" tunnel="yes" as="xs:string?"/>
      <xsl:param name="time-zone" tunnel="yes" as="element()*"/>
      <xsl:param name="locale" tunnel="yes" as="element()*"/>
      <xsl:param name="country" tunnel="yes" as="element()*"/>
      <xsl:param name="user-image-src" tunnel="yes" as="xs:string?"/>
      <xsl:param name="dummy-user-image-src" tunnel="yes" as="xs:string?"/>
      <xsl:param name="language" as="xs:string?"/>
      <xsl:param name="error" tunnel="yes" as="element()?"/>
      <xsl:param name="session-parameter" tunnel="yes" as="element()*"/>
      <script type="text/javascript">
         <xsl:comment>
            $(function() {
               <xsl:if test="$userstore/config/user-fields/address/@iso = 'true'">
                  $('#passport-create-address-country').change(function () {
                     $('.create-address-region:visible').hide();
                     $('.create-address-region:enabled').attr('disabled','disabled');
                     $('#passport-create-address-region-'+this.value+',label[for = create-address-region-'+this.value+']').show();
                     $('#passport-create-address-region-'+this.value+'').removeAttr('disabled');
                  });
               </xsl:if>
               <xsl:if test="$userstore/config/user-fields/birthday">
                  $('#passport-create-gui-birthday').datepicker('option', 'changeYear', true);
                  $('#passport-create-gui-birthday').datepicker('option', 'changeMonth', true);
               </xsl:if>
               <xsl:if test="$operation = 'create' or $userstore/config/user-fields/birthday">
                  $('#passport-user-form').submit(function () {
                     <xsl:if test="$operation = 'create'">
                        if ($('#passport-create-password').val() == '') {
                           $('#passport-create-password').attr('disabled','disabled');
                        }
                     </xsl:if>
                     <xsl:if test="$userstore/config/user-fields/birthday">
                        if ($('#passport-create-gui-birthday').val() != '') {
                           $('#passport-create-birthday').removeAttr('disabled');
                           var dateIn = $('#passport-create-gui-birthday').val();
                          <xsl:variable name="separator">
                             <xsl:choose>
                                <xsl:when test="$language = 'no'">.</xsl:when>
                                <xsl:otherwise>/</xsl:otherwise>
                             </xsl:choose>
                          </xsl:variable>
                          <xsl:value-of select="concat('var finalDate = dateIn.split(&quot;', $separator, '&quot;)[2] + &quot;-&quot; + dateIn.split(&quot;', $separator, '&quot;)[1] + &quot;-&quot; + dateIn.split(&quot;', $separator, '&quot;)[0];')"/>
                           $('#passport-create-birthday').val(finalDate);
                       }
                    </xsl:if>
                  });
               </xsl:if>
            });
         //</xsl:comment>
      </script>
      <form action="{portal:createServicesUrl('user', $operation, portal:createPageUrl(portal:getPageKey(), ('success', $operation)), ())}" id="passport-user-form" method="post" enctype="multipart/form-data">
         <xsl:if test="$fw:device-class = 'mobile'">
            <xsl:attribute name="class">form-stacked</xsl:attribute>
         </xsl:if>
         <fieldset>
            <legend>
               <xsl:value-of select="portal:localize('User')"/>
            </legend>
            <xsl:if test="$operation = 'create'">
               <input type="hidden" name="userstore" value="{$userstore/@key}"/>
               <xsl:for-each select="$join-group-key">
                  <input type="hidden" name="joingroupkey" value="{.}"/>
               </xsl:for-each>
               <!-- E-mail receipt -->
               <input type="hidden" name="from_name" value="{$admin-name}"/>
               <input type="hidden" name="from_email" value="{$admin-email}"/>
               <input type="hidden" name="admin_name" value="{$admin-name}"/>
               <input type="hidden" name="admin_email" value="{$admin-email}"/>
               <input type="hidden" name="admin_mail_subject" value="{concat('New user registered on ', $site-name)}"/>
               <input type="hidden" name="admin_mail_body">
                  <xsl:attribute name="value">
                     <xsl:value-of select="concat('Site: ', $site-name, '\nUserstore: ', $userstore/@name, '\nUsername: %username%')"/>
                     <xsl:if test="$join-group-key">
                        <xsl:text>\n\nAuto-joined the following groups:</xsl:text>
                        <xsl:for-each select="$join-group-key">
                           <xsl:value-of select="concat('\n', .)"/>
                        </xsl:for-each>
                     </xsl:if>
                  </xsl:attribute>
               </input>
               <input type="hidden" name="user_mail_subject" value="{portal:localize('create-mail-subject', ($site-name))}"/>
               <xsl:variable name="username">
                  <xsl:choose>
                     <xsl:when test="$email-login = 'true'">%email%</xsl:when>
                     <xsl:otherwise>%username%</xsl:otherwise>
                  </xsl:choose>
               </xsl:variable>
               <input type="hidden" name="user_mail_body" value="{portal:localize('create-mailbody', ($site-name, $username))}"/>
            </xsl:if>
            <!-- Display name -->
            <xsl:if test="$edit-display-name = 'true'">
               <div class="clearfix">
                  <label for="passport-create-display-name">
                     <xsl:value-of select="portal:localize('Display-name')"/>
                  </label>
                  <div class="input">
                     <input type="text" id="passport-create-display-name" name="display_name" class="text required">
                        <xsl:attribute name="value">
                           <xsl:choose>
                              <xsl:when test="$error = 405">
                                 <xsl:value-of select="$session-parameter[@name = 'display_name']"/>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:value-of select="$fw:user/display-name"/>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:attribute>
                     </input>
                  </div>
               </div>
            </xsl:if>
            <!-- E-mail -->
            <div class="clearfix">
               <label for="passport-create-email">
                  <xsl:value-of select="portal:localize('E-mail')"/>
               </label>
               <div class="input">
                  <input type="text" id="passport-create-email" name="email" class="text required email">
                     <xsl:attribute name="value">
                        <xsl:choose>
                           <xsl:when test="$error = 405">
                              <xsl:value-of select="$session-parameter[@name = 'email']"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$fw:user/email"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                  </input>
               </div>
            </div>
            <!-- Password -->
            <xsl:if test="$operation = 'create' and $set-password = 'true'">
               <div class="clearfix">
                  <label for="passport-create-password">
                     <span class="tooltip" title="{concat(portal:localize('Password'), ' - ', portal:localize('helptext-password'))}">
                        <xsl:value-of select="portal:localize('Password')"/>
                     </span>
                  </label>
                  <div class="input">
                     <input type="password" id="passport-create-password" name="password" class="text tooltip" title="{concat(portal:localize('Password'), ' - ', portal:localize('helptext-password'))}">
                        <xsl:if test="$error = 405">
                          <xsl:attribute name="value">
                             <xsl:value-of select="$session-parameter[@name = 'password']"/>
                          </xsl:attribute>
                        </xsl:if>
                     </input>
                  </div>
               </div>
            </xsl:if>
         </fieldset>
         <xsl:if test="$userstore/config/user-fields/prefix or $userstore/config/user-fields/first-name or $userstore/config/user-fields/middle-name or $userstore/config/user-fields/last-name or $userstore/config/user-fields/suffix or $userstore/config/user-fields/initials or $userstore/config/user-fields/nick-name">
            <fieldset>
               <legend>
                  <xsl:value-of select="portal:localize('Name')"/>
               </legend>
               <!-- Prefix -->
               <xsl:if test="$userstore/config/user-fields/prefix">
                  <div class="clearfix">
                  <label for="passport-create-prefix">
                     <xsl:value-of select="portal:localize('Prefix')"/>
                  </label>
                  <input type="text" id="passport-create-prefix" name="prefix">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/prefix/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                     <xsl:attribute name="value">
                        <xsl:choose>
                           <xsl:when test="$error = 405">
                              <xsl:value-of select="$session-parameter[@name = 'prefix']"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$fw:user/prefix"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                  </input>
                  </div>
               </xsl:if>
               <!-- First name -->
               <xsl:if test="$userstore/config/user-fields/first-name">
                  <div class="clearfix">
                  <label for="passport-create-first-name">
                     <xsl:value-of select="portal:localize('First-name')"/>
                  </label>
                  <input type="text" id="passport-create-first-name" name="first-name">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/first-name/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                     <xsl:attribute name="value">
                        <xsl:choose>
                           <xsl:when test="$error = 405">
                              <xsl:value-of select="$session-parameter[@name = 'first-name']"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$fw:user/first-name"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                  </input>
                     </div>
               </xsl:if>
               <!-- Middle name -->
               <xsl:if test="$userstore/config/user-fields/middle-name">
                  <div class="clearfix">
                  <label for="passport-create-middle-name">
                     <xsl:value-of select="portal:localize('Middle-name')"/>
                  </label>
                  <input type="text" id="passport-create-middle-name" name="middle-name">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/middle-name/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                     <xsl:attribute name="value">
                        <xsl:choose>
                           <xsl:when test="$error = 405">
                              <xsl:value-of select="$session-parameter[@name = 'middle-name']"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$fw:user/middle-name"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                  </input>
                  </div>
               </xsl:if>
               <!-- Last name -->
               <xsl:if test="$userstore/config/user-fields/last-name">
                  <div class="clearfix">
                  <label for="passport-create-last-name">
                     <xsl:value-of select="portal:localize('Last-name')"/>
                  </label>
                  <input type="text" id="passport-create-last-name" name="last-name">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/last-name/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                     <xsl:attribute name="value">
                        <xsl:choose>
                           <xsl:when test="$error = 405">
                              <xsl:value-of select="$session-parameter[@name = 'last-name']"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$fw:user/last-name"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                  </input>
                  </div>
               </xsl:if>
               <!-- Suffix -->
               <xsl:if test="$userstore/config/user-fields/suffix">
                  <div class="clearfix">
                  <label for="passport-create-suffix">
                     <xsl:value-of select="portal:localize('Suffix')"/>
                  </label>
                  <input type="text" id="passport-create-suffix" name="suffix">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/suffix/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                     <xsl:attribute name="value">
                        <xsl:choose>
                           <xsl:when test="$error = 405">
                              <xsl:value-of select="$session-parameter[@name = 'suffix']"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$fw:user/suffix"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                  </input>
                  </div>
               </xsl:if>
               <!-- Initials -->
               <xsl:if test="$userstore/config/user-fields/initials">
                  <div class="clearfix">
                  <label for="passport-create-initials">
                     <xsl:value-of select="portal:localize('Initials')"/>
                  </label>
                  <input type="text" id="passport-create-initials" name="initials">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/initials/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                     <xsl:attribute name="value">
                        <xsl:choose>
                           <xsl:when test="$error = 405">
                              <xsl:value-of select="$session-parameter[@name = 'initials']"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$fw:user/initials"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                  </input>
                  </div>
               </xsl:if>
               <!-- Nick name -->
               <xsl:if test="$userstore/config/user-fields/nick-name">
                  <div class="clearfix">
                  <label for="passport-create-nick-name">
                     <xsl:value-of select="portal:localize('Nick-name')"/>
                  </label>
                  <input type="text" id="passport-create-nick-name" name="nick-name">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/nick-name/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                     <xsl:attribute name="value">
                        <xsl:choose>
                           <xsl:when test="$error = 405">
                              <xsl:value-of select="$session-parameter[@name = 'nick-name']"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$fw:user/nick-name"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                  </input>
                  </div>
               </xsl:if>
            </fieldset>
         </xsl:if>
         <xsl:if test="$userstore/config/user-fields/photo">
            <fieldset>
               <legend>
                  <xsl:value-of select="portal:localize('Photo')"/>
               </legend>
               <!-- Photo -->
               <xsl:if test="$userstore/config/user-fields/photo">
                  <xsl:if test="$operation = 'update' and ($user-image-src != '' or $dummy-user-image-src != '')">
                     <div class="clearfix">
                     <label>
                        <xsl:value-of select="portal:localize('Photo')"/>
                     </label>
                     <img alt="{concat(portal:localize('Image-of'), ' ', $fw:user/display-name)}" src="{if ($user-image-src != '') then $user-image-src else $dummy-user-image-src}"/>
                     </div>
                  </xsl:if>
                  <div class="clearfix">
                  <label for="passport-create-photo">
                     <xsl:value-of select="if ($operation = 'update' and ($user-image-src != '' or $dummy-user-image-src != '')) then portal:localize('Replace-photo') else portal:localize('Photo')"/>
                  </label>
                  <input type="file" id="passport-create-photo" name="photo">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/photo/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                  </input>
                  </div>
               </xsl:if>
            </fieldset>
         </xsl:if>
         <xsl:if test="$userstore/config/user-fields/personal-id or $userstore/config/user-fields/member-id or $userstore/config/user-fields/organization or $userstore/config/user-fields/birthday or $userstore/config/user-fields/gender or $userstore/config/user-fields/title or $userstore/config/user-fields/description or $userstore/config/user-fields/html-email or $userstore/config/user-fields/home-page">
            <fieldset>
               <legend>
                  <xsl:value-of select="portal:localize('Personal-information')"/>
               </legend>
               <!-- Personal ID -->
               <xsl:if test="$userstore/config/user-fields/personal-id">
                  <div class="clearfix">
                  <label for="passport-create-personal-id">
                     <xsl:value-of select="portal:localize('Personal-id')"/>
                  </label>
                  <input type="text" id="passport-create-personal-id" name="personal-id">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/personal-id/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                     <xsl:attribute name="value">
                        <xsl:choose>
                           <xsl:when test="$error = 405">
                              <xsl:value-of select="$session-parameter[@name = 'personal-id']"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$fw:user/personal-id"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                  </input>
                  </div>
               </xsl:if>
               <!-- Member ID -->
               <xsl:if test="$userstore/config/user-fields/member-id">
                  <div class="clearfix">
                  <label for="passport-create-member-id">
                     <xsl:value-of select="portal:localize('Member-id')"/>
                  </label>
                  <input type="text" id="passport-create-member-id" name="member-id">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/member-id/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                     <xsl:attribute name="value">
                        <xsl:choose>
                           <xsl:when test="$error = 405">
                              <xsl:value-of select="$session-parameter[@name = 'member-id']"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$fw:user/member-id"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                  </input>
                  </div>
               </xsl:if>
               <!-- Organization -->
               <xsl:if test="$userstore/config/user-fields/organization">
                  <div class="clearfix">
                  <label for="passport-create-organization">
                     <xsl:value-of select="portal:localize('Organization')"/>
                  </label>
                  <input type="text" id="passport-create-organization" name="organization">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/organization/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                     <xsl:attribute name="value">
                        <xsl:choose>
                           <xsl:when test="$error = 405">
                              <xsl:value-of select="$session-parameter[@name = 'organization']"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$fw:user/organization"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                  </input>
                  </div>
               </xsl:if>
               <!-- Birthday -->
               <xsl:if test="$userstore/config/user-fields/birthday">
                  <xsl:variable name="separator">
                     <xsl:choose>
                        <xsl:when test="$language = 'no'">.</xsl:when>
                        <xsl:otherwise>/</xsl:otherwise>
                     </xsl:choose>
                  </xsl:variable>
                  <xsl:variable name="birthday">
                     <xsl:choose>
                        <xsl:when test="$error = 405">
                           <xsl:value-of select="$session-parameter[@name = 'birthday']"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="$fw:user/birthday"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:variable>
                  <xsl:variable name="localized-birthday">
                     <xsl:if test="$birthday != ''">
                        <xsl:value-of select="string-join(reverse(tokenize($birthday, '-')), $separator)"/>
                     </xsl:if>
                  </xsl:variable>
                  <div class="clearfix">
                  <label for="passport-create-gui-birthday">
                     <xsl:value-of select="portal:localize('Birthday')"/>
                  </label>
                  <input type="text" id="passport-create-gui-birthday" value="{$localized-birthday}">
                     <xsl:attribute name="class">
                        <xsl:text>text datepicker</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/birthday/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                  </input>
                  </div>
                  <input type="hidden" name="birthday" id="passport-create-birthday" disabled="disabled"/>
               </xsl:if>
               <!-- Gender -->
               <xsl:if test="$userstore/config/user-fields/gender">
                  <div class="clearfix">
                  <label for="passport-create-gender-female">
                     <xsl:value-of select="portal:localize('Gender')"/>
                  </label>
                  <label class="radio" for="passport-create-gender-female">
                     <input type="radio" id="passport-create-gender-female" name="gender" value="female">
                        <xsl:attribute name="class">
                           <xsl:text>radio</xsl:text>
                           <xsl:if test="$userstore/config/user-fields/gender/@required = 'true'">
                              <xsl:text> required</xsl:text>
                           </xsl:if>
                        </xsl:attribute>
                        <xsl:if test="$fw:user/gender = 'female' or ($error = 405 and $session-parameter[@name = 'gender'] = 'female')">
                           <xsl:attribute name="checked">checked</xsl:attribute>
                        </xsl:if>
                     </input>
                     <xsl:value-of select="portal:localize('Female')"/>
                  </label>
                  <label class="radio clear last" for="passport-create-gender-male">
                     <input type="radio" class="radio" id="passport-create-gender-male" name="gender" value="male">
                        <xsl:if test="$fw:user/gender = 'male' or ($error = 405 and $session-parameter[@name = 'gender'] = 'male')">
                           <xsl:attribute name="checked">checked</xsl:attribute>
                        </xsl:if>
                     </input>
                     <xsl:value-of select="portal:localize('Male')"/>
                  </label>
                  </div>
               </xsl:if>
               <!-- Title -->
               <xsl:if test="$userstore/config/user-fields/title">
                  <div class="clearfix">
                  <label for="passport-create-title">
                     <xsl:value-of select="portal:localize('Title')"/>
                  </label>
                  <input type="text" id="passport-create-title" name="title">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/title/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                     <xsl:attribute name="value">
                        <xsl:choose>
                           <xsl:when test="$error = 405">
                              <xsl:value-of select="$session-parameter[@name = 'title']"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$fw:user/title"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                  </input>
                  </div>
               </xsl:if>
               <!-- Description -->
               <xsl:if test="$userstore/config/user-fields/description">
                  <div class="clearfix">
                  <label for="passport-create-description">
                     <xsl:value-of select="portal:localize('Description')"/>
                  </label>
                  <textarea rows="5" cols="5" id="passport-create-description" name="description">
                     <xsl:if test="$userstore/config/user-fields/title/@required = 'true'">
                        <xsl:attribute name="class">required</xsl:attribute>
                     </xsl:if>
                     <xsl:choose>
                        <xsl:when test="$error = 405">
                           <xsl:value-of select="$session-parameter[@name = 'description']"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="$fw:user/description"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </textarea>
                  </div>
               </xsl:if>
               <!-- HTML e-mail -->
               <xsl:if test="$userstore/config/user-fields/html-email">
                  <div class="clearfix">
                  <label for="passport-create-html-email" class="checkbox">
                     <span>
                        <xsl:value-of select="portal:localize('Html-email')"/>
                     </span>
                     <input type="checkbox" class="checkbox" id="passport-create-html-email" name="html-email">
                        <xsl:if test="$userstore/config/user-fields/html-email/@required = 'true'">
                           <xsl:attribute name="class">required</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$fw:user/html-email = 'true' or ($error = 405 and ($session-parameter[@name = 'html-email'] = 'on' or $session-parameter[@name = 'html-email'] = 'true'))">
                           <xsl:attribute name="checked">checked</xsl:attribute>
                        </xsl:if>
                     </input>
                  </label>
                  </div>
               </xsl:if>
               <!-- Home page -->
               <xsl:if test="$userstore/config/user-fields/home-page">
                  <div class="clearfix">
                  <label for="passport-create-home-page">
                     <xsl:value-of select="portal:localize('Home-page')"/>
                  </label>
                  <input type="text" id="passport-create-home-page" name="home-page">
                     <xsl:attribute name="class">
                        <xsl:text>text url</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/home-page/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                     <xsl:attribute name="value">
                        <xsl:choose>
                           <xsl:when test="$error = 405">
                              <xsl:value-of select="$session-parameter[@name = 'home-page']"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$fw:user/home-page"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                  </input>
                  </div>
               </xsl:if>
            </fieldset>
         </xsl:if>
         <xsl:if test="($userstore/config/user-fields/time-zone and $time-zone) or ($userstore/config/user-fields/locale and $locale) or ($userstore/config/user-fields/country and $country) or $userstore/config/user-fields/global-position">
            <fieldset>
               <legend>
                  <xsl:value-of select="portal:localize('Location')"/>
               </legend>
               <!-- Time zone -->
               <xsl:if test="$userstore/config/user-fields/time-zone and $time-zone">
                  <div class="clearfix">
                  <label for="passport-create-time-zone">
                     <xsl:value-of select="portal:localize('Time-zone')"/>
                  </label>
                  <select id="passport-create-time-zone" name="time-zone">
                     <xsl:choose>
                        <xsl:when test="$userstore/config/user-fields/time-zone/@required = 'true'">
                           <xsl:attribute name="class">required</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                           <option value="">
                              <xsl:value-of select="concat('-- ', portal:localize('Select'), ' --')"/>
                           </option>
                        </xsl:otherwise>
                     </xsl:choose>
                     <xsl:for-each select="$time-zone">
                        <option value="{@ID}">
                           <xsl:if test="$fw:user/time-zone = @ID or ($error = 405 and $session-parameter[@name = 'time-zone'] = @ID)">
                              <xsl:attribute name="selected">selected</xsl:attribute>
                           </xsl:if>
                           <xsl:value-of select="concat(display-name, ' (', hours-from-utc-as-human-readable, ')')"/>
                        </option>
                     </xsl:for-each>
                  </select>
                  </div>
               </xsl:if>
               <!-- Locale -->
               <xsl:if test="$userstore/config/user-fields/locale and $locale">
                  <div class="clearfix">
                  <label for="passport-create-locale">
                     <xsl:value-of select="portal:localize('Language')"/>
                  </label>
                  <select id="passport-create-locale" name="locale">
                     <xsl:choose>
                        <xsl:when test="$userstore/config/user-fields/locale/@required = 'true'">
                           <xsl:attribute name="class">required</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                           <option value="">
                              <xsl:value-of select="concat('-- ', portal:localize('Select'), ' --')"/>
                           </option>
                        </xsl:otherwise>
                     </xsl:choose>
                     <xsl:for-each select="$locale">
                        <option value="{name}">
                           <xsl:if test="$fw:user/locale = name or ($error = 405 and $session-parameter[@name = 'locale'] = name)">
                              <xsl:attribute name="selected">selected</xsl:attribute>
                           </xsl:if>
                           <xsl:value-of select="display-name"/>
                        </option>
                     </xsl:for-each>
                  </select>
                  </div>
               </xsl:if>
               <!-- Country -->
               <xsl:if test="$userstore/config/user-fields/country and $country">
                  <div class="clearfix">
                  <label for="passport-create-country">
                     <xsl:value-of select="portal:localize('Country')"/>
                  </label>
                  <select id="passport-create-country" name="country">
                     <xsl:choose>
                        <xsl:when test="$userstore/config/user-fields/country/@required = 'true'">
                           <xsl:attribute name="class">required</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                           <option value="">
                              <xsl:value-of select="concat('-- ', portal:localize('Select'), ' --')"/>
                           </option>
                        </xsl:otherwise>
                     </xsl:choose>
                     <xsl:for-each select="$country">
                        <option value="{@code}">
                           <xsl:if test="$fw:user/country = @code or ($error = 405 and $session-parameter[@name = 'country'] = @code)">
                              <xsl:attribute name="selected">selected</xsl:attribute>
                           </xsl:if>
                           <xsl:value-of select="english-name"/>
                           <xsl:if test="local-name != '' and local-name != english-name">
                              <xsl:value-of select="concat(' (', local-name, ')')"/>
                           </xsl:if>
                        </option>
                     </xsl:for-each>
                  </select>
                  </div>
               </xsl:if>
               <!-- Global position -->
               <xsl:if test="$userstore/config/user-fields/global-position">
                  <div class="clearfix">
                  <label for="passport-create-global-position">
                     <xsl:value-of select="portal:localize('Global-position')"/>
                  </label>
                  <input type="text" id="passport-create-global-position" name="global-position">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/global-position/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                     <xsl:attribute name="value">
                        <xsl:choose>
                           <xsl:when test="$error = 405">
                              <xsl:value-of select="$session-parameter[@name = 'global-position']"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$fw:user/global-position"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                  </input>
                  </div>
               </xsl:if>
            </fieldset>
         </xsl:if>
         <xsl:if test="$userstore/config/user-fields/phone or $userstore/config/user-fields/mobile or $userstore/config/user-fields/fax">
            <fieldset>
               <legend>
                  <xsl:value-of select="portal:localize('Communication')"/>
               </legend>
               <!-- Phone -->
               <xsl:if test="$userstore/config/user-fields/phone">
                  <div class="clearfix">
                  <label for="passport-create-phone">
                     <xsl:value-of select="portal:localize('Phone')"/>
                  </label>
                  <input type="text" id="passport-create-phone" name="phone">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/phone/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                     <xsl:attribute name="value">
                        <xsl:choose>
                           <xsl:when test="$error = 405">
                              <xsl:value-of select="$session-parameter[@name = 'phone']"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$fw:user/phone"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                  </input>
                  </div>
               </xsl:if>
               <!-- Mobile -->
               <xsl:if test="$userstore/config/user-fields/mobile">
                  <div class="clearfix">
                  <label for="passport-create-mobile">
                     <xsl:value-of select="portal:localize('Mobile')"/>
                  </label>
                  <input type="text" id="passport-create-mobile" name="mobile">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/mobile/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                     <xsl:attribute name="value">
                        <xsl:choose>
                           <xsl:when test="$error = 405">
                              <xsl:value-of select="$session-parameter[@name = 'mobile']"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$fw:user/mobile"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                  </input>
                  </div>
               </xsl:if>
               <!-- Fax -->
               <xsl:if test="$userstore/config/user-fields/fax">
                  <div class="clearfix">
                  <label for="passport-create-fax">
                     <xsl:value-of select="portal:localize('Fax')"/>
                  </label>
                  <input type="text" id="passport-create-fax" name="fax">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/fax/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                     <xsl:attribute name="value">
                        <xsl:choose>
                           <xsl:when test="$error = 405">
                              <xsl:value-of select="$session-parameter[@name = 'fax']"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$fw:user/fax"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                  </input>
                  </div>
               </xsl:if>
            </fieldset>
         </xsl:if>
         <!-- Address -->
         <xsl:if test="$userstore/config/user-fields/address">
            <fieldset>
               <legend>
                  <xsl:value-of select="portal:localize('Address')"/>
               </legend>
               <div class="clearfix">
               <label for="passport-create-address-name">
                  <xsl:value-of select="portal:localize('Label')"/>
               </label>
               <input type="text" id="passport-create-address-name" name="address[0].label">
                  <xsl:attribute name="class">
                     <xsl:text>text</xsl:text>
                     <xsl:if test="$userstore/config/user-fields/address/@required = 'true'">
                        <xsl:text> required</xsl:text>
                     </xsl:if>
                  </xsl:attribute>
                  <xsl:attribute name="value">
                     <xsl:choose>
                        <xsl:when test="$error = 405">
                           <xsl:value-of select="$session-parameter[@name = 'address[0].label']"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="$fw:user/addresses/address[1]/label"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:attribute>
               </input>
               </div>
               
               <div class="clearfix">
               <label for="passport-create-address-street">
                  <xsl:value-of select="portal:localize('Street')"/>
               </label>
               <input type="text" id="passport-create-address-street" name="address[0].street">
                  <xsl:attribute name="class">
                     <xsl:text>text</xsl:text>
                     <xsl:if test="$userstore/config/user-fields/address/@required = 'true'">
                        <xsl:text> required</xsl:text>
                     </xsl:if>
                  </xsl:attribute>
                  <xsl:attribute name="value">
                     <xsl:choose>
                        <xsl:when test="$error = 405">
                           <xsl:value-of select="$session-parameter[@name = 'address[0].street']"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="$fw:user/addresses/address[1]/street"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:attribute>
               </input>
               </div>
               
               <div class="clearfix">
               <label for="passport-create-address-postal-code">
                  <xsl:value-of select="portal:localize('Postal-code')"/>
               </label>
               <input type="text" id="passport-create-address-postal-code" name="address[0].postal_code">
                  <xsl:attribute name="class">
                     <xsl:text>text</xsl:text>
                     <xsl:if test="$userstore/config/user-fields/address/@required = 'true'">
                        <xsl:text> required</xsl:text>
                     </xsl:if>
                  </xsl:attribute>
                  <xsl:attribute name="value">
                     <xsl:choose>
                        <xsl:when test="$error = 405">
                           <xsl:value-of select="$session-parameter[@name = 'address[0].postal_code']"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="$fw:user/addresses/address[1]/postal-code"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:attribute>
               </input>
               </div>
               
               <div class="clearfix">
               <label for="passport-create-address-postal-address">
                  <xsl:value-of select="portal:localize('Postal-address')"/>
               </label>
               <input type="text" id="passport-create-address-postal-address" name="address[0].postal_address">
                  <xsl:attribute name="class">
                     <xsl:text>text</xsl:text>
                     <xsl:if test="$userstore/config/user-fields/address/@required = 'true'">
                        <xsl:text> required</xsl:text>
                     </xsl:if>
                  </xsl:attribute>
                  <xsl:attribute name="value">
                     <xsl:choose>
                        <xsl:when test="$error = 405">
                           <xsl:value-of select="$session-parameter[@name = 'address[0].postal_address']"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="$fw:user/addresses/address[1]/postal-address"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:attribute>
               </input>
               </div>
               <xsl:if test="$country">
                  <div class="clearfix">
                  <label for="passport-create-address-country">
                     <xsl:value-of select="portal:localize('Country')"/>
                  </label>
                  <xsl:choose>
                     <xsl:when test="$userstore/config/user-fields/address/@iso = 'true'">
                        <select id="passport-create-address-country" name="address[0].iso_country">
                           <xsl:choose>
                              <xsl:when test="$userstore/config/user-fields/address/@required = 'true'">
                                 <xsl:attribute name="class">required</xsl:attribute>
                              </xsl:when>
                              <xsl:otherwise>
                                 <option value="">
                                    <xsl:value-of select="concat('-- ', portal:localize('Select'), ' --')"/>
                                 </option>
                              </xsl:otherwise>
                           </xsl:choose>
                           <xsl:for-each select="$country">
                              <option value="{@code}">
                                 <xsl:if test="$fw:user/addresses/address[1]/iso-country = @code or ($error = 405 and $session-parameter[@name = 'address[0].iso_country'] = @code)">
                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                 </xsl:if>
                                 <xsl:value-of select="english-name"/>
                                 <xsl:if test="local-name != '' and local-name != english-name">
                                    <xsl:value-of select="concat(' (', local-name, ')')"/>
                                 </xsl:if>
                              </option>
                           </xsl:for-each>
                        </select>
                     </xsl:when>
                     <xsl:otherwise>
                        <input type="text" id="passport-create-address-country" name="address[0].country">
                           <xsl:attribute name="class">
                              <xsl:text>text</xsl:text>
                              <xsl:if test="$userstore/config/user-fields/address/@required = 'true'">
                                 <xsl:text> required</xsl:text>
                              </xsl:if>
                           </xsl:attribute>
                           <xsl:attribute name="value">
                              <xsl:choose>
                                 <xsl:when test="$error = 405">
                                    <xsl:value-of select="$session-parameter[@name = 'address[0].country']"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="$fw:user/addresses/address[1]/country"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:attribute>
                        </input>
                     </xsl:otherwise>
                  </xsl:choose>
                  </div>
                  
                  <xsl:choose>
                     <xsl:when test="$userstore/config/user-fields/address/@iso = 'true'">
                        <xsl:for-each select="$country[regions/region]">
                           <div class="clearfix">
                           <label for="passport-create-address-region-{@code}" class="create-address-region">
                              <xsl:if test="not($fw:user/addresses/address[1]/iso-country = @code or ($error = 405 and $session-parameter[@name = 'address[0].iso_country'] = @code))">
                                 <xsl:attribute name="style">display: none;</xsl:attribute>
                              </xsl:if>
                              <xsl:value-of select="portal:localize('Region')"/>
                           </label>
                           <select id="passport-create-address-region-{@code}" name="address[0].iso_region" class="create-address-region">
                              <xsl:if test="not($fw:user/addresses/address[1]/iso-country = @code or ($error = 405 and $session-parameter[@name = 'address[0].iso_country'] = @code))">
                                 <xsl:attribute name="style">display: none;</xsl:attribute>
                                 <xsl:attribute name="disabled">disabled</xsl:attribute>
                              </xsl:if>
                              <option value="">
                                 <xsl:value-of select="concat('-- ', portal:localize('Select'), ' --')"/>
                              </option>
                              <xsl:for-each select="regions/region">
                                 <option value="{@code}">
                                    <xsl:if test="$fw:user/addresses/address[1]/iso-region = @code or ($error = 405 and $session-parameter[@name = 'address[0].iso_region'] = @code)">
                                       <xsl:attribute name="selected">selected</xsl:attribute>
                                    </xsl:if>
                                    <xsl:choose>
                                       <xsl:when test="local-name != ''">
                                          <xsl:value-of select="local-name"/>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <xsl:value-of select="english-name"/>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </option>
                              </xsl:for-each>
                           </select>
                           </div>
                        </xsl:for-each>
                     </xsl:when>
                     <xsl:otherwise>
                        <div class="clearfix">
                        <label for="passport-create-address-region">
                           <xsl:value-of select="portal:localize('Region')"/>
                        </label>
                        <input type="text" id="passport-create-address-region" name="address[0].region">
                           <xsl:attribute name="class">
                              <xsl:text>text</xsl:text>
                              <xsl:if test="$userstore/config/user-fields/address/@required = 'true'">
                                 <xsl:text> required</xsl:text>
                              </xsl:if>
                           </xsl:attribute>
                           <xsl:attribute name="value">
                              <xsl:choose>
                                 <xsl:when test="$error = 405">
                                    <xsl:value-of select="$session-parameter[@name = 'address[0].region']"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="$fw:user/addresses/address[1]/region"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:attribute>
                        </input>
                        </div>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:if>
            </fieldset>
         </xsl:if>
         <xsl:if test="$operation = 'create'">
            <fieldset>
               <legend>
                  <xsl:value-of select="portal:localize('Validation')"/>
               </legend>
               <div class="clearfix">
                  <div class="input">
                     <img src="{portal:createCaptchaImageUrl()}" alt="{portal:localize('Captcha-image')}" class="clear" id="passport-create-captcha-image" />
                     <br />
                     <a href="#" onclick="reloadCaptcha('passport-create-captcha-image');return false;" class="clear">
                        <xsl:value-of select="portal:localize('New-image')"/>
                     </a>
                  </div>
               </div>
               
               <div class="clearfix">
                  <label for="passport-create-captcha">
                     <span class="tooltip" title="{concat(portal:localize('Repeat-text'), ' - ', portal:localize('helptext-captcha'))}">
                        <xsl:value-of select="portal:localize('Validation')"/>
                     </span>
                  </label>
                  <div class="input">
                     <input type="text" id="passport-create-captcha" name="{portal:createCaptchaFormInputName()}" class="text required tooltip" title="{concat(portal:localize('Repeat-text'), ' - ', portal:localize('helptext-captcha'))}"/>
                  </div>
               </div>
            </fieldset>
         </xsl:if>
         <div class="actions">
            <input type="submit" class="btn">
               <xsl:attribute name="value">
                  <xsl:choose>
                     <xsl:when test="$operation = 'create'">
                        <xsl:value-of select="portal:localize('Register')"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="portal:localize('Update')"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
            </input>
         </div>
      </form>
   </xsl:template>

   <xsl:template name="passport.user-feedback">
      <xsl:param name="error" tunnel="yes" as="element()?"/>
      <xsl:param name="success" tunnel="yes" as="element()?"/>
      <xsl:param name="email-login" tunnel="yes" as="xs:string?"/>
      <xsl:param name="error-operation" as="xs:string"/>
      <xsl:param name="success-operation" as="xs:string+" select="$error-operation"/>
      <!-- User feedback -->
      <xsl:choose>
         <xsl:when test="substring-after($error/@name, 'error_user_') = $error-operation">
            <xsl:variable name="error-message">
               <xsl:value-of select="concat('user-error-', $error)"/>
               <xsl:if test="$error = 106 and $email-login = 'true'">-email</xsl:if>
            </xsl:variable>
            <div class="error">
               <xsl:value-of select="portal:localize($error-message)"/>
            </div>
         </xsl:when>
         <xsl:when test="$success = $success-operation">
            <div class="success">
               <xsl:value-of select="portal:localize(concat('user-success-', $success))"/>
            </div>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

</xsl:stylesheet>
