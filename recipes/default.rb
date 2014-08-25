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
ohai "reload" do
	action :nothing
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

template "/etc/authconfig/arguments" do
	source "arguments.erb"
	mode 0440
	owner "root"
	group "root"
	notifies :install, "package[autofs]" if node['authconfig']['autofs']['enable']
	notifies :run, "execute[authconfig-update]", :immediately
	notifies :reload, "service[autofs]", :immediately if node['authconfig']['autofs']['enable']
end

if node['authconfig']['kerberos']['enable']
	package 'pam_krb5' do
		action :install
	end

	package "krb5-workstation" do
		action :install
	end
end

if node[:platform_version].to_i == 6
	if node['authconfig']['ldap']['enable']
		package 'pam_ldap' do
			action :install
		end
	end

	package "sssd" do
		action :install
	end

	service "sssd" do
		supports :status => true, :restart => true, :reload => true
		# Avoid starting or restarting sssd if disabled,
		# especially when kerberos is enabled, and ldap not
		restart_command "/sbin/chkconfig sssd --list | grep -v :on || /sbin/service sssd restart"
		start_command "/sbin/chkconfig sssd --list | grep -v :on || /sbin/service sssd start"
	end

	execute "clean_sss_db" do
		command "rm -f /var/lib/sss/db/*"
		action :nothing
	end

	execute "restorecon /etc/sssd/sssd.conf" do
		action :nothing
	end

	template "/etc/sssd/sssd.conf" do
		source "sssd.conf.erb"
		mode 0600
		owner "root"
		group "root"
		notifies :run, "execute[clean_sss_db]", :immediately
		notifies :run, "execute[restorecon /etc/sssd/sssd.conf]", :immediately
		notifies :restart, "service[sssd]", :immediately
		notifies :reload, "ohai[reload]", :immediately
	end

elsif node[:platform_version].to_i == 5
	#ldap users don't work immediately, sleeping 60 seems to fix. TODO Fix this hack
	execute "sleep 60" do
		action :nothing
	end

	if node['authconfig']['ldap']['enable']
		package 'nss_ldap' do
			action :install
		end
	end

	template "/etc/ldap.conf" do
		source "ldap.conf.erb"
		mode 0644
		owner "root"
		group "root"
		notifies :run, "execute[sleep 60]", :immediately
		notifies :reload, "ohai[reload]", :immediately
	end
end
