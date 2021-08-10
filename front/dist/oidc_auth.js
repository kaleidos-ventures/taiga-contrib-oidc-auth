angular.module("templates").run(["$templateCache",function($templateCache){$templateCache.put("/plugins/oidc-auth/oidc_auth.html",'\n<div tg-oidc-login-button="tg-oidc-login-button"><a href="" title="Enter with your {{ buttonText }} account" class="button button-auth"><img src="plugins/oidc-auth/images/{{ buttonImage }}" alt="" style="vertical-align:middle"/><span>{{ buttonText }}</span></a></div>')}]),function(){var OIDCLoginButtonDirective,module;module=angular.module("taigaContrib.oidcAuth",[]),OIDCLoginButtonDirective=function($window,$params,$location,$config,$events,$confirm,$auth,$navUrls,$loader,$rootScope){var link;return link=function($scope,$el,$attrs){var loginError,loginSuccess,loginWithOIDCAccount;return loginSuccess=function(){var data,nextUrl,scrub,user;return $auth.removeToken(),data=_.clone($params,!1),user=$auth.model.make_model("users",data),$auth.setToken(user.auth_token),$auth.setUser(user),$rootScope.$broadcast("auth:login",user),$events.setupConnection(),scrub=function(name,i){return $location.search(name,null)},["accepted_terms","auth_token","big_photo","bio","color","date_joined","email","full_name","full_name_display","gravatar_id","id","is_active","lang","max_memberships_private_projects","max_memberships_public_projects","max_private_projects","max_public_projects","next","photo","read_new_terms","roles","theme","timezone","total_private_projects","total_public_projects","type","username","uuid"].forEach(scrub),nextUrl=$params.next&&$params.next!==$navUrls.resolve("login")?$params.next:$navUrls.resolve("home"),$location.path(nextUrl)},loginError=function(){var error_description;return error_description=$params.error_description,$location.search("type",null),$location.search("error",null),$location.search("error_description",null),error_description?$confirm.notify("light-error",error_description):$confirm.notify("light-error","Our Oompa Loompas have not been able to get you credentials from GitHub.")},loginWithOIDCAccount=function(){var auth_token,type;if(type=$params.type,auth_token=$params.auth_token,"oidc"===type)return $params.error?loginError():loginSuccess()},loginWithOIDCAccount(),$el.on("click",".button-auth",function(event){var base_url,nextUrl,url;return nextUrl=$params.next&&$params.next!==$navUrls.resolve("login")?$params.next:$navUrls.resolve("home"),base_url=$config.get("api","/api/v1/").split("/").slice(0,-3).join("/"),url=urljoin(base_url,$config.get("oidcMountPoint","/oidc"),"authenticate/"),url+="?next="+nextUrl,$window.location.href=url}),$scope.$on("$destroy",function(){return $el.off()}),$scope.buttonText=$config.get("oidcButtonText","OpenID Connect"),$scope.buttonImage=$config.get("oidcButtonImage","oidc-logo.gif")},{link:link,restrict:"EA",template:""}},module.directive("tgOidcLoginButton",["$window","$routeParams","$tgLocation","$tgConfig","$tgEvents","$tgConfirm","$tgAuth","$tgNavUrls","tgLoader","$rootScope",OIDCLoginButtonDirective])}.call(this),function(name,context,definition){"undefined"!=typeof module&&module.exports?module.exports=definition():"function"==typeof define&&define.amd?define(definition):context[name]=definition()}("urljoin",this,function(){function normalize(strArray){var resultArray=[];if(0===strArray.length)return"";if("string"!=typeof strArray[0])throw new TypeError("Url must be a string. Received "+strArray[0]);if(strArray[0].match(/^[^\/:]+:\/*$/)&&strArray.length>1){var first=strArray.shift();strArray[0]=first+strArray[0]}strArray[0].match(/^file:\/\/\//)?strArray[0]=strArray[0].replace(/^([^\/:]+):\/*/,"$1:///"):strArray[0]=strArray[0].replace(/^([^\/:]+):\/*/,"$1://");for(var i=0;i<strArray.length;i++){var component=strArray[i];if("string"!=typeof component)throw new TypeError("Url must be a string. Received "+component);""!==component&&(i>0&&(component=component.replace(/^[\/]+/,"")),component=i<strArray.length-1?component.replace(/[\/]+$/,""):component.replace(/[\/]+$/,"/"),resultArray.push(component))}var str=resultArray.join("/");str=str.replace(/\/(\?|&|#[^!])/g,"$1");var parts=str.split("?");return str=parts.shift()+(parts.length>0?"?":"")+parts.join("&")}return function(){var input;return input="object"==typeof arguments[0]?arguments[0]:[].slice.call(arguments),normalize(input)}});