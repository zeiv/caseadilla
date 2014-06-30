require 'securerandom'

module Caseadilla
  class AdminUsersController < Caseadilla::CaseadillaController

    before_filter :needs_admin, :except => [:show, :destroy, :update, :update_password]
    before_filter :needs_admin_or_current_user, :only => [:show, :destroy, :update, :update_password]
 
    def index
      @caseadilla_page_title = "Users"
      @users = Caseadilla::AdminUser.order(sort_order(:login)).paginate :page => params[:page]
    end
 
    def new
      @caseadilla_page_title = "Add a new user"
    	@caseadilla_admin_user = Caseadilla::AdminUser.new
    	@caseadilla_admin_user.time_zone = Rails.configuration.time_zone
    end
  
    def create

      generate_random_password if params[:generate_random_password]

      @caseadilla_admin_user = Caseadilla::AdminUser.new caseadilla_admin_user_params
    
      if @caseadilla_admin_user.save
        flash[:notice] = "An email has been sent to " + @caseadilla_admin_user.name + " with the new account details"
        redirect_to caseadilla_admin_users_path
      else
        flash.now[:warning] = "There were problems when trying to create a new user"
        render :action => :new
      end
    end
  
    def show
    	@caseadilla_admin_user = Caseadilla::AdminUser.find params[:id]
    	@caseadilla_page_title = @caseadilla_admin_user.name + " > View user"
    end
 
    def update
      @caseadilla_admin_user = Caseadilla::AdminUser.find params[:id]
      @caseadilla_page_title = @caseadilla_admin_user.name + " > Update user"

      if @caseadilla_admin_user.update_attributes caseadilla_admin_user_params
        flash[:notice] = @caseadilla_admin_user.name + " has been updated"
      else
        flash.now[:warning] = "There were problems when trying to update this user"
        render :action => :show
        return
      end
      
      if @session_user.is_admin?
        redirect_to caseadilla_admin_users_path
      else
        redirect_to :controller => :caseadilla, :action => :index
      end
    end
 
    def update_password
      @caseadilla_admin_user = Caseadilla::AdminUser.find params[:id]
      @caseadilla_page_title = @caseadilla_admin_user.name + " > Update password"
       
      if @caseadilla_admin_user.valid_password? params[:form_current_password]
        if params[:caseadilla_admin_user][:password].blank? && params[:caseadilla_admin_user][:password_confirmation].blank?
          flash[:warning] = "New password cannot be blank"
        elsif @caseadilla_admin_user.update_attributes caseadilla_admin_user_params
          flash[:notice] = "Your password has been changed"
        else
          flash[:warning] = "There were problems when trying to change your password"
        end
      else
        flash[:warning] = "The current password is incorrect"
      end
      
      redirect_to :action => :show
    end
 
    def reset_password
      @caseadilla_admin_user = Caseadilla::AdminUser.find params[:id]
      @caseadilla_page_title = @caseadilla_admin_user.name + " > Reset password"
       
      if params[:generate_random_password].blank? && params[:caseadilla_admin_user][:password].blank? && params[:caseadilla_admin_user][:password_confirmation].blank?
        flash[:warning] = "New password cannot be blank"
      else
        generate_random_password if params[:generate_random_password]
        @caseadilla_admin_user.notify_of_new_password = true unless (@caseadilla_admin_user.id == @session_user.id && params[:generate_random_password].blank?)

        if @caseadilla_admin_user.update_attributes caseadilla_admin_user_params
          unless @caseadilla_admin_user.notify_of_new_password
            flash[:notice] = "Your password has been reset"
          else    
            flash[:notice] = "Password has been reset and " + @caseadilla_admin_user.name + " has been notified by email"
          end
        else
          flash[:warning] = "There were problems when trying to reset this user's password"
        end
      end

      redirect_to :action => :show
    end
 
    def destroy
      user = Caseadilla::AdminUser.find params[:id]
      if user.is_admin? == false || Caseadilla::AdminUser.has_more_than_one_admin
        user.destroy
        flash[:notice] = user.name + " has been deleted"
      end
      redirect_to caseadilla_admin_users_path
    end

    private

      def generate_random_password
        random_password = random_string = SecureRandom.hex
        params[:caseadilla_admin_user] = Hash.new if params[:caseadilla_admin_user].blank?
        params[:caseadilla_admin_user].merge! ({:password => random_password, :password_confirmation => random_password})
      end

      def caseadilla_admin_user_params
        params.require(:caseadilla_admin_user).permit(:login, :name, :email, :time_zone, :access_level, :password, :password_confirmation)
      end
 
  end
end