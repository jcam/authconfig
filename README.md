Description
===========

Manages authentication configuration CentOS / RHEL 5.x.

Auth libraries supported in this recipe:
winbind, nis, wins, ldap, kerberos, hesiod, smartcard, and more...

Requirements
============

This cookbook requires RHEL or CentOS 5.x, and newer.
It has not been tested on other platforms.

Notes
-----

This was developed for CentOS 6, some options do not work in previous versions
Let me know if you find a bug, related to one of the recipes.

Individual Recipe Usage:
=======================

authconfig::default
----------------

# Attributes

- Look at attributes/defaults.rb, there are many many attributes.

License and Author
==================

Author:: Jesse Campbell
Copyright:: 2011

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
