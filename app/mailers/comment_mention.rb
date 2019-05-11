class CommentMention < ActionMailer::Base
  default from: 'amitejkalra@poplify.com'
  
  def mentioned_in_comment(event, user, mentioned_by)
    @event = event
    @user  = user
    @mentioned_by = mentioned_by
    mail(to: @user.email , subject: 'You’ve been mentioned on HUK!')
  end
end
