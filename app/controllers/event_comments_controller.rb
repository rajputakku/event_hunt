class EventCommentsController < ApplicationController
  before_action :set_event_comment, only: [:show, :edit, :update, :destroy]

  def index
    @event_comments = EventComment.all
  end

  def show
  end

  def new
  end

  def edit
    @event = @event_comment.event
    respond_to do |format|
      format.js
    end
  end

  def create
    @event_comment = EventComment.new(event_comment_params)
    @event=Event.find(params[:event_id])
    @arr = params[:event_comment][:comment_text].split(" ")
    @arr.select{|e| e.chars.first=='@'}.each do |user|
      @newuser=user.gsub(/^./, "")
      @user=User.find_by_twitter_handle(@newuser)
      
      CommentMention.mentioned_in_comment(@event, @user, current_user).deliver

      if !@user.nil?
        @channel3 = "/mention_notification/private/#{@user.id}"
        @notification=UserNotification.new
        @notification.user_id=@user.id
        @notification.event_id=@event.id
        @notification.notification_text="You have been mentioned in a comment on #{@event.event_name} event."
        @notification.save
        @unread_notifications_mention=UserNotification.find_all_by_user_id_and_read(@user.id,false)
      end
    end
   
    respond_to do |format|
      if @event_comment.save
        if @event.user_id!=current_user.id
          @notification=UserNotification.new
          @channel1 = "/notification/private/#{@event.event_creator.id}"
          @notification.user_id=@event.event_creator.id
          @notification.event_id=@event.id
          @notification.notification_text="#{current_user.name} has commented on your event #{@event.event_name}."
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
            @notification.notification_text="#{current_user.name} has commented on your event #{@event.event_name}."
            @notification.save
            @unread_notifications_organizer=UserNotification.find_all_by_user_id_and_read(@event.organizers.first.id,false)
            # if @event.organizers.first.notification==false
            #   @user=User.find(@event.organizers.first.id)
            #   @user.notification=true
            #   @user.save
            # end
          end
        end
   
        @event = @event_comment.event
        format.html { redirect_to @event_comment}
        format.json { render action: 'show', status: :created, location: @event_comment }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @event_comment.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
    respond_to do |format|
      if @event_comment.update(event_comment_params)
        @event = @event_comment.event
        format.html { redirect_to @event_comment }
        format.json { head :no_content }
        format.js {render 'create'}
      else
        format.html { render action: 'edit' }
        format.json { render json: @event_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event = @event_comment.event
    @event_comment.destroy

    respond_to do |format|
      format.html { redirect_to event_comments_url }
      format.json { head :no_content }
      format.js
    end
  end


  private

    def set_event_comment
      @event_comment = EventComment.find(params[:id])
    end

    def event_comment_params
      params.require(:event_comment).permit(:event_id, :user_id,:comment_text)
    end

end
