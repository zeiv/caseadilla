module Caseadilla
  class ScaffoldGenerator < Rails::Generators::NamedBase
  
    include Caseadilla::CaseadillaHelper
    include Rails::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)
  
    argument :attributes, :type => :array, :required => true, :desc => "attribute list required"
    
    class_options :create_model => false, :read_only => false, :no_index => false
  
    def self.next_migration_number dirname
      if ActiveRecord::Base.timestamped_migrations
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      else
        "%.3d" % (current_migration_number(dirname) + 1)
      end
    end
  
    def generate_files
      @plural_route = (plural_name != singular_name) ? plural_name : "#{plural_name}_index"
      @read_only = options[:read_only]
      @no_index = options[:no_index]

      template 'controller.rb', "app/controllers/caseadilla/#{plural_name}_controller.rb"
      template 'views/index.html.erb', "app/views/caseadilla/#{plural_name}/index.html.erb" unless @no_index
      template 'views/show.html.erb', "app/views/caseadilla/#{plural_name}/show.html.erb"
      template 'views/new.html.erb', "app/views/caseadilla/#{plural_name}/new.html.erb" unless @read_only
      template 'views/_form.html.erb', "app/views/caseadilla/#{plural_name}/_form.html.erb"
      template 'views/_table.html.erb', "app/views/caseadilla/#{plural_name}/_table.html.erb"
      
      add_namespace_to_routes
      add_to_routes
      add_to_navigation unless @no_index
      
      if options[:create_model]
        template 'model.rb', "app/models/#{singular_name}.rb"
        migration_template 'migration.rb', "db/migrate/create_#{plural_name}.rb"
      end
    end
  
  protected
  
    #replacements for standard Rails generator route. This one only adds once
    def add_namespace_to_routes
      puts "   caseadilla     adding namespace to routes.rb"
      file_to_update = Rails.root + 'config/routes.rb'
      line_to_add = "namespace :caseadilla do"
      insert_sentinel = 'Application.routes.draw do'
      if File.read(file_to_update).scan(/(#{Regexp.escape("#{line_to_add}")})/mi).blank?
        gsub_add_once plural_name, file_to_update, "\n\t#Caseadilla routes\n\t" + line_to_add + "\n\tend\n", insert_sentinel
      end
    end
    
    def add_to_routes
      puts "   caseadilla     adding #{plural_name} resources to routes.rb"
      file_to_update = Rails.root + 'config/routes.rb'

      if @no_index && @read_only
        line_to_add = "resources :#{plural_name}, :only => [:show]"
      elsif @no_index
        line_to_add = "resources :#{plural_name}, :except => [:index]"
      elsif @read_only
        line_to_add = "resources :#{plural_name}, :only => [:index, :show]"
      else
        line_to_add = "resources :#{plural_name}"
      end

      insert_sentinel = 'namespace :caseadilla do'
      gsub_add_once plural_name, file_to_update, "\t\t" + line_to_add, insert_sentinel
    end

    def add_to_navigation
      puts "   caseadilla     adding #{plural_name} to left navigation bar"
      file_to_update = Rails.root + 'app/views/caseadilla/layouts/_tab_navigation.html.erb'
      line_to_add = "<li id=\"tab-#{@plural_route}\"><%= link_to \"#{plural_name.humanize.capitalize}\", caseadilla_#{@plural_route}_path %></li>"
      insert_sentinel = '<!-- SCAFFOLD_INSERT -->'
      gsub_add_once plural_name, file_to_update, line_to_add, insert_sentinel
    end
  
    def gsub_add_once m, file, line, sentinel
      unless options[:pretend]
        gsub_file file, /(#{Regexp.escape("\n#{line}")})/mi do |match|
          ''
        end
        gsub_file file, /(#{Regexp.escape(sentinel)})/mi do |match|
          "#{match}\n#{line}"
        end
      end
    end
    
    def gsub_file(path, regexp, *args, &block)
      content = File.read(path).gsub(regexp, *args, &block)
      File.open(path, 'wb') { |file| file.write(content) }
    end
  
    def field_type(type)
      case type.to_s.to_sym
        when :integer, :float, :decimal   then :text_field
        when :date                        then :date_select
        when :time, :timestamp            then :time_select
        when :datetime                    then :datetime_select
        when :string                      then :text_field
        when :text                        then :text_area
        when :boolean                     then :check_box
      else
        :text_field
      end      
    end
  end
end