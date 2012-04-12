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
	command "/bin/cat /etc/authconfig/arguments | /usr/bin/xargs /usr/sbin/authconfig --update"
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
	notifies :run, "execute[authconfig-update]", :immediately
	notifies :reload, "service[autofs]"
end

template "/etc/nsswitch.conf" do
        source "nsswitch.conf.erb"
        mode 0600
        owner "root"
        group "root"
end

template "/etc/krb5.conf" do
        source "krb5.conf.erb"
        mode 0600
        owner "root"
        group "root"
        variables(
        	:kdcserver=>node['authconfig']['kerberos']['kdcserver'],
		:adminserver=>node['authconfig']['kerberos']['adminserver']
        )
end


if node[:platform_version].to_i == 6
	service "sssd" do
		supports :status => true, :restart => true, :reload => true
	end

	execute "restorecon /etc/sssd/sssd.conf" do
		action :nothing
	end
	template "/etc/sssd/sssd.conf" do
		source "sssd.conf.erb"
		mode 0600
		owner "root"
		group "root"
		variables(
			:ldap_uri=>node['authconfig']['ldap']['server'],
			:bind_dn=>node['authconfig']['ldap']['dnbase'],
			:bind_pw=>node['authconfig']['ldap']['basepw']
		)
		notifies :run, "execute[restorecon /etc/sssd/sssd.conf]", :immediately
		notifies :restart, "service[sssd]"
	end
elsif node[:platform_version].to_i == 5
#        template "/etc/nsswitch.conf" do
#                source "nsswitch.conf.erb"
#                mode 0600
#                owner "root"
#                group "root"
#	end
        template "/etc/ldap.conf" do
                source "ldap.conf.erb"
                mode 0600
                owner "root"
                group "root"
                variables(
                        :ldap_uri=>node['authconfig']['ldap']['server'],
                        :bind_dn=>node['authconfig']['ldap']['dnbase'],
                        :bind_pw=>node['authconfig']['ldap']['basepw']
                )
        end
#        template "/etc/krb5.conf" do
#                source "krb5.conf.erb"
#                mode 0600
#                owner "root"
#                group "root"
#                variables(
#                        :bind_dn=>node['authconfig']['ldap']['dnbase']
#                )
#        end

end
