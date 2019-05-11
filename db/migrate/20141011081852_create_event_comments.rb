class CreateEventComments < ActiveRecord::Migration
  def change
    create_table :event_comments do |t|
      t.references :event 
      t.references :user
      t.text       :comment_text
      t.timestamps
    end
  end
end
