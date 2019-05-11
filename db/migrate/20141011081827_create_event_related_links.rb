class CreateEventRelatedLinks < ActiveRecord::Migration
  def change
    create_table :event_related_links do |t|
      t.references :event
      t.string     :link_url
      t.timestamps
    end
  end
end
