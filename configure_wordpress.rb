def configure_wordpress
	agent = WWW::Mechanize.new
	page = agent.get("#{$base_url}/wp-login.php/")

	login_form = page.form('loginform')
	login_form.log = $wordpress_username
	login_form.pwd = $wordpress_password

	page = agent.submit(login_form)

	page = agent.get("#{$base_url}/wp-admin/options-permalink.php")
	
        permalink_form = page.forms.first
        permalink_form.permalink_structure = '/%year%/%monthnum%/%postname%.html'
        
        page = agent.submit(permalink_form)          
end
