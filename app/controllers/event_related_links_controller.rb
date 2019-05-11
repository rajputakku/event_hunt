class EventRelatedLinksController < ApplicationController
  before_action :set_event_related_link, only: [:show, :edit, :update, :destroy]

  # GET /event_related_links
  # GET /event_related_links.json
  def index
    @event_related_links = EventRelatedLink.all
  end

  # GET /event_related_links/1
  # GET /event_related_links/1.json
  def show
  end

  # GET /event_related_links/new
  def new
    @event_related_link = EventRelatedLink.new
  end

  # GET /event_related_links/1/edit
  def edit
  end

  # POST /event_related_links
  # POST /event_related_links.json
  def create
    @event_related_link = EventRelatedLink.new(event_related_link_params)

    respond_to do |format|
      if @event_related_link.save
        format.html { redirect_to @event_related_link }
        format.json { render action: 'show', status: :created, location: @event_related_link }
      else
        format.html { render action: 'new' }
        format.json { render json: @event_related_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /event_related_links/1
  # PATCH/PUT /event_related_links/1.json
  def update
    respond_to do |format|
      if @event_related_link.update(event_related_link_params)
        format.html { redirect_to @event_related_link }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event_related_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_related_links/1
  # DELETE /event_related_links/1.json
  def destroy
    @event_related_link.destroy
    respond_to do |format|
      format.html { redirect_to event_related_links_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_related_link
      @event_related_link = EventRelatedLink.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_related_link_params
      params[:event_related_link]
    end
end
