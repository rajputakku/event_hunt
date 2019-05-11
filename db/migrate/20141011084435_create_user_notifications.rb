class CreateUserNotifications < ActiveRecord::Migration
  def change
    create_table :user_notifications do |t|
      t.references :user
      t.references :event 
      t.text       :notification_text
      t.timestamps
    end
  end
end
