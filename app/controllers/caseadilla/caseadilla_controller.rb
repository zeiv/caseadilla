module Caseadilla
  class CaseadillaController < ApplicationController

    require 'caseadilla/caseadilla_helper'
    include Caseadilla::CaseadillaHelper

  	require 'caseadilla/config_helper'
  	include Caseadilla::ConfigHelper

    layout 'caseadilla_main'

    before_filter :set_time_zone
    before_action :authenticate_user!
    
    ActionView::Base.field_error_proc = proc { |input, instance| "#{input}".html_safe }

    def index		
  		redirect_to caseadilla_config_dashboard_url
    end

  	def blank
  		@caseadilla_page_title = "Welcome"
  	end

  private

    def steak?
      return false unless Caseadilla::Engine.flavor = :steak
    end

    def chicken?
      return false unless Caseadilla::Engine.flavor = :chicken
    end

    def veggie?
      return false unless Caseadilla::Engine.flavor = :veggie
    end
    
    def set_time_zone
      Time.zone = current_user.time_zone if current_user
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    def sort_order(default)
      "#{(params[:c] || default.to_s).gsub(/[\s;'\"]/,'')} #{'ASC' if params[:d] == 'up'} #{'DESC' if params[:d] == 'down'}"
    end

  end
end