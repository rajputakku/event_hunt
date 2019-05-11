class CreateEventUpvotes < ActiveRecord::Migration
  def change
    create_table :event_upvotes do |t|
      t.references :event 
      t.references :user
      t.timestamps
    end
  end
end
