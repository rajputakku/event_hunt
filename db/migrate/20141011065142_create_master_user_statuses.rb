class CreateMasterUserStatuses < ActiveRecord::Migration
  def change
    create_table :master_user_statuses do |t|
      t.string :status 
      t.timestamps
    end
  end
end
