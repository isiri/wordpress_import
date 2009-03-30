#Global settings
require 'rubygems'
require 'activerecord'
require 'logger'
require 'open-uri'
require 'pathname'
require 'ftools'
require 'mechanize'

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
$site_root = '/wordpress/wp-content/uploads'

#others
$allowed_length = 1000000 #size of individual files after splitting the export file
$wordpress_username = 'admin'
$wordpress_password = 'CwGeOAqFfCRn'

ActiveRecord::Base.establish_connection(
  :adapter  => "mysql",
  :database =>  "word_press2",
  :username =>  "root",
  :password =>  "isiri",
  :socket => '/tmp/mysql.sock'
)

class WpPost < ActiveRecord::Base
  set_primary_key 'ID'
  set_table_name "wp_posts" 
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
