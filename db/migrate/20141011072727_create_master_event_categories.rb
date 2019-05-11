class CreateMasterEventCategories < ActiveRecord::Migration
  def change
    create_table :master_event_categories do |t|
      t.string :category
      t.timestamps
    end
  end
end
