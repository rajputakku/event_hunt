class CreateMasterRoles < ActiveRecord::Migration
  def change
    create_table :master_roles do |t|
      t.string :role
      t.timestamps
    end
  end
end
