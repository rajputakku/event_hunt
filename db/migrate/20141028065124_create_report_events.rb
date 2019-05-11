class CreateReportEvents < ActiveRecord::Migration
  def change
    create_table :report_events do |t|
    	t.references :user, index: true
    	t.references :event, index:true
    	t.text       :report_reason
      t.timestamps
    end
  end
end
