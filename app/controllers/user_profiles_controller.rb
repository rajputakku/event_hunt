class UserProfilesController < ApplicationController

  skip_before_filter :set_user_email, only: [:edit, :update]
	before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :edit_check, only: [:edit]


	def show
    Event.where("event_end_time < (?)", Time.current).update_all(master_event_status_id: MasterEventStatus.find_by_status('completed').id)
    arr                    = MasterEventStatus.where("status in (?)", ['active','completed']).map(&:id)
    @created_events        = @user.created_events.where("master_event_status_id in (?)", arr).order("created_at desc")
    @upvoted_events        = @user.upvoted_events.where("master_event_status_id in (?)", arr).order("event_upvotes.created_at desc")
	  @organized_events      = @user.organized_events.where("master_event_status_id in (?)", arr).order("event_organizers.updated_at desc")
    @events_registered_for = @user.events_registered_for.where("master_event_status_id in (?)", arr).order("event_attendees.created_at desc")
  end

	def edit
		
	end

	def update
    @old_email = @user.email
		@user.attributes=user_params
  
    respond_to do |format|
      if @user.save
        if @old_email.slice(0,9) == "change@me"
          UserSignup.user_signup(current_user).deliver
          @admins = User.where("master_role_id IN (?)", MasterRole.where("role IN (?)",['admin', 'superadmin']).map(&:id))
          @admins.each do |admin|
            UserSignupToAdmin.user_signup(admin, current_user).deliver
          end
        end
        format.html { redirect_to user_profile_path(@user) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
	end

  def destroy
    @user = User.find(params[:id])
    @user.created_events.update_all(user_id: nil)
    @user.organized_events.update_all(user_id: nil)
    @user.destroy
    redirect_to root_path
  end

	private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email,
      														 :job_title,
                                   :company
                                   )
    end

    def edit_check
      if params[:id] != current_user.slug
          redirect_to root_path
        end
    end
end
