class CreateEventAttendees < ActiveRecord::Migration
  def change
    create_table :event_attendees do |t|
      t.references :event 
      t.references :user
      t.timestamps
    end
  end
end
