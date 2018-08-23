class CapitalsController < ApplicationController
  before_action :set_capital, only: [:show, :edit, :update, :destroy]

  # GET /capitals
  # GET /capitals.json
  def index
    @capitals = Capital.all
  end

  # GET /capitals/1
  # GET /capitals/1.json
  def show
  end

  # GET /capitals/new
  def new
    @capital = Capital.new
  end

  # GET /capitals/1/edit
  def edit
  end

  # POST /capitals
  # POST /capitals.json
  def create
    @capital = Capital.new(capital_params)

    respond_to do |format|
      if @capital.save
        format.html { redirect_to @capital, notice: 'Capital was successfully created.' }
        format.json { render :show, status: :created, location: @capital }
      else
        format.html { render :new }
        format.json { render json: @capital.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /capitals/1
  # PATCH/PUT /capitals/1.json
  def update
    respond_to do |format|
      if @capital.update(capital_params)
        format.html { redirect_to @capital, notice: 'Capital was successfully updated.' }
        format.json { render :show, status: :ok, location: @capital }
      else
        format.html { render :edit }
        format.json { render json: @capital.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /capitals/1
  # DELETE /capitals/1.json
  def destroy
    @capital.destroy
    respond_to do |format|
      format.html { redirect_to capitals_url, notice: 'Capital was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_capital
      @capital = Capital.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def capital_params
      params.require(:capital).permit(:sum, :user, :local, :deleted)
    end
end
