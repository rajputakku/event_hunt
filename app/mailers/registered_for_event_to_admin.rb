class RegisteredForEventToAdmin < ActionMailer::Base
  default from: 'amitejkalra@poplify.com'
  
  def registered_for_event_to_admin(event, user, organizer)
    @event     = event
    @user      = user
    @organizer = organizer
    mail(to: @organizer.email , subject: 'New attendee registration for ' + @event.event_name + '!')
  end
end
