class CreateUsers < ActiveRecord::Migration
  
  def self.up
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :time_zone
    end
  end
  
  def self.down
    drop_table :users
  end
  
end