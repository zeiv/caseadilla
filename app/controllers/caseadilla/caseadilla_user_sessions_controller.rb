module Caseadilla
  class CaseadillaUserSessionsController < Caseadilla::CaseadillaController
    
    skip_before_action :require_sign_in, :only => [:new, :create]
    before_filter :requires_no_session_user, :except => [:destroy]
  
    layout 'caseadilla_auth'
  
    def new
      @user_session = nil
    end
  
    def create
      @user_session = nil
      if @user_session.save
        redirect_back_or_default :controller => :caseadilla, :action => :index
      else
        render :action => :new
      end
    end
  
    def destroy
      current_user_session.destroy
      redirect_back_or_default new_caseadilla_user_session_url
    end

  private
  
    def requires_no_session_user
      if current_user
        redirect_to :controller => :caseadilla, :action => :index
      end
    end

  end
end