require "caseadilla"
require "rails"

module Caseadilla
  class Engine < Rails::Engine
    @flavor = nil

    class << self
      attr_accessor :flavor
    end
    
    config.after_initialize do
      Rails.application.config.assets.paths << root.join("app", "assets", "fonts")
    end

    initializer "caseadilla.assets.precompile" do |app|
      app.config.assets.precompile += %w(caseadilla/*.svg caseadilla/*.eot caseadilla/*.woff caseadilla/*.ttf caseadilla/login.css caseadilla/caseadilla.css caseadilla/caseadilla.js caseadilla/html5shiv.js caseadilla/custom.css caseadilla/custom.js caseadilla/*.png)
    end

    rake_tasks do
      load "railties/tasks.rake"
    end
    
  end
  
  class RouteConstraint

     def matches?(request)
       return false if request.fullpath.include?("/caseadilla")
       return false if request.fullpath.include?("/admin")
       true
     end

   end
end