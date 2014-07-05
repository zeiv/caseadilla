require 'securerandom'

module Caseadilla
  class UsersController < Caseadilla::CaseadillaController
    filter_resource_access

    # before_filter :needs_admin, :except => [:show, :destroy, :update, :update_password]
    # before_filter :needs_or_current_user, :only => [:show, :destroy, :update, :update_password]
 
    def index
      @caseadilla_page_title = "Users"
      @users = User.order(sort_order(:id)).paginate :page => params[:page]
    end
 
    def new
      @caseadilla_page_title = "Add a new user"
    	@caseadilla_user = User.new
    	@caseadilla_user.time_zone = Rails.configuration.time_zone
    end
  
    def create

      generate_random_password if params[:generate_random_password]

      @caseadilla_user = User.new caseadilla_user_params
    
      if @caseadilla_user.save
        flash[:notice] = "An email has been sent to " + @caseadilla_user.first_name + " with the new account details"
        redirect_to caseadilla_users_path
      else
        flash.now[:warning] = "There were problems when trying to create a new user"
        render :action => :new
      end
    end
  
    def show
    	@caseadilla_user = User.find params[:id]
    	@caseadilla_page_title = "#{@caseadilla_user.first_name} #{@caseadilla_user.last_name} > View user"
    end
 
    def update
      @caseadilla_user = User.find params[:id]
      @caseadilla_page_title = "#{@caseadilla_user.first_name} #{@caseadilla_user.last_name} > Update user"

      if @caseadilla_user.update_attributes caseadilla_user_params
        flash[:notice] = "#{@caseadilla_user.first_name} #{@caseadilla_user.last_name} has been updated"
        redirect_to action: :index
      else
        flash.now[:warning] = "There were problems when trying to update this user"
        render :action => :show
        return
      end
    end
 
    def update_password
      @caseadilla_user = User.find params[:id]
      @caseadilla_page_title = "#{@caseadilla_user.first_name} #{@caseadilla_user.last_name} > Update password"
       
      if @caseadilla_user.valid_password? params[:form_current_password]
        if params[:caseadilla_user][:password].blank? && params[:caseadilla_user][:password_confirmation].blank?
          flash[:warning] = "New password cannot be blank"
        elsif @caseadilla_user.update_attributes caseadilla_user_params
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
      @caseadilla_user = User.find params[:id]
      @caseadilla_page_title = "#{@caseadilla_user.first_name} #{@caseadilla_user.last_name} > Reset password"
       
      if params[:generate_random_password].blank? && params[:caseadilla_user][:password].blank? && params[:caseadilla_user][:password_confirmation].blank?
        flash[:warning] = "New password cannot be blank"
      else
        generate_random_password if params[:generate_random_password]
        @caseadilla_user.notify_of_new_password = true unless (@caseadilla_user.id == @session_user.id && params[:generate_random_password].blank?)

        if @caseadilla_user.update_attributes caseadilla_user_params
          unless @caseadilla_user.notify_of_new_password
            flash[:notice] = "Your password has been reset"
          else    
            flash[:notice] = "Password has been reset and #{@caseadilla_user.first_name} #{@caseadilla_user.last_name} has been notified by email"
          end
        else
          flash[:warning] = "There were problems when trying to reset this user's password"
        end
      end

      redirect_to :action => :show
    end
 
    def destroy
      user = User.find params[:id]
      user.destroy
      flash[:notice] = "#{user.first_name} #{user.last_name} has been deleted"
      redirect_to caseadilla_users_path
    end

    private

      def generate_random_password
        random_password = random_string = SecureRandom.hex
        params[:user] = Hash.new if params[:user].blank?
        params[:user].merge! ({:password => random_password, :password_confirmation => random_password})
      end

      def caseadilla_user_params
        params.require(:user).permit(:email, :first_name, :last_name, :time_zone, :role, :role_id, :password, :password_confirmation)
      end
 
  end
end