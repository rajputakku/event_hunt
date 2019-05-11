class AddDescToEvent < ActiveRecord::Migration
  def change
  	add_column :events, :event_description, :string
  end
end
