class RenameEventTimeToEventStartTime < ActiveRecord::Migration
  def change
  	rename_column :events, :event_time, :event_start_time
  end
end
