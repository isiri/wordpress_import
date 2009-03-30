require 'rubygems'
require 'pathname'
require 'open-uri'
require 'nokogiri'
require 'activerecord'

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

def process_images

	all_posts = WpPost.find(:all)
	wordpress_root = '/var/www'
	site_root = '/wordpress/wp-content/uploads'

	all_posts.each do |post|
	  html_doc = Nokogiri::HTML(post.post_content)
	  (html_doc/"img").each do |img|  
	    img_src = img.attributes['src'].to_s
	    img_name = img_src.split('/').last
	    img_str = ''
	    open(img_src.gsub(/ /,'%20')) {
		                           |f|                      
		                           img_str = f.read
		                          }    
            img_root = "/#{post.post_date.year}/#{post.post_date.month}"
	    dest_save_dir = "#{wordpress_root}#{site_root}/#{img_root}"                  
	    FileUtils.mkdir_p dest_save_dir
	    dest_save_image = "#{dest_save_dir}/#{img_name}"
	    dest_site_image = "#{site_root}/#{img_root}/#{img_name}"
	    File.open(dest_save_image, 'w') {|f| f.write(img_str) }          
	    img.attributes['src'].value = dest_site_image
	    if img.parent.node_name == 'a'
	      img.parent.attributes['href'].value = dest_site_image     
	    end
	    post.post_content = html_doc.inner_html         
	    post.save               
	  end
	end  

end
