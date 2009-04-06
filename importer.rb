def start_import

	agent = WWW::Mechanize.new
	page = agent.get("#{$base_url}/wp-login.php/")

	login_form = page.form('loginform')
	login_form.log = $wordpress_username
	login_form.pwd = $wordpress_password

	page = agent.submit(login_form)

	page = agent.get("#{$base_url}/wp-admin/admin.php?import=mt")

	import_form = page.forms[1]
	page = agent.submit(import_form)

	assign_users_form = page.forms[0]

	i = 0
	page.search('li').each do |l|
	  if l.parent.node_name == 'form'	  
	    assign_users_form.set_fields("userselect[#{i}]" => l.search('strong').inner_html)	    
	    i += 1
	  end
	end
	page = agent.submit(assign_users_form)
        
        state = false
        page.search('h3').each do |h3_tag| 
          if h3_tag.inner_text.match(/All done/)           
            puts ("State All Done")
            state = true 
          end
        end
        
	return state

end
