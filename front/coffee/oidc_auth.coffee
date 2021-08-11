module = angular.module('taigaContrib.oidcAuth', [])

OIDCLoginButtonDirective = ($window, $params, $location, $config, $events, $confirm, $auth, $navUrls, $loader, $rootScope) ->
    # Login or register a user with their OIDC account.

    link = ($scope, $el, $attrs) ->

        loginSuccess = ->
            # Login in the UI. Using $auth.login() is too GitHub-specific.
            $auth.removeToken();
            data = _.clone($params, false);
            user = $auth.model.make_model("users", data);
            $auth.setToken(user.auth_token);
            $auth.setUser(user);
            $rootScope.$broadcast("auth:login", user)

            # Cleanup the URL

            $events.setupConnection()  # I don't know why this is necessary.

            scrub = (name, i) ->
                $location.search(name, null)
             [
                'accepted_terms', 'auth_token', 'big_photo', 'bio', 'color', 'date_joined',
                'email', 'full_name', 'full_name_display', 'gravatar_id', 'id', 'is_active',
                'lang', 'max_memberships_private_projects', 'max_memberships_public_projects',
                'max_private_projects', 'max_public_projects', 'next', 'photo', 'read_new_terms',
                'roles', 'theme', 'timezone', 'total_private_projects', 'total_public_projects',
                'type', 'username', 'uuid'
            ].forEach(scrub)

            # Redirect to the destination page.

            if $params.next and $params.next != $navUrls.resolve("login")
                nextUrl = $params.next
            else
                nextUrl = $navUrls.resolve("home")

            $location.path(nextUrl)

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
            console.log("WHOT")

            if $params.next and $params.next != $navUrls.resolve("login")
                nextUrl = $params.next
                console.log("next params", $params.next, " - ", nextUrl)
            else
                nextUrl = $navUrls.resolve("home")
                console.log("next home", nextUrl)

            base_url = $config.get("api", "/api/v1/").split('/').slice(0, -3).join("/")
            console.log("config: ", $config)
            console.log("base_url: ", base_url)

            url = urljoin(
                base_url,
                $config.get("oidcMountPoint", "/oidc"),
                "authenticate/"
            )
            url += "?next=" + nextUrl
            console.log("al final, url", url)
            $window.location.href = url

        $scope.$on "$destroy", ->
            $el.off()

        # Template context
        $scope.buttonText = $config.get("oidcButtonText", "OpenID Connect")
        $scope.buttonImage = $config.get("oidcButtonImage", "oidc-logo.gif")

    return {
        link: link
        restrict: "EA"
        template: ""
    }

module.directive("tgOidcLoginButton", [
   "$window", '$routeParams', "$tgLocation", "$tgConfig", "$tgEvents",
   "$tgConfirm", "$tgAuth", "$tgNavUrls", "tgLoader", "$rootScope",
   OIDCLoginButtonDirective])
