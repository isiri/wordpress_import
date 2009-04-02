def update_users
  users = WpUser.find(:all, :conditions => "user_login != '' and user_login != 'admin'")
  
  agent = WWW::Mechanize.new
  page = agent.get("#{$base_url}/wp-login.php/")

  login_form = page.form('loginform')
  login_form.log = $wordpress_username
  login_form.pwd = $wordpress_password

  page = agent.submit(login_form)  
  
  users.each do |user|
    page = agent.get("#{$base_url}/wp-admin/user-edit.php?user_id=#{user.id}") 
    
    user_form = page.forms[0]    
    if ((user_form.email == "" or user_form.email.nil?) and user_form.role == 'subscriber')
      user_form.role = 'author'
      user_form.email = 'change@me.com'
      user_form.pass1 = 'change_this_password'
      user_form.pass2 = 'change_this_password'
      page = agent.submit(user_form)    
    end
        
  end
end
