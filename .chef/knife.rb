# See https://docs.chef.io/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "anbublacky"
client_key               "#{current_dir}/anbublacky.pem"
validation_client_name   "udproducts-validator"
validation_key           "#{current_dir}/udproducts-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/udproducts"
cookbook_path            ["#{current_dir}/../cookbooks"]

