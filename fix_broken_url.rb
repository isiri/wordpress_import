def fix_broken_url
        logger = Logger.new('broken_url_fix.log')
	all_posts = WpPost.find(:all)

        broken_url_match = ['http://en.wikipedia.org/wiki/Hawthorne_effect', 
                            'http://www.nytimes.com/library/review/120698science-myths-review.html',                            
                           ]

	all_posts.each do |post|
	  html_doc = Nokogiri::HTML(post.post_content)
	  (html_doc/"a").each do |link|  
  	    link_ref = link.attributes['href'].to_s
	    if link_ref.match(Regexp.new(broken_url_match[0])) 
  	      link.attributes['href'].value = broken_url_match[0]
              post.post_content = html_doc.inner_html      
              puts "Updating post content for -#{post.post_name} - #{link.attributes['href']}"   
              logger.error "Updating post content for -#{post.post_name} - #{link.attributes['href']}"   
  	      post.save	    	    
  	    end  
	    if link_ref.match(Regexp.new(broken_url_match[1]))
  	      link.attributes['href'].value = broken_url_match[1]
              post.post_content = html_doc.inner_html      
              puts "Updating post content for -#{post.post_name} - #{link.attributes['href']}"   
              logger.error "Updating post content for -#{post.post_name} - #{link.attributes['href']}"              
  	      post.save	    
	    end	    
	    if link_ref.to_s.strip.match(/^www/)
	      link.attributes['href'].value = "#http://{link.attributes['href']}"
	      post.post_content = html_doc.inner_html         
              puts "Updating post content for -#{post.post_name}"   	      
              logger.error "Updating post content for -#{post.post_name} - #{link.attributes['href']}"              
  	      post.save
	    end
	  end	  
	end 
	
	all_comments = WpComment.find(:all) 
          all_comments.each do |comment|
	  html_doc = Nokogiri::HTML(comment.comment_content)
	  (html_doc/"a").each do |link|  
  	    link_ref = link.attributes['href'].to_s	
	    if link_ref.to_s.strip.match(/^www/)
	      link.attributes['href'].value = "#http://#{link.attributes['href']}"
	      comment.comment_content = html_doc.inner_html         
              puts "Updating comment content for -#{comment.comment_ID} - #{link.attributes['href']}"   	      
              logger.error "Updating post content for -#{comment.comment_ID} - #{link.attributes['href']}"              
  	      comment.save
	    end  	    
  	  end
  	end    
end
