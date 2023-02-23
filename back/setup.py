#!/usr/bin/env python
# -*- coding: utf-8 -*-

from setuptools import setup, find_packages

setup(
    name="taiga-contrib-oidc-auth",
    version="0.3",
    description="The Taiga plugin for OIDC authentication",
    long_description="",
    keywords="taiga, oidc, openid, fedora, auth, plugin",
    author="Aurelien Bompard",
    author_email="aurelien@bompard.org",
    url="https://github.com/fedora-infra/taiga-contrib-fas-openid-auth",
    license="AGPL",
    include_package_data=True,
    packages=find_packages(),
    install_requires=[
        "django > 2, < 3",
        "mozilla-django-oidc",
        "six",
    ],
    classifiers=[
        "Programming Language :: Python",
        "Development Status :: 4 - Beta",
        "Framework :: Django",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: GNU Affero General Public License v3",
        "Operating System :: OS Independent",
        "Programming Language :: Python",
        "Topic :: Internet :: WWW/HTTP",
    ],
)
