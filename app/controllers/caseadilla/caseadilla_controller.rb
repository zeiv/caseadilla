module Caseadilla
  class CaseadillaController < ApplicationController
    # filter_access_to [:index, :blank]

    require 'caseadilla/caseadilla_helper'
    include Caseadilla::CaseadillaHelper

    require 'caseadilla/config_helper'
    include Caseadilla::ConfigHelper

    layout 'caseadilla_main'

    # before_filter :set_time_zone
    before_action :require_sign_in
    before_action :redirect_if_not_authorized
    # skip_before_action :redirect_if_not_authorized, only: :index

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

    # def set_time_zone
    #   Time.zone = current_user.time_zone if current_user
    # end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    def redirect_if_not_authorized
      auth = Authorization::Engine.new
      unless auth.permit? :access, user: current_user, context: :caseadilla
        redirect_to root_path, alert: "You are not authorized to access that page."
      end
    end

    def sort_order(default)
      "#{(params[:c] || default.to_s).gsub(/[\s;'\"]/,'')} #{'ASC' if params[:d] == 'up'} #{'DESC' if params[:d] == 'down'}"
    end

    def require_sign_in
      redirect_to caseadilla_sign_in_path unless user_signed_in?
    end

  end
end
