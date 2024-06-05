module = angular.module('taigaContrib.oidcAuth', [])

OIDCLoginButtonDirective = ($window, $params, $location, $config, $events, $confirm, $auth, $navUrls, $rootScope) ->
    # Login or register a user with their OIDC account.

    link = ($scope, $el, $attrs) ->

        loginSuccess = ->
            if $params.next and $params.next != $navUrls.resolve("login")
                nextUrl = $params.next
            else
                nextUrl = $navUrls.resolve("home")

            $events.setupConnection()

            $auth.removeToken();
            data = JSON.parse($params.data);

            user = $auth.model.make_model("users", data);
            $auth.setToken(user.auth_token);
            $auth.setRefreshToken(user.refresh)
            $auth.setUser(user);
            $rootScope.$broadcast("auth:login", user)

            $window.location.href = nextUrl

        loginError = ->
            error_description = $params.error_description

            $location.search("type", null)
            $location.search("error", null)
            $location.search("error_description", null)

            if error_description
                $confirm.notify("light-error", error_description)
            else
                $confirm.notify("light-error", "Our Oompa Loompas have not been able to get you
                                                credentials from GitHub.")  #TODO: i18n

        loginWithOIDCAccount = ->
            type = $params.type
            auth_token = $params.auth_token

            return if not (type == "oidc")

            if $params.error
                loginError()
            else
                loginSuccess()

        loginWithOIDCAccount()

        $el.on "click", ".button-auth", (event) ->
            if $params.next and $params.next != $navUrls.resolve("login")
                nextUrl = $params.next
            else
                nextUrl = $navUrls.resolve("home")
            base_url = $config.get("api", "/api/v1/").split('/').slice(0, -3).join("/")
            url = urljoin(
                base_url,
                $config.get("oidcMountPoint", "/oidc"),
                "authenticate/"
            )
            url += "?next=" + nextUrl
            $window.location.href = url

        $scope.$on "$destroy", ->
            $el.off()

        # Template context
        $scope.buttonText = $config.get("oidcButtonText", "OpenID Connect")
        $scope.buttonImage = $config.get("oidcButtonImage", "logo.gif")

    return {
        link: link
        restrict: "EA"
        template: ""
    }

module.directive("tgOidcLoginButton", [
   "$window", '$routeParams', "$tgLocation", "$tgConfig", "$tgEvents",
   "$tgConfirm", "$tgAuth", "$tgNavUrls", "$rootScope",
   OIDCLoginButtonDirective])
