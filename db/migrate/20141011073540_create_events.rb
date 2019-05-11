class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string     :event_name
      t.string     :event_url
      t.references :user
      t.references :master_event_category
      t.boolean    :paid
      t.string     :payment_url
      t.references :master_event_status
      t.timestamp  :time_of_approval
      t.string     :event_venue
      t.timestamp  :event_time
      t.attachment :event_image
      t.timestamps
    end
  end
end
