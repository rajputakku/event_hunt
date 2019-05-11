class EventUpvotesController < ApplicationController
  before_action :set_event_upvote, only: [:show, :edit, :update, :destroy]

  # GET /event_upvotes
  # GET /event_upvotes.json
  def index
    @event_upvotes = EventUpvote.all
  end

  # GET /event_upvotes/1
  # GET /event_upvotes/1.json
  def show
  end

  # GET /event_upvotes/new
  def new
    @event_upvote = EventUpvote.new
  end

  # GET /event_upvotes/1/edit
  def edit
  end

  # POST /event_upvotes
  # POST /event_upvotes.json
  def create
    @event_upvote = EventUpvote.new(event_upvote_params)

    respond_to do |format|
      if @event_upvote.save
        format.html { redirect_to @event_upvote}
        format.json { render action: 'show', status: :created, location: @event_upvote }
      else
        format.html { render action: 'new' }
        format.json { render json: @event_upvote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /event_upvotes/1
  # PATCH/PUT /event_upvotes/1.json
  def update
    respond_to do |format|
      if @event_upvote.update(event_upvote_params)
        format.html { redirect_to @event_upvote }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event_upvote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_upvotes/1
  # DELETE /event_upvotes/1.json
  def destroy
    @event_upvote.destroy
    respond_to do |format|
      format.html { redirect_to event_upvotes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_upvote
      @event_upvote = EventUpvote.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_upvote_params
      params[:event_upvote]
    end
end
