require 'securerandom'

namespace :caseadilla do

  namespace :users do

    desc "Create default admin user"
    task create_admin: :environment do

      raise "Usage: specify email address, e.g. rake [task] email=mail@caseadillacms.com" unless ENV.include?("email")

      random_password = random_string = SecureRandom.hex
      admin = Caseadilla::AdminUser.new({ login: 'admin', name: 'Admin', email: ENV['email'], access_level: $CASEIN_USER_ACCESS_LEVEL_ADMIN, password: random_password, password_confirmation: random_password })

      unless admin.save
        puts "[Caseadilla] Failed: check that the 'admin' account doesn't already exist."
      else
        puts "[Caseadilla] Created new admin user with username 'admin' and password '#{random_password}'"
      end
    end

    desc "Remove all users"
    task remove_all: :environment do
      users = Caseadilla::AdminUser.all
      num_users = users.size
      users.destroy_all
      puts "[Caseadilla] Removed #{num_users} user(s)"
    end

  end

end