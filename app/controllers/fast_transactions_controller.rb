class FastTransactionsController < ApplicationController
  before_action :set_fast_transaction, only: [:show, :edit, :update, :destroy]

  # GET /fast_transactions
  # GET /fast_transactions.json
  def index
    @fast_transactions = FastTransaction.all
  end

  # GET /fast_transactions/1
  # GET /fast_transactions/1.json
  def show
  end

  # GET /fast_transactions/new
  def new
    @fast_transaction = FastTransaction.new
  end

  # GET /fast_transactions/1/edit
  def edit
  end

  # POST /fast_transactions
  # POST /fast_transactions.json
  def create
    @fast_transaction = FastTransaction.new(fast_transaction_params)

    respond_to do |format|
      if @fast_transaction.save
        format.html { redirect_to @fast_transaction, notice: 'Fast transaction was successfully created.' }
        format.json { render :show, status: :created, location: @fast_transaction }
      else
        format.html { render :new }
        format.json { render json: @fast_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fast_transactions/1
  # PATCH/PUT /fast_transactions/1.json
  def update
    respond_to do |format|
      if @fast_transaction.update(fast_transaction_params)
        format.html { redirect_to @fast_transaction, notice: 'Fast transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @fast_transaction }
      else
        format.html { render :edit }
        format.json { render json: @fast_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fast_transactions/1
  # DELETE /fast_transactions/1.json
  def destroy
    @fast_transaction.destroy
    respond_to do |format|
      format.html { redirect_to fast_transactions_url, notice: 'Fast transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fast_transaction
      @fast_transaction = FastTransaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fast_transaction_params
      params.require(:fast_transaction).permit(:sum, :reason, :often, :user, :local, :deleted)
    end
end
