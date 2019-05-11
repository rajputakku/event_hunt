class CreateLoadingMessages < ActiveRecord::Migration
  def change
    create_table :loading_messages do |t|
    	t.text       :message
      t.timestamps
    end
  end
end
