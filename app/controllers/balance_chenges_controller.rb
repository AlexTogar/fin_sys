# frozen_string_literal: true

class BalanceChengesController < ApplicationController
  before_action :set_balance_chenge, only: %i[show edit update destroy]

  # GET /balance_chenges
  # GET /balance_chenges.json
  def index
    @balance_chenges = BalanceChenge.all
  end

  # GET /balance_chenges/1
  # GET /balance_chenges/1.json
  def show; end

  # GET /balance_chenges/new
  def new
    @balance_chenge = BalanceChenge.new
  end

  # GET /balance_chenges/1/edit
  def edit; end

  # POST /balance_chenges
  # POST /balance_chenges.json
  def create
    @balance_chenge = BalanceChenge.new(balance_chenge_params)

    respond_to do |format|
      if @balance_chenge.save
        format.html { redirect_to @balance_chenge, notice: 'Balance chenge was successfully created.' }
        format.json { render :show, status: :created, location: @balance_chenge }
      else
        format.html { render :new }
        format.json { render json: @balance_chenge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /balance_chenges/1
  # PATCH/PUT /balance_chenges/1.json
  def update
    respond_to do |format|
      if @balance_chenge.update(balance_chenge_params)
        format.html { redirect_to @balance_chenge, notice: 'Balance chenge was successfully updated.' }
        format.json { render :show, status: :ok, location: @balance_chenge }
      else
        format.html { render :edit }
        format.json { render json: @balance_chenge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /balance_chenges/1
  # DELETE /balance_chenges/1.json
  def destroy
    @balance_chenge.destroy
    respond_to do |format|
      format.html { redirect_to balance_chenges_url, notice: 'Balance chenge was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_balance_chenge
    @balance_chenge = BalanceChenge.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def balance_chenge_params
    params.require(:balance_chenge).permit(:sum)
  end
end
