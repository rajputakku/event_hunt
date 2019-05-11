class User < ActiveRecord::Base

  extend FriendlyId
  friendly_id :twitter_handle, use: [:slugged, :finders]

  before_create :set_role_and_status
  # Include default devise modules. Others available are:
  # :confirmable, :lockable and :timeoutable  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:twitter]

  belongs_to :master_role
  belongs_to :master_user_status
  has_many   :created_events, class_name: :Event, foreign_key: :user_id
  has_many   :event_organizers
  has_many   :organized_events, through: :event_organizers, source: :event 
  has_many   :event_upvotes , dependent: :destroy
  has_many   :upvoted_events, through: :event_upvotes, source: :event
  has_many   :event_comments, dependent: :destroy
  has_many   :event_attendees, dependent: :destroy
  has_many   :events_registered_for, through: :event_attendees, source: :event
  has_many   :user_notifications, dependent: :destroy
  has_many   :identities, dependent: :destroy
  has_many   :report_events, dependent: :destroy

  has_attached_file :user_image, :styles => { :large => "150x150#", :small => "50x50#", :medium => "64x64#" ,:thumb =>"40x40#" }
  validates_attachment_content_type :user_image, content_type: ["image/jpeg", "image/jpg", "image/png"]
  
  def image(size)
    if user_image.present?
      return user_image.url(size)
    else
      return "/assets/default_user_#{size}.png"
    end
  end

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update
  
  def set_role_and_status
    self.master_role_id        = MasterRole.find_by(role: 'user').id 
    self.master_user_status_id = MasterUserStatus.find_by(status: 'active').id
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email


      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          name: auth.extra.raw_info.name,
          user_image: auth.info.image.sub("_normal", ""),
          #username: auth.info.nickname || auth.uid,
          twitter_handle:auth.info.nickname,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation! if user.respond_to?(:skip_confirmation)
        user.save!
      end
    else
      
      user.update(name: auth.extra.raw_info.name,
                  user_image: auth.info.image.sub("_normal", ""),
                  twitter_handle:auth.info.nickname)
     end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << ["Name", "Job Title", "Company", "Email", "Twitter Handle"]
      all.each do |user|
        csv << user.attributes.values_at(*["name", "job_title", "company", "email", "twitter_handle"])
      end
    end
  end

end

