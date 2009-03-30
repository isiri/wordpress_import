require 'rubygems'
require 'mechanize'

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


def start_import

	agent = WWW::Mechanize.new
	page = agent.get('http://localhost/wordpress/wp-login.php/')

	login_form = page.form('loginform')
	login_form.log = 'admin'
	login_form.pwd = '*0&mp6#XofLm'

	page = agent.submit(login_form)

	page = agent.get('http://localhost/wordpress/wp-admin/admin.php?import=mt')

	import_form = page.forms[1]
	page = agent.submit(import_form)

	assign_users_form = page.forms[0]

	i = 0
	page.search('li').each do |l|
	  if l.parent.node_name == 'form'
	    select_list = assign_users_form.send("userselect[#{i}]")
	    select_list = l.search('strong').inner_html
	    i += 1
	  end
	end

	page = agent.submit(assign_users_form)

	return true

end
