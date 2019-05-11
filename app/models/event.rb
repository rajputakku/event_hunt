class Event < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]
  def slug_candidates
    if Event.first    
      [
        :event_name,
        [:event_name, self.id.nil? ? Event.last.id+1 : :id]
      ]
    else
      :event_name
    end
  end

  def should_generate_new_friendly_id?
    slug.blank? || event_name_changed?
  end

  belongs_to :master_event_category
  belongs_to :master_event_status
  belongs_to :event_creator, class_name: :User, foreign_key: :user_id
  has_many   :event_related_links
  has_many   :event_organizers
  has_many   :organizers, through: :event_organizers, source: :user
  has_many   :event_upvotes
  has_many   :voters, through: :event_upvotes, source: :user
  has_many   :event_comments
  has_many   :event_attendees
  has_many   :attendees, through: :event_attendees, source: :user
  has_many   :user_notifications
  has_many   :report_events

  has_attached_file :event_image , :styles => { :medium => "414x301#", :small => "360x220#", :large => "500x500#",:thumb =>"64x64#" }
  validates_attachment_content_type :event_image, content_type: ["image/jpeg", "image/jpg", "image/png"]
  validates_length_of   :event_name, minimum: 1, maximum: 80
  validates_length_of   :event_description, minimum: 1, maximum: 100
  validates_presence_of :event_name, :master_event_category
  validate              :event_url_validation
  validate              :payment_url_validation

  def image(size)
    if event_image.present?
      return event_image.url(size)
    else
      return "/assets/default_event_#{size}.jpg"
    end
  end

  def organizer=(str)
    if !self.event_organizers.present?
      self.event_organizers = [EventOrganizer.create(event_id: self.id, organizer_name: str)]
    else
      self.event_organizers.first.update(organizer_name: str)
    end
  end

  def organizer
    if self.event_organizers.present?
      self.event_organizers.first.organizer_name
    end
  end

  def related_links_list=(links_string)
    if self.event_related_links.count != 0
      EventRelatedLink.delete_all(event_id: self.id)
    end
    links = links_string.split(",").collect{|s| s.strip}.uniq
    self.event_related_links = links.collect {|link| EventRelatedLink.create(event_id: self.id, link_url: link) }
  end

  def related_links_list
    self.event_related_links.collect do |link|
      link.link_url
    end.join(", ")
  end
end

def event_url_validation
  if event_url.blank? 
    errors.add(:event_url, "cannot be blank")
  else
    validates_format_of :event_url, :with => URI::regexp(%w(http https))
  end
end

def payment_url_validation
  if paid == true && payment_url.blank?
    errors.add(:payment_url, "cannot be blank")
  elsif paid == true && !payment_url.blank?
    validates_format_of :payment_url, :with => URI::regexp(%w(http https))
  end
end




