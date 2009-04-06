def setup_top_level_cats
  FileUtils.cp_r "top-level-cats", "#{$wordpress_installation_path}/wp-content/plugins"
  File.chmod(0655, "#{$wordpress_installation_path}/wp-content/plugins/top-level-cats")
  File.chmod(0655, "#{$wordpress_installation_path}/wp-content/plugins/top-level-cats/top-level-cats.php")  
  
  agent = WWW::Mechanize.new
  page = agent.get("#{$base_url}/wp-login.php/")

  login_form = page.form('loginform')
  login_form.log = $wordpress_username
  login_form.pwd = $wordpress_password

  page = agent.submit(login_form)  
  page = agent.get("#{$base_url}/wp-admin/plugins.php")   
  page.search('td').each do |td|
    if td.inner_text.match(/Top Level Categories/)
      td.parent.search('a').each do |a|
        if a.text.match(/Activate/)
          page = agent.click(a) 
        end  
      end
    end
  end  
end
