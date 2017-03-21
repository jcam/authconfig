#
# Cookbook Name:: authconfig

# Recipe:: default
#
# Copyright 2012, Jesse Campbell
#
# All rights reserved - Do Not Redistribute
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

# Determine sssd_action in recipe so that wrapper cookbooks can override attribute
sssd_action = nil
nslcd_enable = false
case node['platform']
when 'redhat', 'centos', 'scientific'
  case node['platform_version'].to_i
  when 7
    sssd_action = 'install'
    # CentOS 7 requires authconfig update to avoid bugs with multiple LDAP servers
    authconfig_action = 'upgrade'
    node.default['authconfig']['ldap']['packages'] = ['nss-pam-ldapd']
  when 6
    node.default['authconfig']['ldap']['packages'] = ['nss-pam-ldapd','pam_ldap']
    case node['authconfig']['sssd']['enable']
    when true
      sssd_action = 'install'
    when false
      sssd_action = 'remove'
      nslcd_enable = true
    end
    authconfig_action = 'install'
  when 5
    node.default['authconfig']['ldap']['packages'] = []
    case node['authconfig']['sssd']['enable']
    when true
      sssd_action = 'install'
    when false
      sssd_action = 'remove'
      nslcd_enable = false
    end
    #must be current
    authconfig_action = 'upgrade'
  else
    node.default['authconfig']['ldap']['packages'] = ['nss_ldap']
    nslcd_enable = true
    authconfig_action = 'install'
  end

when 'amazon'
  node.default['authconfig']['ldap']['packages'] = ['nss-pam-ldapd','pam_ldap']
  authconfig_action = 'install'

else
  Chef::Log.info( "AuthConfig: Only Redhat-based systems are supported at this time." )
  return
end

# All platforms need the authconfig package
package 'authconfig' do
  action authconfig_action
end

# Install or Remove SSSD as appropriate
package 'sssd' do
  action sssd_action
  not_if { sssd_action.nil? }
end

# Add or remove the LDAP packages as appropriate
#  so that authconfig can modify their configuration files
if node['authconfig']['ldap']['enable']
  if node['authconfig']['sssd']['enable']
    ldappkg_action = 'remove'
    sssdldap_action = 'install'
  else
    ldappkg_action = 'install'
    sssdldap_action = 'install'
  end
else
    ldappkg_action = 'remove'
    sssdldap_action = 'remove'
end
node['authconfig']['ldap']['packages'].each do |pkgname|
  package pkgname do
    action ldappkg_action
  end
end

# Run the authconfig script, only on arguments file change
execute "authconfig-update" do
	command "/bin/cat /etc/authconfig/arguments | /usr/bin/xargs /usr/sbin/authconfig --updateall"
	action :nothing
end

package 'autofs' do
	action :nothing
end

#user changes require reloading of ohai for later recipes to use them
#TODO  only load certain plugins? (passwd)
ohai 'reload_passwd' do
  action :nothing
  plugin 'etc'
end

service "autofs" do
	supports :status => true, :restart => true, :reload => true
end

directory "/etc/authconfig" do
	owner "root"
	group "root"
	mode "0755"
	action :create
end

if node['authconfig']['kerberos']['enable']
	package 'pam_krb5' do
		action :install
	end

	package "krb5-workstation" do
		action :install
	end
end

# SSSD configuration if installed
if sssd_action == 'install'

  execute 'restorecon /etc/sssd/sssd.conf' do
    action :nothing
  end

	execute "clean_sss_db" do
		command "rm -f /var/lib/sss/db/*"
		action :nothing
	end

  directory '/etc/sssd' do
    mode 0600
    owner 'root'
    group 'root'
    action :create
  end

 	template '/etc/sssd/sssd.conf' do
 		source 'sssd.conf.erb'
		mode 0600
 		owner 'root'
 		group 'root'
 		notifies :run, 'execute[clean_sss_db]', :immediately
 		notifies :run, 'execute[restorecon /etc/sssd/sssd.conf]', :immediately if node['platform_version'].to_f >= 6
 		notifies :restart, 'service[sssd]', :delayed
 		notifies :reload, 'ohai[reload_passwd]', :immediately
 	end
end

service "sssd" do
  supports :status => true, :restart => true, :reload => true
  # Avoid starting or restarting sssd if disabled,
  # especially when kerberos is enabled, and ldap not
  restart_command "/sbin/chkconfig sssd --list | grep -v :on || /sbin/service sssd restart"
  start_command "/sbin/chkconfig sssd --list | grep -v :on || /sbin/service sssd start"
  action :nothing
end

# Do this last so it modifies all other config files correctly
template '/etc/authconfig/arguments' do
  source 'arguments.erb'
  mode 0440
  owner 'root'
  group 'root'
  notifies :install, 'package[autofs]' if node['authconfig']['autofs']['enable']
  notifies :run, 'execute[authconfig-update]', :immediately
  notifies :reload, 'service[sssd]', :immediately if sssd_action == 'install'
  notifies :reload, 'service[autofs]', :immediately if node['authconfig']['autofs']['enable']
  notifies :reload, 'ohai[reload_passwd]', :immediately if sssd_action != 'install'
end

service 'nslcd' do
  supports :restart => true, :status => true
  action   [:enable, :start]
  only_if  { nslcd_enable }
end

if node['platform_version'].to_i == 5
	#ldap users don't work immediately, sleeping 60 seems to fix. TODO Fix this hack
	execute 'sleep 60' do
		action :nothing
	end

	template '/etc/ldap.conf' do
		source 'ldap.conf.erb'
		mode 0644
		owner "root"
		group "root"
		notifies :run, 'execute[sleep 60]', :immediately
		notifies :reload, 'ohai[reload_passwd]', :immediately
	end
end
