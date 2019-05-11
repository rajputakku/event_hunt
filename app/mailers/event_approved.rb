class EventApproved < ActionMailer::Base
  default from: 'amitejkalra@poplify.com'
  
  def event_approved(event, organizer)
    @event     = event
    @organizer = organizer
    mail(to: @organizer.email , subject: 'Your event ' + @event.event_name + ' is now live!')
  end
end
