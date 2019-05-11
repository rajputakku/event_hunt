class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_user_email
  after_filter :store_location

  def set_user_email
    if params[:controller] == 'devise/sessions' && params[:action] == 'destroy'
    else
      if user_signed_in? && current_user.email.slice(0,9) == "change@me"
        flash[:notice]= "Change your email first to proceed "
        redirect_to edit_user_profile_path(current_user)
      end
    end
  end 

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get? 
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath 
    end
  end

  def after_sign_in_path_for(resource)
    if resource.sign_in_count == 1
      edit_user_profile_path(resource)
    else
      if resource.master_user_status_id == MasterUserStatus.find_by(status:'blocked').id
        sign_out(resource)
        flash[:notice] = 'You have been blocked by the admin!'
        root_path
      else
        session[:previous_url] || root_path
      end
    end
  end

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: lambda { |exception| render_error 500, exception }
    rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: lambda { |exception| render_error 404, exception }
  end

  private
  def render_error(status, exception)
    respond_to do |format|
      format.html { render template: "errors/error_#{status}", layout: 'layouts/error', status: status }
      format.all { render nothing: true, status: status }
    end
  end


end
