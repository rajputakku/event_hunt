class AddEventStartTimeToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :event_end_time, :timestamp
  end
end
