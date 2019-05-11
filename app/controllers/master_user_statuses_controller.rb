class MasterUserStatusesController < ApplicationController
  before_action :set_master_user_status, only: [:show, :edit, :update, :destroy]

  # GET /master_user_statuses
  # GET /master_user_statuses.json
  def index
    @master_user_statuses = MasterUserStatus.all
  end

  # GET /master_user_statuses/1
  # GET /master_user_statuses/1.json
  def show
  end

  # GET /master_user_statuses/new
  def new
    @master_user_status = MasterUserStatus.new
  end

  # GET /master_user_statuses/1/edit
  def edit
  end

  # POST /master_user_statuses
  # POST /master_user_statuses.json
  def create
    @master_user_status = MasterUserStatus.new(master_user_status_params)

    respond_to do |format|
      if @master_user_status.save
        format.html { redirect_to @master_user_status }
        format.json { render action: 'show', status: :created, location: @master_user_status }
      else
        format.html { render action: 'new' }
        format.json { render json: @master_user_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /master_user_statuses/1
  # PATCH/PUT /master_user_statuses/1.json
  def update
    respond_to do |format|
      if @master_user_status.update(master_user_status_params)
        format.html { redirect_to @master_user_status}
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @master_user_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /master_user_statuses/1
  # DELETE /master_user_statuses/1.json
  def destroy
    @master_user_status.destroy
    respond_to do |format|
      format.html { redirect_to master_user_statuses_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_master_user_status
      @master_user_status = MasterUserStatus.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def master_user_status_params
      params[:master_user_status]
    end
end
