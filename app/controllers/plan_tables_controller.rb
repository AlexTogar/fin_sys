class PlanTablesController < ApplicationController
  before_action :set_plan_table, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /plan_tables
  # GET /plan_tables.json
  def index
    @plan_tables = PlanTable.all
  end

  # GET /plan_tables/1
  # GET /plan_tables/1.json
  def show
  end

  # GET /plan_tables/new
  def new
    @plan_table = PlanTable.new
  end

  # GET /plan_tables/1/edit
  def edit
  end

  # POST /plan_tables
  # POST /plan_tables.json
  def create
    @plan_table = PlanTable.new(plan_table_params)

    respond_to do |format|
      if @plan_table.save
        format.html { redirect_to @plan_table, notice: 'Plan table was successfully created.' }
        format.json { render :show, status: :created, location: @plan_table }
      else
        format.html { render :new }
        format.json { render json: @plan_table.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plan_tables/1
  # PATCH/PUT /plan_tables/1.json
  def update
    respond_to do |format|
      if @plan_table.update(plan_table_params)
        format.html { redirect_to @plan_table, notice: 'Plan table was successfully updated.' }
        format.json { render :show, status: :ok, location: @plan_table }
      else
        format.html { render :edit }
        format.json { render json: @plan_table.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plan_tables/1
  # DELETE /plan_tables/1.json
  def destroy
    @plan_table.destroy
    respond_to do |format|
      format.html { redirect_to plan_tables_url, notice: 'Plan table was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plan_table
      @plan_table = PlanTable.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def plan_table_params
      params.require(:plan_table).permit(:data, :date_begin, :date_end, :local, :deleted)
    end
end
