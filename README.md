Taiga contrib Fedora OIDC auth
==============================

The Taiga plugin for Fedora's OIDC (OpenID Connect) provider. It has been
forked off https://github.com/fedora-infra/taiga-contrib-fas-openid-auth.

Flow diagram
------------

Roughly, this is how it works

```
taiga-front             taiga-back         Fedora OIDC
------------------------------------------------------

add an OIDC
  button
    |
    V
  click  -----------> generate link
                           |
                           *--302----------> auth?
                                               |
                   verify and store <----302---*
                    user in the db
                           |
  verify <----302----------*
and update
the UI to
say welcome!
```

Installation
------------

### Taiga Back

In your Taiga back python virtualenv install the pip package `taiga-contrib-oidc-auth` with:

```bash
  pip install taiga-contrib-oidc-auth
```

Modify your `settings/local.py` and include the lines:

```python
INSTALLED_APPS += [
    "mozilla_django_oidc",
    "taiga_contrib_oidc_auth",
]

AUTHENTICATION_BACKENDS = list(AUTHENTICATION_BACKENDS) + [
    "taiga_contrib_oidc_auth.oidc.TaigaOIDCAuthenticationBackend",
]

# Add the OIDC urls
ROOT_URLCONF = "settings.urls"

# OIDC Settings
OIDC_CALLBACK_CLASS = "taiga_contrib_oidc_auth.views.TaigaOIDCAuthenticationCallbackView"
OIDC_RP_SCOPES = "openid profile email"
OIDC_RP_SIGN_ALGO = "RS256"
# Set the OIDC provider here.
OIDC_BASE_URL = "https://id.fedoraproject.org/openidc"
# Those URL values work for Ipsilon.
OIDC_OP_JWKS_ENDPOINT = OIDC_BASE_URL + "/Jwks"
OIDC_OP_AUTHORIZATION_ENDPOINT = OIDC_BASE_URL + "/Authorization"
OIDC_OP_TOKEN_ENDPOINT = OIDC_BASE_URL + "/Token"
OIDC_OP_USER_ENDPOINT = OIDC_BASE_URL + "/UserInfo"
# These two are private! Don't commit them to VCS. Getting the values from
# environment variables is a good way.
import os
OIDC_RP_CLIENT_ID = os.getenv("OIDC_RP_CLIENT_ID")
OIDC_RP_CLIENT_SECRET = os.getenv("OIDC_RP_CLIENT_SECRET")
```

Create a `settings/urls.py` containing:

```python
from taiga.urls import *
urlpatterns += [
    url(r"^oidc/", include("mozilla_django_oidc.urls")),
]
```

Now you need a `client_id` and a `client_secret`. If you haven't registered
with your OIDC provider yet and self-registration is allowed, you may run:

```bash
  pip install oidc-register
  oidc-register http://oidc-provider.example.com
```

It will generate a `client_secrets.json` file that contains the `client_id` and
`client_secret` values that you must use. With the example `settings.py`
directives above, you can pass those values as environment variables
(`OIDC_RP_CLIENT_ID` and `OIDC_RP_CLIENT_SECRET`) when you run the backend API
(taiga-back).


### Taiga Front

Build the frontend plugin:

```bash
  cd front
  npm install
  npm install gulp
  ./node_modules/.bin/gulp build
```

If you already have Gulp on your system, you may just call `gulp build` instead
of the last two lines.

Download in your `dist/plugins/` directory of Taiga front the `taiga-oidc-auth`compiled code (you need subversion in your system):

```bash
  cd $TAIGA_FRONT/dist/
  mkdir -p plugins
  cd plugins
  svn export "https://github.com/kaleidos-ventures/taiga-oidc-auth/tags/stable/front/dist" "oidc-auth"
```

Include in your `$TAIGA_FRONT/dist/conf.json` in the `contribPlugins` list the
value `"/plugins/oidc-auth/oidc-auth.json"`:

```json
...
    "contribPlugins": ["plugins/oidc-auth/oidc-auth.json"],
...
```

## Configuration

You can change the button logo and text by setting the `oidcButtonText` and
`oidcButtonImage` configuration values in `$TAIGA_FRONT/dist/conf.json`. For
example, if you are using Fedora's OIDC provider, you may set:

```json
...
    "oidcButtonText": "Fedora",
    "oidcButtonImage": "oidc-logo.gif",
...
```

If you set a different logo, you must copy the file in
`$TAIGA_FRONT/dist/plugins/oidc-auth/images/`.

If you want to mount the `mozilla_django_oidc` app on a different location in
taiga-back, you can change the moint point in `$TAIGA_BACK/settings/urls.py`
and adjust the frontend by defining the `oidcMountPoint` variable in the
`$TAIGA_FRONT/dist/conf.json` file. Example:

```json
...
    "oidcMountPoint": "/api/oidc",
...
```

The value defaults to `/oidc`, as used in the examples above. Mounting it
inside the `/api` namespace may make your HTTP proxy configuration easier.
