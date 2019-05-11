class MasterEventCategoriesController < ApplicationController
  before_action :set_master_event_category, only: [:show, :edit, :update, :destroy]

  # GET /master_event_categories
  # GET /master_event_categories.json
  def index
    @master_event_categories = MasterEventCategory.all
  end

  # GET /master_event_categories/1
  # GET /master_event_categories/1.json
  def show
  end

  # GET /master_event_categories/new
  def new
    @master_event_category = MasterEventCategory.new
  end

  # GET /master_event_categories/1/edit
  def edit
  end

  # POST /master_event_categories
  # POST /master_event_categories.json
  def create
    @master_event_category = MasterEventCategory.new(master_event_category_params)

    respond_to do |format|
      if @master_event_category.save
        format.html { redirect_to @master_event_category}
        format.json { render action: 'show', status: :created, location: @master_event_category }
      else
        format.html { render action: 'new' }
        format.json { render json: @master_event_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /master_event_categories/1
  # PATCH/PUT /master_event_categories/1.json
  def update
    respond_to do |format|
      if @master_event_category.update(master_event_category_params)
        format.html { redirect_to @master_event_category}
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @master_event_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /master_event_categories/1
  # DELETE /master_event_categories/1.json
  def destroy
    @master_event_category.destroy
    respond_to do |format|
      format.html { redirect_to master_event_categories_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_master_event_category
      @master_event_category = MasterEventCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def master_event_category_params
      params[:master_event_category]
    end
end
