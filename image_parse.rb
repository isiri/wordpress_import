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
	root_image_folder = '/var/www/wordpress/wp-content/uploads'
	i = 0

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
	    dest_dir = "#{root_image_folder}/#{post.post_date.year}/#{post.post_date.month}"                              
	    FileUtils.mkdir_p dest_dir        
	    dest_image = "#{dest_dir}/#{img_name}_#{i}"
	    File.open(dest_image, 'w') {|f| f.write(img_str) }          
	    img.attributes['src'].value = dest_image
	    if img.parent.node_name == 'a'
	      img.parent.attributes['href'].value = dest_image     
	    end
	    post.post_content = html_doc.inner_html         
	    post.save               
	    i += 1
	  end
	end  

end
