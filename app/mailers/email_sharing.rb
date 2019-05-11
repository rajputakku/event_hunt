class EmailSharing < ActionMailer::Base
  default from: 'amitejkalra@poplify.com'

  def share_event(event, to_send_to, user)
    @event = event
    @user  = user
    mail(to:to_send_to , subject: 'New #Startup Event shared with you, via HUKapp!')
  end
end