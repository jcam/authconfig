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

default['authconfig']['shadow']['enable'] = true
default['authconfig']['md5']['enable'] = true
default['authconfig']['passalgo'] = 'sha512'
default['authconfig']['nis']['enable'] = false
default['authconfig']['nis']['domain'] = ''
default['authconfig']['nis']['server'] = ''
default['authconfig']['ldap']['enable'] = false
default['authconfig']['ldap']['auth'] = false
default['authconfig']['ldap']['server'] = 'ldap://dc01.ops.atl.setg'
default['authconfig']['ldap']['basedn'] = 'cn=LDAP-bind,cn=users,dc=setg,dc=local'
default['authconfig']['ldap']['basepw'] = 'b4qhLZH0'
default['authconfig']['ldap']['starttls'] = false
default['authconfig']['ldap']['ssl'] = false
default['authconfig']['ldap']['tls'] = false
default['authconfig']['ldap']['rfc2307bis'] = false
default['authconfig']['ldap']['cacerturl'] = ''
default['authconfig']['smartcard']['enable'] = false
default['authconfig']['smartcard']['require'] = false
default['authconfig']['smartcard']['module'] = ''
default['authconfig']['smartcard']['removalaction'] = ''
default['authconfig']['fingerprint']['enable'] = false
default['authconfig']['kerberos']['enable'] = false
default['authconfig']['kerberos']['kdcserver'] = 'dc01.ops.atl.setg'
default['authconfig']['kerberos']['adminserver'] = 'dc01.ops.atl.setg'
default['authconfig']['kerberos']['realm'] = 'EXAMPLE.COM'
default['authconfig']['kerberos']['kdcdns'] = false
default['authconfig']['kerberos']['realmdns'] = false
default['authconfig']['winbind']['enable'] = false
default['authconfig']['winbind']['auth'] = false
default['authconfig']['winbind']['smb']['auth'] = false
default['authconfig']['winbind']['smb']['security'] = 'user'
default['authconfig']['winbind']['smb']['realm'] = ''
default['authconfig']['winbind']['smb']['servers'] = ''
default['authconfig']['winbind']['smb']['workgroup'] = 'MYGROUP'
default['authconfig']['winbind']['smb']['idmapuid'] = '16777216-33554431'
default['authconfig']['winbind']['smb']['idmapgid'] = '16777216-33554431'
default['authconfig']['winbind']['separator'] = '\\\\'
default['authconfig']['winbind']['template']['homedir'] = '/home/%D/%U'
default['authconfig']['winbind']['template']['primarygroup'] = 'nobody'
default['authconfig']['winbind']['template']['shell'] = '/bin/false'
default['authconfig']['winbind']['usedefaultdomain'] = true
default['authconfig']['winbind']['offline'] = false
default['authconfig']['winbind']['join'] = false
default['authconfig']['wins']['enable'] = false
default['authconfig']['preferdns']['enable'] = false
default['authconfig']['hesiod']['enable'] = false
default['authconfig']['hesiod']['lhs'] = ''
default['authconfig']['hesiod']['rhs'] = ''
default['authconfig']['sssd']['enable'] = false
default['authconfig']['sssd']['auth'] = false
default['authconfig']['sssd']['forcelegacy'] = false
default['authconfig']['sssd']['cachecreds'] = true
#default['authconfig']['sssd']['insertlines'] = Array.new
default['authconfig']['sssd']['auth_provider']= 'ldap'
default['authconfig']['sssd']['ldap_group_member']= 'ldap'
default['authconfig']['sssd']['ldap_tls_cacertdir']= '/etc/openldap/cacerts'
default['authconfig']['sssd']['ldap_tls_reqcert']= 'never'
default['authconfig']['sssd']['ldap_auth_disable_tls_never_use_in_production']= true
default['authconfig']['cachecreds'] = false
default['authconfig']['localauth'] = true
default['authconfig']['pamaccess'] = false
default['authconfig']['sysnetauth'] = false
default['authconfig']['mkhomedir'] = false
