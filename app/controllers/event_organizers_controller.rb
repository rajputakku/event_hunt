class EventOrganizersController < ApplicationController
  before_action :set_event_organizer, only: [:show, :edit, :update, :destroy]

  # GET /event_organizers
  # GET /event_organizers.json
  def index
    @event_organizers = EventOrganizer.all
  end

  # GET /event_organizers/1
  # GET /event_organizers/1.json
  def show
  end

  # GET /event_organizers/new
  def new
    @event_organizer = EventOrganizer.new
  end

  # GET /event_organizers/1/edit
  def edit
  end

  # POST /event_organizers
  # POST /event_organizers.json
  def create
    @event_organizer = EventOrganizer.new(event_organizer_params)

    respond_to do |format|
      if @event_organizer.save
        format.html { redirect_to @event_organizer }
        format.json { render action: 'show', status: :created, location: @event_organizer }
      else
        format.html { render action: 'new' }
        format.json { render json: @event_organizer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /event_organizers/1
  # PATCH/PUT /event_organizers/1.json
  def update
    respond_to do |format|
      if @event_organizer.update(event_organizer_params)
        format.html { redirect_to @event_organizer}
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event_organizer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_organizers/1
  # DELETE /event_organizers/1.json
  def destroy
    @event_organizer.destroy
    respond_to do |format|
      format.html { redirect_to event_organizers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_organizer
      @event_organizer = EventOrganizer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_organizer_params
      params[:event_organizer]
    end
end
