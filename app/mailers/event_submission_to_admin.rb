class EventSubmissionToAdmin < ActionMailer::Base
  default from: 'amitejkalra@poplify.com'
  
  def event_submission(admin, event)
    @admin  = admin
    @event  = event
    mail(to: @admin.email , subject: 'New #Startup Event: ' + @event.event_name + ' has been created!')
  end
end
