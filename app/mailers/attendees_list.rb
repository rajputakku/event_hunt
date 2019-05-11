class AttendeesList < ActionMailer::Base
  default from: 'amitejkalra@poplify.com'

  def send_list(event, attendees, organizer)
  	@event     = event
    @attendees = attendees
    @organizer = organizer
    mail(to:@organizer.email , subject: "Here's a list of attendees registered for " + @event.event_name + "!" )
  end
end
