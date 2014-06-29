module Caseadilla
  
  class CaseadillaNotification < ActionMailer::Base
	
  	self.prepend_view_path File.join(File.dirname(__FILE__), '..', 'views', 'caseadilla')
	
  	def generate_new_password from, caseadilla_admin_user, host, pass
  		@name = caseadilla_admin_user.name
  		@host = host
  		@login = caseadilla_admin_user.login
  		@pass = pass
  		@from_text = caseadilla_config_website_name
  		
  		mail(:to => caseadilla_admin_user.email, :from => from, :subject => "[#{caseadilla_config_website_name}] New password")
  	end
  
  	def new_user_information from, caseadilla_admin_user, host, pass
      @name = caseadilla_admin_user.name
  		@host = host
  		@login = caseadilla_admin_user.login
  		@pass = pass
  		@from_text = caseadilla_config_website_name
  		
  		mail(:to => caseadilla_admin_user.email, :from => from, :subject => "[#{caseadilla_config_website_name}] New user account")
  	end
  	
  	def password_reset_instructions from, caseadilla_admin_user, host
  	  ActionMailer::Base.default_url_options[:host] = host.gsub("http://", "")
      @name = caseadilla_admin_user.name
      @host = host
      @login = caseadilla_admin_user.login
      @reset_password_url = edit_caseadilla_password_reset_url + "/?token=#{caseadilla_admin_user.perishable_token}"
      @from_text = caseadilla_config_website_name

      mail(:to => caseadilla_admin_user.email, :from => from, :subject => "[#{caseadilla_config_website_name}] Password reset instructions")
    end

  end
end