# Get DB config parameters from databag
appconfigdata = data_bag_item('configbag','appconfig_items')
# Get WEB config parameters from databag
webconfigdata = data_bag_item('configbag','webconfig_items')

# Use the execute resource to download and run the Node.js setup script as root
execute 'download_and_run_nodesource_setup' do
  command 'curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -'
  user 'root'
  action :run
  not_if 'dpkg -l | grep -E "^ii\s+nodejs\b"'  # Check if "nodejs" package is installed
end

# Install Node.js as root if it's not already installed
package 'nodejs' do
  action :install
  not_if 'dpkg -l | grep -E "^ii\s+nodejs\b"'  # Check if "nodejs" package is installed
end


# Use the execute resource to update npm to the latest version
execute 'update_npm' do
  command 'npm install -g npm@latest'
  user 'root'
  action :run
end

#install angular
#angular_cli

# Install the latest version of the Angular CLI globally
execute 'install_angular_cli' do
  command 'npm install -g @angular/cli@latest'
  user 'root'
  action :run
end

# recipes/install_nginx.rb

# Install Nginx
package 'nginx' do
  action :install
end

# Start and enable the Nginx service
service 'nginx' do
  action [:enable, :start]
end
target_directory = '/home/ubuntu/spring-petclinic-angular'

# Define the Git repository URL
repository_url = 'https://github.com/spring-petclinic/spring-petclinic-angular.git'

# Set the owner and group for the target directory to 'root'
directory target_directory do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Clone the Git repository as the root user
#execute 'clone_repository' do
  #command "cd  #{target_directory} && git clone #{repository_url}"
  #user 'root'
  #group 'root'
  #umask '022'  # Adjust the umask as needed
 # action :run
#end

git target_directory do
  repository repository_url
  revision 'master'
  action :sync
end
# Define the path to your configuration file
template '/home/ubuntu/spring-petclinic-angular/src/environments/environment.ts' do
  source 'environment.ts.erb'
  variables( APP_host: appconfigdata['APP_host'])
end

=begin
config_file = '/home/ubuntu/spring-petclinic-angular/src/environments/environment.ts'
host = node['PetClinic-Web']['App_host']

# Specify the updated REST_API_URL with the desired URL
new_api_url = "'http://#{host}:9966/petclinic/api/'"

# Read the content of the configuration file
ruby_block 'update_environment_config' do
  block do
    file_content = ::File.read(config_file)

    # Replace the old REST_API_URL value with the new value
    updated_content = file_content.gsub(/'http:\/\/.*?'/, new_api_url)

    # Write the updated content back to the configuration file
    File.open(config_file, 'w') { |file| file.write(updated_content) }
  end
  action :run
end
=end

# recipes/build_angular_app.rb

# Define the path to your Angular project directory
angular_project_dir = '/home/ubuntu/spring-petclinic-angular/'


execute 'npm_install' do
  command 'npm install'
  cwd angular_project_dir  # Set the working directory to the project directory
  action :run
end

# Execute the ng build command
execute 'ng_build' do
  command "cd #{angular_project_dir} && ng build"
  user 'root'  # Replace with the username that should run the command
  action :run
end



# recipes/configure_nginx.rb
template '/etc/nginx/sites-enabled/petclinic' do
  source 'petclinic.erb'
  variables( WEB_dns: webconfigdata['WEB_dns'])
end

=begin
# Define the path to your Nginx configuration file
nginx_config_file = '/etc/nginx/sites-enabled/petclinic'

# Specify the Nginx server block content
nginx_config_content = <<-CONFIG
server {
    listen 80;
    server_name dr-web1.synectiks.net;  # Your custom IP or domain

    root /home/ubuntu/spring-petclinic-angular/dist;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
CONFIG

# Use the file resource to create the Nginx configuration file and set its content
file nginx_config_file do
  content nginx_config_content
  mode '0644'  # Adjust permissions as needed
  action :create
end
=end

# Use the service resource to reload Nginx
service 'nginx' do
  action :reload
end
