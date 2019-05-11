class RegisteredForEvent < ActionMailer::Base
  default from: 'amitejkalra@poplify.com'
  
  def registered_for_event(event, user)
    @event = event
    @user  = user
    mail(to: @user.email , subject: 'You have been registered for ' + @event.event_name + '!')
  end
end
