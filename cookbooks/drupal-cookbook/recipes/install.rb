# Copyright 2015 Gabor Takacs

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe 'composer::install'
include_recipe 'activelamp_drupal::drush'

drupal_dir = node['apache']['docroot_dir']

execute 'download_drupal' do
	if Dir.exist?(drupal_dir)
		only_if "#{(Dir.entries(drupal_dir) - %w{ . .. }).empty?}"
	end
	command 'sudo /usr/local/bin/drush dl drupal --drupal-project-rename=drupal -y'
	cwd '/var/www'
end

service 'httpd' do
	action :nothing
end

execute 'install_drupal' do
	if Dir.exist?(drupal_dir)
		only_if "#{(Dir.entries(drupal_dir) - %w{ . .. }).empty?}"
	end
	command "sudo /usr/local/bin/drush site-install --db-url='mysql://root:#{node['mysql']['server_root_password']}@#{node['drupal-cookbook']['db']['host']}/mysql' --account-name='#{node['drupal-cookbook']['install']['admin_user']}' --account-pass='#{node['drupal-cookbook']['install']['admin_pass']}' -y"
	cwd drupal_dir
	# notifies :restart, 'service[apache2]', :immediately
end

template '/var/www/drupal/.htaccess' do
  source 'htaccess.erb'
  mode '0644'
  owner 'root'
  group 'root'
end

execute 'remove module' do
	command "sudo rm /etc/apache2/mods-enabled/access_compat.load"
end

execute 'restart_apache' do
	command "sudo service apache2 restart"
end
