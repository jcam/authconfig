#
# Cookbook Name:: authconfig
# Attribute File:: defaults
#
# Copyright 2008-2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['authconfig']['ldap']['bind_dn'] = 'cn=users,dc=setg,dc=local'
default['authconfig']['ldap']['bind_pw'] = 'b4qhLZH0'
default['authconfig']['ldap']['uri'] = 'ldap://dc01.ops.atl.setg'
default['authconfig']['sssd']['enable'] = false
default['authconfig']['sssd']['auth'] = false
default['authconfig']['sssd']['forcelegacy'] = false
default['authconfig']['sssd']['cachecreds'] = true
default['authconfig']['sssd']['auth_provider']= 'ldap'
default['authconfig']['sssd']['ldap_group_member']= ldap'
default['authconfig']['sssd']['ldap_tls_cacertdir']= '/etc/openldap/cacerts'
default['authconfig']['sssd']['ldap_tls_reqcert']= 'never'
default['authconfig']['sssd']['ldap_auth_disable_tls_never_use_in_production']= true
