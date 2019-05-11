class EventRelatedLink < ActiveRecord::Base
  
	belongs_to :event 
  # validates_format_of :link_url, :with => URI::regexp(%w(http https))
  
end
