require 'rubygems'
require 'mechanize'

def configure_wordpress
	agent = WWW::Mechanize.new
	page = agent.get('http://localhost/wordpress/wp-login.php/')

	login_form = page.form('loginform')
	login_form.log = 'admin'
	login_form.pwd = 'dNdcCwtSg9VM'

	page = agent.submit(login_form)

	page = agent.get('http://localhost/wordpress/wp-admin/options-permalink.php')
	
        permalink_form = page.forms.first
        permalink_form.permalink_structure = '/%year%/%monthnum%/%postname%.html'
        
        page = agent.submit(permalink_form)          
end
