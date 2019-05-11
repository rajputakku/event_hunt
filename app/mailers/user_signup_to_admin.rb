class UserSignupToAdmin < ActionMailer::Base
  default from: 'amitejkalra@poplify.com'
  
  def user_signup(admin, user)
    @admin  = admin
    @user   = user
    mail(to: @admin.email , subject: 'New user registration on HUK!')
  end
end
