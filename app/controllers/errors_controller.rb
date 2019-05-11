class ErrorsController < ApplicationController


	def error_404
    @not_found_path = params[:not_found]
    respond_to do |format|
      format.html { render  layout: 'layouts/error', status: status }
      format.all { render nothing: true, status: status }
    end
  end

  def error_500
  end
end

# class ErrorsController < ApplicationController

#  def not_found
#    render :status => 404
#  end

#  def unacceptable
#    render :status => 422
#  end

#  def internal_error
#    render :status => 500
#  end

# end
