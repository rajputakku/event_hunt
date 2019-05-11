class UserNotificationsController < ApplicationController
  before_action :set_user_notification, only: [:show, :edit, :update, :destroy]

  
  def clear_notifications
    @user=User.find(params[:id])
    @user.user_notifications.delete_all
    @user_notifications = @user.user_notifications.order("created_at DESC")
    respond_to do |format|
      format.js
    end

  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_notification
      @user_notification = UserNotification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_notification_params
      params[:user_notification]
    end
end
