class CreateEventOrganizers < ActiveRecord::Migration
  def change
    create_table :event_organizers do |t|
      t.references :event 
      t.references :user
      t.string     :organizer_name
      t.timestamps
    end
  end
end
