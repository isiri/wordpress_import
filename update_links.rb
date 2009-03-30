require 'url_mapping.rb'

def update_permalinks

        logger = Logger.new('error.log')

	url_mapping_arr.each do |url_mapping|
	  new_post_url = url_mapping[0].strip
	  old_post_url = url_mapping[1].strip
	  if new_post_url == '' or old_post_url == '' or new_post_url.nil? or old_post_url.nil?
	    logger.error "ERROR UPDATING NEW-#{new_post_url}------OLD-#{old_post_url}"    
	  else
	    wp_post = WpPost.find_by_post_name(new_post_url)
	    unless wp_post.nil?	      
	      wp_post.update_attribute(:post_name, old_post_url)
	    else
	      logger.error "ERROR COULD NOT FIND NEW URL - #{new_post_url}"  
	    end
	  end
	end

end
