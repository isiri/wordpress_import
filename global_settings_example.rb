#Rename this file to global_settings.rb and update the below configurations.
#TODO: cleaning up some of the duplication

#Global settings
require 'rubygems'
require 'activerecord'
require 'logger'
require 'open-uri'
require 'pathname'
require 'ftools'
require 'mechanize'
require 'fileutils'

#absoulte paths
$wordpress_root = '/var/www'
$wordpress_installation_path = '/var/www/wordpress'
$image_path = '/wp-contents/uploads'
$wordpress_import_file = '/var/www/wordpress/wp-content/mt-export.txt'

#relative paths
$split_file_path = 'splitted_files'

#file names
$wordpress_export_filename = 'mt-export.txt'
$split_filename = 'mt_export_txt_' # split files will be as mt_export_txt_0, mt_export_txt_1 etc.

#urls
$base_url = 'http://localhost/wordpress'
$root_url = 'http://localhost'
$site_root = '/wordpress/wp-content/uploads' #downloaded image store folder

#others
$allowed_length = 5000000 #size of individual files after splitting the export file. (splitting is done to avoid php memory limit error)
$wordpress_username = 'admin' #wordpress blog admin username
$wordpress_password = '' #wordpress blog admin password

ActiveRecord::Base.establish_connection(
  :adapter  => "",
  :database =>  "",
  :username =>  "",
  :password =>  "",
  :socket => ''
)

class WpPost < ActiveRecord::Base
  set_primary_key 'ID'
  set_table_name "wp_posts" 
end

class WpUser < ActiveRecord::Base
  set_primary_key 'ID'
  set_table_name "wp_users" 
end

#moneky patch to avoid timeout error
module Net 
    class BufferedIO
      def rbuf_fill
	#timeout(@read_timeout,ProtocolError) {
	  @rbuf << @io.sysread(1024)
	#}
      end  
    end
end 
