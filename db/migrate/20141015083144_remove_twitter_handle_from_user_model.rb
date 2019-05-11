class RemoveTwitterHandleFromUserModel < ActiveRecord::Migration
  def change
  	remove_column :users, :twitter_handle
  end
end
