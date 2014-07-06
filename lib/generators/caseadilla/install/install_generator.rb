module Caseadilla
  class InstallGenerator < Rails::Generators::Base
    
    include Rails::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)
    argument :flavor, type: :string, default: "auto"
    class_option :no_commit, type: :boolean, default: false, desc: 'Skip bundle install and rake tasks such as migrate and seed'
    class_option :skip_decl_auth, type: :boolean, default: false, desc: 'Skip installation of declarative_authorization'
    class_option :auth_model, type: :string, default: "User", desc: 'Name of Model to be created for auth'
    class_option :user_habtm_roles, type: :boolean, default: false, desc: 'Allow users to have multiple roles by setting up a HABTM association between roles'

    def self.next_migration_number dirname
      if ActiveRecord::Base.timestamped_migrations
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      else
        "%.3d" % (current_migration_number(dirname) + 1)
      end
    end

    def install_flavor
      @flavor = self.flavor
      if @flavor == "auto"
        puts "\nWelcome to Caseadilla! Please enter a flavor to install:"
        puts "\n[steak] This is recommended for a fresh Rails app.  Caseadilla will set up Devise and Declarative Authorization for you, along with an admin user and various authorization roles."
        puts "\n[chicken] Select this if you have auth in place already or plan to use something other than Devise or Declarative Authorization.  Caseadilla will use methods such as `current_user.is_admin?` to help with auth integration.  See the readme for more details."
        puts "\n[veggie] This flavor will install Caseadilla as minimally as possible, without any auth support.  You will be responsible for implementing authorization and authentication into Caseadilla.\n\n"
        flavor_choice = STDIN.gets.chomp
        @flavor = flavor_choice
      end

      case @flavor
      when "steak"
        @target = "steak"

        gem 'simple_form'
        gem 'devise'
        gem 'declarative_authorization', git: 'git://github.com/zeiv/declarative_authorization', branch: '1.0.0' unless options[:skip_decl_auth]
        Bundler.with_clean_env do
          run 'bundle install' unless options[:no_commit]
        end

        generate 'devise:install'
        generate 'devise', "#{options[:auth_model].capitalize}"
        generate 'devise:views'
        rake 'db:migrate' unless options[:no_commit]

        generate "authorization:install","#{options[:auth_model].capitalize} --commit --user-belongs-to-role" unless options[:skip_decl_auth] or options[:no_commit] or options[:user_habtm_roles]
        generate "authorization:install","#{options[:auth_model].capitalize} --commit" if options[:user_habtm_roles] and not options[:skip_decl_auth]
        generate "authorization:install","#{options[:auth_model].capitalize}" if options[:no_commit] and not options[:skip_decl_auth]

        migration_template 'steak/db/migrate/add_name_to_users.rb', "db/migrate/add_name_to_users.rb"
        rake 'db:migrate' unless options[:no_commit]

        inject_into_file "app/models/#{options[:auth_model].downcase}.rb", "  before_create :add_user_role", after: "belongs_to :role\n"
        inject_into_file "app/models/#{options[:auth_model].downcase}.rb", after: /def role_symbols.*?end\n/m do <<-'RUBY'

  def name
    "#{first_name} #{last_name}"
  end

  private

  def add_user_role
    self.role = Role.find_by_title 'user'
  end


        RUBY
        end

        inject_into_file 'app/helpers/application_helper.rb', after: "module ApplicationHelper\n" do <<-'RUBY'
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
        RUBY
        end

        inject_into_file 'app/controllers/application_controller.rb', after: "ActionController::Base\n" do <<-'RUBY'
  before_action :configure_permitted_parameters, if: :devise_controller?

        RUBY
        end

        inject_into_file 'app/controllers/application_controller.rb', before: "\nend" do <<-'RUBY'


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit({ role_ids: [] }, :email, :password, :password_confirmation, :current_password, :first_name, :last_name, :time_zone) }
  end
        RUBY
        end

        inject_into_file 'config/authorization_rules.rb', after: "authorization do\n" do <<-'RUBY'

  role :admin do
    has_permission_on :caseadilla_users, to: :manage
    has_permission_on :caseadilla_roles, to: :manage
  end

        RUBY
        end
      when "chicken"
        @target = "chicken"
      when "veggie"
        @target = "veggie"
      else
        puts "That flavor is not recognized.  Please enter steak, chicken, or veggie.  E.g., for a full install use `rails g caseadilla:install steak`"
      end
    end

    def flavor_files
      copy_file "#{@target}/config/initializers/caseadilla.rb", "config/initializers/caseadilla.rb"
    end

    def common_files
      puts "*** WARNING - Generating configuration files. Make sure you have backed up any files before overwriting them. ***"

      #config helper
      copy_file "app/helpers/caseadilla/config_helper.rb", "app/helpers/caseadilla/config_helper.rb"

      #initial view partials
      copy_file "app/views/caseadilla/layouts/_tab_navigation.html.erb", "app/views/caseadilla/layouts/_tab_navigation.html.erb"
      copy_file "app/views/caseadilla/layouts/_top_navigation.html.erb", "app/views/caseadilla/layouts/_top_navigation.html.erb"

      #blank stylesheets and JavaScript files
      copy_file "app/assets/stylesheets/caseadilla/custom.css.scss", "app/assets/stylesheets/caseadilla/custom.css.scss"
      copy_file "app/assets/javascripts/caseadilla/custom.js", "app/assets/javascripts/caseadilla/custom.js"
    end

    def copy_robots
      puts " ** Overwrite if you haven't yet modified your robots.txt, otherwise add disallow rules for /caseadilla and /admin manually **"
      copy_file "public/robots.txt", "public/robots.txt"
    end

    # protected
    # attr_reader :flavor

    # def assign_flavor!(f)
    #   @flavor = f
    # end
  end
end