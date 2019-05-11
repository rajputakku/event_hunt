class EventsController < ApplicationController

  before_action :set_event, only: [:show, :edit, :update, :destroy]
  # before_filter :event_status_check, only: [:event_modal]
  before_filter :sign_in_check, only: [:new]
  before_filter :edit_check, only: [:edit]
  # before_action :modal_event, only: [:show]
  respond_to :js, :html


# check
  def index
    Event.where("event_end_time < (?)", Time.current).update_all(master_event_status_id: MasterEventStatus.find_by_status('completed').id)
    # @allevents = Event.where("master_event_status_id in (?)", MasterEventStatus.where("status in (?)",["active", "completed"]).map(&:id))
    @allevents = Event.all
    @sorted_events_ids = Event.where("master_event_status_id in (?)", MasterEventStatus.where('status in (?)',['active']).map(&:id)).collect{ |e| {id: e.id, p:(e.voters.count/(Time.current-e.time_of_approval))}}.sort_by{|e| e[:p]}.reverse.map{|x| x[:id]}
    @unsorted_events = Event.find(@sorted_events_ids)
    @events = @sorted_events_ids.collect {|id| @unsorted_events.detect {|x| x.id == id}}
    
    if(params[:id])
      @event = Event.find(params[:id])
      if !MasterEventStatus.where("status in (?)", ["active", "completed"]).map(&:id).include?(@event.master_event_status_id)
        if user_signed_in? && current_user.master_role.role == "user"
          redirect_to root_path
        elsif !user_signed_in?
          redirect_to root_path
        end
      end
                set_meta_tags :og => {
              :title    => @event.event_name,
              :type     => 'Event',
              :url      => event_url(@event),
              :description =>  "Startup Event: " << @event.event_description,
              :image    => @event.event_image(:medium),
  }
  # set_meta_tags :title => @event.event_name
# <title>Some Page Title</title>
# set_meta_tags :site => 'HUK app', :title => @event.event_name
# <title>Site Title | Page Title</title>
# set_meta_tags :site => 'Lets Get HUKed', :title => @event.event_name, :reverse => true
# <title>Page Title | Site Title</title>
# set_meta_tags :description => @event.event_description
# <meta name="description" content="All text about keywords, other keywords" />
    end 

    


  end

  def show
    
  end

  def new
    @event = Event.new
    @categories = MasterEventCategory.all
  end

  def edit
    @categories = MasterEventCategory.all
  end

  def create
    @event = Event.new(event_params)
   
    @time_of_start_event=(params[:event_start_time]+" "+params[:time_of_start_event])
    @event.event_start_time=@time_of_start_event.to_time.strftime("%d/%m/%Y %H:%M:%S")
    
    @time_of_end_event=(params[:event_end_time]+" "+params[:time_of_end_event])
    @event.event_end_time=@time_of_end_event.to_time.strftime("%d/%m/%Y %H:%M:%S")

    # @event.save!
    @event.master_event_status = MasterEventStatus.find_by(status: 'pending')

    respond_to do |format|
      if @event.save!
        @admins = User.where("master_role_id IN (?)", MasterRole.where("role IN (?)",['admin', 'superadmin']).map(&:id))
        @admins.each do |admin|
          EventSubmissionToAdmin.event_submission(admin, @event).deliver
        end
        @event_comment = EventComment.new
        format.html { redirect_to root_path, notice: 'Your event has been successfully created. It is pending for approval by the admin.' }
        format.json { render action: 'show', status: :created, location: @event }
      else
        # Rails.logger.info(@event.errors.full_messages)
        @categories = MasterEventCategory.all
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @event.attributes=event_params
    @time_of_start_event=(params[:event_start_time]+" "+params[:time_of_start_event])
    @event.event_start_time=@time_of_start_event.to_time.strftime("%d/%m/%Y %H:%M:%S")

    @time_of_end_event=(params[:event_end_time]+" "+params[:time_of_end_event])
    @event.event_end_time=@time_of_end_event.to_time.strftime("%d/%m/%Y %H:%M:%S")

    if params[:event][:paid] == '0'
      @event.payment_url = nil
    end
    @event.save

    respond_to do |format|
      if @event.save
        format.html { redirect_to root_url, notice: 'Event has been successfully updated.' }
        format.json { head :no_content }
      else
        @categories = MasterEventCategory.all
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  def like
    @event = Event.find(params[:id])
    
    if EventUpvote.where("event_id = (?) && user_id = (?)", @event.id, current_user.id).count==0
      EventUpvote.create(event_id: @event.id, user_id: current_user.id)
      if @event.user_id!=current_user.id
        @channel1 = "/notification/private/#{@event.event_creator.id}"
        @notification=UserNotification.new
        @notification.user_id=@event.event_creator.id
        @notification.event_id=@event.id
        @notification.notification_text="#{current_user.name} HUKed your event #{@event.event_name}."
        @notification.save
        @unread_notifications_creator=UserNotification.find_all_by_user_id_and_read(@event.event_creator.id,false)
      end
      
      if @event.organizers.first
        if @event.organizers.first.id!=current_user.id
          @channel2 = "/organizer_notification/private/#{@event.organizers.first.id}"
          @notification=UserNotification.new
          @notification.user_id=@event.organizers.first.id
          @notification.event_id=@event.id
          @notification.notification_text="#{current_user.name} HUKed your event #{@event.event_name}."
          @notification.save
          @unread_notifications_organizer=UserNotification.find_all_by_user_id_and_read(@event.organizers.first.id,false)
        end
        if @event.organizers.first.notification==false
          @user=User.find(@event.organizers.first.id)
          @user.notification=true
          @user.save
        end
        
      end
      respond_to do |format|
        format.js
      end
    
    end
  end

  def unlike
    @event = Event.find(params[:id])
    if EventUpvote.where("event_id = (?) && user_id = (?)", @event.id, current_user.id).count!=0
      EventUpvote.find_by(event_id: @event.id, user_id: current_user.id).destroy
      respond_to do |format|
        format.js
      end
    # else
    #   respond_to do |format|
    #     format.js {render 'like_unlike_blank'}
    #   end
    end
  end

  def register
    @event = Event.find(params[:id])
     
    if @event.event_start_time > Time.current
      if EventAttendee.where("event_id = (?) && user_id = (?)", @event.id, current_user.id).count==0
        EventAttendee.create(event_id: @event.id, user_id: current_user.id)
        RegisteredForEvent.registered_for_event(@event, current_user).deliver
        if @event.organizers.count != 0
          @organizer = @event.organizers.first
          RegisteredForEventToAdmin.registered_for_event_to_admin(@event, current_user, @organizer).deliver
        end

        if @event.user_id!=current_user.id
          @channel1 = "/notification/private/#{@event.event_creator.id}"
          @notification=UserNotification.new
          @notification.user_id=@event.event_creator.id
          @notification.event_id=@event.id
          @notification.notification_text="#{current_user.name} has registered for your event #{@event.event_name}."
          @notification.save
        end
        @unread_notifications_creator=UserNotification.find_all_by_user_id_and_read(@event.event_creator.id,false)
        if @event.event_creator.notification==false
          @user=User.find(@event.event_creator.id)
          @user.notification=true
          @user.save
        end
         
        if @event.organizers.first
          if @event.organizers.first.id!=current_user.id
            @notification=UserNotification.new
            @channel2 = "/organizer_notification/private/#{@event.organizers.first.id}"
            @notification.user_id=@event.organizers.first.id
            @notification.event_id=@event.id
            @notification.notification_text="#{current_user.name} has registered for your event #{@event.event_name}."
            @notification.save
            @unread_notifications_organizer=UserNotification.find_all_by_user_id_and_read(@event.organizers.first.id,false)
          end
        end
      end

      @unread_notifications=UserNotification.find_all_by_user_id_and_read(current_user.id,false)
     
      respond_to do |format|
        if @event.paid?
          redirect_to @event.payment_url
          return
        else  
          format.js
        end  
      end
    else   
      respond_to do |format|
        if @event.event_end_time < Time.current
          @event.update(master_event_status_id: MasterEventStatus.find_by_status('completed').id)
          flash[:notice]="Sorry, this event has already finished."
        else
          flash[:notice]="Sorry, this event has already started."
        end
        if @event.paid?
          redirect_to root_path
          return
        else
          format.js {render :js => "window.location = '#{root_url}'"}
        end
      end
    end
  end

  def send_email
    @event = Event.find(params[:event][:id])
    @to_send_to = params[:email_address]
    EmailSharing.share_event(@event, @to_send_to, current_user).deliver
    
    respond_to do |format|
      format.js{flash.now[:notice]= 'Email has been successfully sent.'}
    end
   # format.html { redirect_to @event, notice: 'Email successfully Sent' } 
  end

  def event_modal
    # if current_page?(controller: 'events', action: 'event_modal')
    Event.where("event_end_time < (?)", Time.current).update_all(master_event_status_id: MasterEventStatus.find_by_status('completed').id)
    @event           = Event.find(params[:id])
    @attendees       = @event.attendees.where("master_user_status_id = (?)", MasterUserStatus.find_by(status: 'active')).order("created_at DESC").paginate(:page => params[:attendees], :per_page => 24)
    @upvoters        = @event.voters.where("master_user_status_id = (?)", MasterUserStatus.find_by(status: 'active')).order("created_at DESC").paginate(:page => params[:upvoters], :per_page => 24)
    @event_comment   = EventComment.new
    if user_signed_in?
      @twitter_handles = User.where("master_user_status_id = (?) && id != (?)", MasterUserStatus.find_by(status: 'active').id, current_user.id).map(&:twitter_handle)
    end

    respond_to do |format|
      if params[:attendees]
        format.js{render 'attendees'} 
      elsif params[:upvoters]
        format.js{render 'upvoters'}
      else
        format.js{render 'event_modal'}
      end
    end
  end

  def popover_user
    @user=User.find(params[:userid])
    @uniqid = params[:uniqid]
    respond_to do |format|
      format.js{render 'popover_user'}
    end
  end

  def report_event
    @event = Event.find(params[:id])
    @event.report_events.create(user_id: current_user.id, report_reason: params[:report_text])
    @admin=User.find_by_master_role_id(3)
    @admin_notification=UserNotification.new
    @admin_notification.user_id=@admin.id
    @admin_notification.event_id=@event.id
    @admin_notification.notification_text= @event.event_name + "" + " has been reported"
    @admin_notification.save
    respond_to do |format|
      format.js 
    end
  end

  def user_notifications
    @user = current_user
    @user_notifications = @user.user_notifications.order("created_at DESC")
    
    @unread_notifications= @user_notifications.where(:read=>false)
    if @user.notification==true
      @user.notification=false
      @user.save
    end
    @notification=UserNotification.find_all_by_user_id(current_user.id)
    @notification.each do |notification|
      notification.read=true
      notification.save
    end
    
    respond_to do |format|
      format.js{render 'user_notifications'}
    end
  end


  # Before filters and actions
  private

    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:event_name,
                                    :event_description,
                                    :event_url,
                                    :master_event_category_id,
                                    :event_venue,
                                    :event_start_time,
                                    :event_end_time,
                                    :event_image,
                                    :paid,
                                    :payment_url,
                                    :user_id,
                                    :master_event_status_id, 
                                    :time_of_approval,
                                    :organizer,
                                    :related_links_list
                                    )
    end

    def event_status_check
      @event = Event.find(params[:id])
      if !MasterEventStatus.where("status in (?)", ["active", "completed"]).map(&:id).include?(@event.master_event_status_id)
        redirect_to root_path
      end
    end

    def sign_in_check
      if !user_signed_in?
        flash[:notice]="You need to sign-in to create an event."
        redirect_to root_path
      end
    end

    def edit_check
      if !['active', 'pending'].include?(@event.master_event_status.status) || (!user_signed_in? || (current_user.master_role.role=='user' && !(@event.organizers.present? && current_user == @event.organizers.first)))
        redirect_to root_path
      end
    end

    # def modal_event
    #   @event = Event.find(params[:id])
    #   @event_comment=EventComment.new
    #   respond_to do |format|
    #     format.js{ render 'event_modal'}
    #   end
    # end

end
