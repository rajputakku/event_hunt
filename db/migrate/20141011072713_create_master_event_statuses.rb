class CreateMasterEventStatuses < ActiveRecord::Migration
  def change
    create_table :master_event_statuses do |t|
      t.string :status
      t.timestamps
    end
  end
end
