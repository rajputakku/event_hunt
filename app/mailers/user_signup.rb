class UserSignup < ActionMailer::Base
  default from: 'amitejkalra@poplify.com'
  
  def user_signup(user)
    @user  = user
    mail(to: @user.email , subject: 'Welcome to HUK!')
  end
end
