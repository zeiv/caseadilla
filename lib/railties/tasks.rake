require 'securerandom'

namespace :caseadilla do

  namespace :users do

    desc "Create default admin user"
    task create_admin: :environment do

      unless ENV.include?("email") and ENV.include?("first_name") and ENV.include?("last_name") and ENV.include?("password")
        raise "Usage: specify email address, first and last name, and a password. \nE.g. rake [task] email=mail@example.com first_name=John last_name=Doe password=password123"
      end

      admin = User.new({email: ENV['email'], first_name: ENV['first_name'], last_name: ENV['last_name'], password: ENV['password'] })

      unless admin.save
        puts "[Caseadilla] Failed: check that the account doesn't already exist."
      else
        puts "[Caseadilla] Created new admin user with email '#{ENV['email']}' and password '#{ENV['password']}'"
      end
      admin.role = Role.find_by_title 'admin'
      admin.save!
    end

    desc "Remove all users"
    task remove_all: :environment do
      users = User.all
      num_users = users.size
      users.destroy_all
      puts "[Caseadilla] Removed #{num_users} user(s)"
    end

  end

end
