class MasterEventStatusesController < ApplicationController
  before_action :set_master_event_status, only: [:show, :edit, :update, :destroy]

  # GET /master_event_statuses
  # GET /master_event_statuses.json
  def index
    @master_event_statuses = MasterEventStatus.all
  end

  # GET /master_event_statuses/1
  # GET /master_event_statuses/1.json
  def show
  end

  # GET /master_event_statuses/new
  def new
    @master_event_status = MasterEventStatus.new
  end

  # GET /master_event_statuses/1/edit
  def edit
  end

  # POST /master_event_statuses
  # POST /master_event_statuses.json
  def create
    @master_event_status = MasterEventStatus.new(master_event_status_params)

    respond_to do |format|
      if @master_event_status.save
        format.html { redirect_to @master_event_status}
        format.json { render action: 'show', status: :created, location: @master_event_status }
      else
        format.html { render action: 'new' }
        format.json { render json: @master_event_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /master_event_statuses/1
  # PATCH/PUT /master_event_statuses/1.json
  def update
    respond_to do |format|
      if @master_event_status.update(master_event_status_params)
        format.html { redirect_to @master_event_status}
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @master_event_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /master_event_statuses/1
  # DELETE /master_event_statuses/1.json
  def destroy
    @master_event_status.destroy
    respond_to do |format|
      format.html { redirect_to master_event_statuses_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_master_event_status
      @master_event_status = MasterEventStatus.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def master_event_status_params
      params[:master_event_status]
    end
end
