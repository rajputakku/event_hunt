class AddNotificationColumnToUser < ActiveRecord::Migration
  def change
  	add_column :users, :notification, :boolean, default: false
  end
end
