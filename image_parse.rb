def process_images

	all_posts = WpPost.find(:all)

	all_posts.each do |post|
	  html_doc = Nokogiri::HTML(post.post_content)
	  (html_doc/"img").each do |img|  
	    img_src = img.attributes['src'].to_s
	    img_name = img_src.split('/').last
	    img_str = ''
	    img_src = "#{$root_url}/#{img_src}" unless img_src.match(/http/)
	    open(img_src.gsub(/ /,'%20')) {
		                           |f|                      
		                           img_str = f.read
		                          }    
            img_root = "/#{post.post_date.year}/#{"%02d" % post.post_date.month}"
	    dest_save_dir = "#{$wordpress_root}#{$site_root}/#{img_root}"                  
	    FileUtils.mkdir_p dest_save_dir
	    dest_save_image = "#{dest_save_dir}/#{img_name}"
	    dest_site_image = "#{$site_root}#{img_root}/#{img_name}"
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
