class AdminProfilesController < ApplicationController

  before_filter :limited_access

  def limited_access
    if user_signed_in?
      if current_user.master_role_id == MasterRole.find_by(role: "user").id
        redirect_to root_path 
      end
    else
      redirect_to user_omniauth_authorize_path(:twitter)
    end
  end

  def index
    Event.where("event_end_time < (?)", Time.current).update_all(master_event_status_id: MasterEventStatus.find_by_status('completed').id)
    @events = Event.all.select{|e| e.master_event_status_id!= MasterEventStatus.find_by(status: 'pending').id}.sort_by{|m| m.master_event_status_id}
    @pending_events=Event.where("master_event_status_id = (?)", MasterEventStatus.find_by(:status=>"pending").id )
    @comments=EventComment.all
    @upvotes=EventUpvote.all
    @registered=EventAttendee.all
    @reports=ReportEvent.all.order("updated_at DESC")
    @users = User.all.select {|u| u.master_role_id != MasterRole.find_by(role: 'superadmin').id}

    respond_to do |format|
      format.html
      format.csv { send_data User.all.to_csv, :filename=>"users.csv" }
    end
  end

  def approve_event
    @events = Event.all.select{|e| e.master_event_status_id!= MasterEventStatus.find_by(status: 'pending').id}.sort_by{|m| m.master_event_status_id}
    @event = Event.find(params[:id])

    if @event.master_event_status_id != MasterEventStatus.find_by(status: "active").id
      @event.update(master_event_status_id: MasterEventStatus.find_by(status: "active").id, time_of_approval: Time.current) 

      if @event.organizers.count != 0
        @organizer = @event.organizers.first
        EventApproved.event_approved(@event, @organizer).deliver
      end
      
      @channel1 = "/notification/private/#{@event.event_creator.id}"
      @notification=UserNotification.new
      @notification.user_id=@event.event_creator.id
      @notification.event_id=@event.id
      @notification.notification_text="Your event #{@event.event_name} has been approved."
      @notification.save
      @unread_notifications_creator=UserNotification.find_all_by_user_id_and_read(@event.event_creator.id,false)

      if @event.event_creator.notification==false
        @user=User.find(@event.event_creator.id)
        @user.notification=true
        @user.save
      end

      if @event.organizers.first
        @channel2 = "/organizer_notification/private/#{@event.organizers.first.id}"
        @notification=UserNotification.new
        @notification.user_id=@event.organizers.first.id
        @notification.event_id=@event.id
        @notification.notification_text="Your event #{@event.event_name} has been approved."
        @notification.save
        @unread_notifications_organizer=UserNotification.find_all_by_user_id_and_read(@event.organizers.first.id,false)
        if @event.organizers.first.notification==false
          @user=User.find(@event.organizers.first.id)
          @user.notification=true
          @user.save
        end
      end
      
      @pending_events=Event.find(:all,:conditions=>{ :master_event_status_id => MasterEventStatus.find_by(:status=>"pending").id })
      flash[:notice] = 'Event has been approved.'
      #redirect_to admin_profiles_path
      respond_to do |format|
        format.js {render 'all_event_update'}
      end
    end
  end

  def dismiss_event
    @events = Event.all.select{|e| e.master_event_status_id!= MasterEventStatus.find_by(status: 'pending').id}.sort_by{|m| m.master_event_status_id}
    
    @event = Event.find(params[:id])
    @event.update(master_event_status_id: MasterEventStatus.find_by(status: "dismissed").id)
    @channel1 = "/notification/private/#{@event.event_creator.id}"
    @notification=UserNotification.new
    @notification.user_id=@event.event_creator.id
    @notification.event_id=@event.id
    @notification.notification_text="Your event #{@event.event_name} has not been approved by the Admin."
    @notification.save
    @unread_notifications_creator=UserNotification.find_all_by_user_id_and_read(@event.event_creator.id,false)
    if @event.event_creator.notification==false
        @user=User.find(@event.event_creator.id)
        @user.notification=true
        @user.save
      end
    if @event.organizers.first
        @channel2 = "/organizer_notification/private/#{@event.organizers.first.id}"
      @notification=UserNotification.new
      @notification.user_id=@event.organizers.first.id
      @notification.event_id=@event.id
      @notification.notification_text="Your event #{@event.event_name} has not been approved by the Admin."
      @notification.save
      @unread_notifications_organizer=UserNotification.find_all_by_user_id_and_read(@event.organizers.first.id,false)
      if @event.organizers.first.notification==false
        @user=User.find(@event.oraganizers.first.id)
        @user.notification=true
        @user.save
      end
      
    end
    
    @pending_events=Event.find(:all,:conditions=>{ :master_event_status_id => MasterEventStatus.find_by(:status=>"pending").id })
    respond_to do |format|
      format.js {render 'all_event_update'}
    end
  end

  def delete_event
    @events = Event.all.select{|e| e.master_event_status_id!= MasterEventStatus.find_by(status: 'pending').id}.sort_by{|m| m.master_event_status_id}
    @event = Event.find(params[:id])
    @event.update(master_event_status_id: MasterEventStatus.find_by(status: "deleted").id)
      @channel1 = "/notification/private/#{@event.event_creator.id}"
    @notification=UserNotification.new
    @notification.user_id=@event.event_creator.id
    @notification.event_id=@event.id
    @notification.notification_text="Your event #{@event.event_name} has been deleted by the Admin."
    @notification.save
    @unread_notifications_creator=UserNotification.find_all_by_user_id_and_read(@event.event_creator.id,false)
    if @event.event_creator.notification==false
        @user=User.find(@event.event_creator.id)
        @user.notification=true
        @user.save
      end
    if @event.organizers.first
       @channel2 = "/organizer_notification/private/#{@event.organizers.first.id}"
      @notification=UserNotification.new
      @notification.user_id=@event.organizers.first.id
      @notification.event_id=@event.id
      @notification.notification_text="Your event #{@event.event_name} has been deleted by the Admin."
      @notification.save
      @unread_notifications_organizer=UserNotification.find_all_by_user_id_and_read(@event.organizers.first.id,false)
      if @event.organizers.first.notification==false
        @user=User.find(@event.oraganizers.first.id)
        @user.notification=true
        @user.save
      end

    end
    
    @pending_events=Event.find(:all,:conditions=>{ :master_event_status_id => MasterEventStatus.find_by(:status=>"pending").id })
    respond_to do |format|
      format.js {render 'all_event_update'}
    end
    
  end

  def organizer_popup
    @twitter_handles = User.select(:id, :twitter_handle)
    @event = Event.find(params[:id])
    respond_to do |format|
      format.js 
    end
  end

  def link_organizer
    @events = Event.all.select{|e| e.master_event_status_id!= MasterEventStatus.find_by(status: 'pending').id}.sort_by{|m| m.master_event_status_id}
    @twitter_handles = User.select(:id, :twitter_handle)
    @event = Event.find(params[:id])
    @event.event_organizers.first.update(user_id: params[:event][:organizer])
    
    if @event.organizers.first
      @notification=UserNotification.new
       @channel2 = "/organizer_notification/private/#{@event.organizers.first.id}"
      @notification.user_id=@event.organizers.first.id
      @notification.event_id=@event.id
      @notification.notification_text="Congrats! You are now the organiser of the event #{@event.event_name}."
      @notification.save
      @unread_notifications_organizer=UserNotification.find_all_by_user_id_and_read(@event.organizers.first.id,false)
      if @event.organizers.first.notification==false
        @user=User.find(@event.organizers.first.id)
        @user.notification=true
        @user.save
      end
    end
    
    @pending_events=Event.find(:all,:conditions=>{ :master_event_status_id => MasterEventStatus.find_by(:status=>"pending").id })
    respond_to do |format|
      format.js {render 'all_event_update'}
    end
    
  end

  def block_user
    @user = User.find(params[:id])
    @user.update(master_user_status_id: MasterUserStatus.find_by(status: "blocked").id)
    redirect_to admin_profiles_path
  end

  def unblock_user
    @user = User.find(params[:id])
    @user.update(master_user_status_id: MasterUserStatus.find_by(status: "active").id)
    redirect_to admin_profiles_path
  end

  def add_admin
    @user = User.find(params[:id])
    @user.update(master_role_id: MasterRole.find_by(role: "admin").id)
    @notification=UserNotification.new
       @channel4 = "/admin_add_notification/private/#{@user.id}"
      @notification.user_id=@user.id
      
      @notification.notification_text="Congrats! You are now the admin of HUKapp."
      @notification.save
      @unread_notifications=UserNotification.find_all_by_user_id_and_read(@user.id,false)
      respond_to do |format|
      format.js
    end
  end

  def remove_admin
    @user = User.find(params[:id])
    @user.update(master_role_id: MasterRole.find_by(role: "user").id)
    @notification=UserNotification.new
       @channel5 = "/admin_remove_notification/private/#{@user.id}"
      @notification.user_id=@user.id
      
      @notification.notification_text="Sorry! You are no longer the admin of HUKapp."
      @notification.save
      @unread_notifications=UserNotification.find_all_by_user_id_and_read(@user.id,false)
      respond_to do |format|
      format.js
    end
  end

  def attendees_modal
    @event     = Event.find(params[:id])
    @attendees = @event.attendees.where("master_user_status_id = (?)", MasterUserStatus.find_by(status: 'active')).order("created_at DESC")

    respond_to do |format|
      format.js{render 'attendees_modal'}
    end
  end 

  def send_attendees_list
    @event = Event.find(params[:id])
    @attendees = @event.attendees.where("master_user_status_id = (?)", MasterUserStatus.find_by(status: 'active')).order("created_at DESC")

    AttendeesList.send_list(@event, @attendees, @event.organizers.first).deliver
    
    redirect_to admin_profiles_path
  end

end
