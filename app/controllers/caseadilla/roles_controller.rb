module Caseadilla
  class RolesController < Caseadilla::CaseadillaController
    filter_resource_access
  
    ## optional filters for defining usage according to Caseadilla::AdminUser access_levels
    # before_filter :needs_admin, :except => [:action1, :action2]
    # before_filter :needs_admin_or_current_user, :only => [:action1, :action2]
  
    def index
      @caseadilla_page_title = 'Roles'
  		@roles = Role.order(sort_order(:title)).paginate :page => params[:page]
    end
  
    def show
      @caseadilla_page_title = 'View role'
      @role = Role.find params[:id]
    end
  
    def new
      @caseadilla_page_title = 'Add a new role'
    	@role = Role.new
    end

    def create
      @role = Role.new role_params
    
      if @role.save
        flash[:notice] = 'Role created'
        redirect_to caseadilla_roles_path
      else
        flash.now[:warning] = 'There were problems when trying to create a new role'
        render :action => :new
      end
    end
  
    def update
      @caseadilla_page_title = 'Update role'
      
      @role = Role.find params[:id]
    
      if @role.update_attributes role_params
        flash[:notice] = 'Role has been updated'
        redirect_to caseadilla_roles_path
      else
        flash.now[:warning] = 'There were problems when trying to update this role'
        render :action => :show
      end
    end
 
    def destroy
      @role = Role.find params[:id]

      @role.destroy
      flash[:notice] = 'Role has been deleted'
      redirect_to caseadilla_roles_path
    end
  
    private
      
      def role_params
        params.require(:role).permit(:title)
      end

  end
end