class MasterRolesController < ApplicationController
  before_action :set_master_role, only: [:show, :edit, :update, :destroy]

  # GET /master_roles
  # GET /master_roles.json
  def index
    @master_roles = MasterRole.all
  end

  # GET /master_roles/1
  # GET /master_roles/1.json
  def show
  end

  # GET /master_roles/new
  def new
    @master_role = MasterRole.new
  end

  # GET /master_roles/1/edit
  def edit
  end

  # POST /master_roles
  # POST /master_roles.json
  def create
    @master_role = MasterRole.new(master_role_params)

    respond_to do |format|
      if @master_role.save
        format.html { redirect_to @master_role }
        format.json { render action: 'show', status: :created, location: @master_role }
      else
        format.html { render action: 'new' }
        format.json { render json: @master_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /master_roles/1
  # PATCH/PUT /master_roles/1.json
  def update
    respond_to do |format|
      if @master_role.update(master_role_params)
        format.html { redirect_to @master_role}
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @master_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /master_roles/1
  # DELETE /master_roles/1.json
  def destroy
    @master_role.destroy
    respond_to do |format|
      format.html { redirect_to master_roles_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_master_role
      @master_role = MasterRole.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def master_role_params
      params[:master_role]
    end
end
