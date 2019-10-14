class BaseController < ApplicationController
  before_action :authenticate_user!
  include BaseHelper
  require 'telegram/bot'
  require_relative '../../Calc_query.rb'
  include Calculate
  require_relative '../../Telegram.rb'
  include My_telegram

 

  def graph
    date_begin = if params[:date_begin].nil?
                   Date.today.at_beginning_of_month
                 else
                   params[:date_begin].to_time
                 end

    date_end = if params[:date_end].nil?
                 Date.today
               else
                 params[:date_end].to_time
               end

    user = params[:user] || 'all' # all или id пользователя
    sign = params[:sign] || 'balance' # balance, all, exspense, profit

    @points = if params[:points].nil?
                true
              else
                to_bool(str: params[:points]) # str 'false' to fasle (FalseClass)
              end

    @curve = if params[:curve].nil?
               true
             else
               to_bool(str: params[:curve]) # str 'false' to fasle (FalseClass)
             end

    delete_condition = 'transactions.deleted = false'

    records = []
    start_records = Transaction
                    .where(created_at: (date_begin..date_end + 1.day))
                    .where(delete_condition)
                    .order(created_at: 'desc')
    if sign != 'balance' # balance
      @balance = false
      start_records.each do |x|
        flag = true
        if user == 'all'
          if has_family
            flag = false if User.find(x.user).family != has_family
          else
            flag = false if x.user != current_user.id
          end

        else
          flag = false if x.user.to_s != user
        end
        reason_sign = Reason.find(x.reason).sign
        case sign
        when 'expense'
          flag = false if !reason_sign
        when 'profit'
          flag = false if reason_sign
        end

        records << x if flag
      end
      # find information from records

      names = records.map { |elem| { id: elem.user, name: User.find(elem.user).email } }.uniq

      names.each do |name|
        data = records.map do |tran|
          if Reason.find(tran.reason).sign == false
            { sum: tran.sum, date: my_time(tran.created_at.to_s) }
          else
            { sum: 0 - tran.sum, date: tran.created_at } if tran.user == name[:id]
          end
        end
        name[:data] = data.compact
      end
      @data = names

    else
      @balance = true
      transactions = Transaction.where(deleted: false).select { |x| x.user.in? User.where(family: current_user.family).map(&:id) }
      debts = Debt.where(deleted: false).select { |x| x.user.in? User.where(family: current_user.family).map(&:id) }
      capitals = Capital.where(deleted: false).select { |x| x.user.in? User.where(family: current_user.family).map(&:id) }

      transactions.map! { |x| { date: x.created_at, sum: (Reason.find(x.reason).sign == false ? x.sum : -x.sum) } }
      debts.map! { |x| { date: x.created_at, sum: (x.sign == false ? -x.sum : x.sum) } }
      capitals.map! { |x| { date: x.created_at, sum: (x.sign == false ? -x.sum : x.sum) } }

      # mass = (transactions + debts + capitals).sort_by {|x| x[:date]} #balance будет равен free money (caital учитывается)
      mass = (transactions + debts).sort_by { |x| x[:date] } # balance != free money (capital не учитывается)
      i = 0
      @data = []

      mass.each do |x|
        if (x[:date] >= date_begin) && (x[:date] <= date_end + 1.day)
          @data << { date: x[:date], sum: mass.map { |x| x[:sum] }[0..i].sum }
        end
        i += 1
      end

    end
  end

  def main_tab; end

  def new_fast_transaction
    @fastTransactions = FastTransaction.where(deleted: 'false', user: current_user.id)
  end

  def join
    @reasons_profit = get_records(table_name: 'reasons', add_condition: "and reasons.sign = false and (reasons.local = false or reasons.user = #{current_user.id}) order by reasons.often DESC")
    @reasons_expence = get_records(table_name: 'reasons', add_condition: "and reasons.sign = true and (reasons.local = false or reasons.user = #{current_user.id}) order by reasons.often DESC")
    @group = User.where(family: has_family)

    date_begin = if params[:date_begin].nil?
                   Date.today.at_beginning_of_month
                 else
                   params[:date_begin].to_time
                 end

    date_end = if params[:date_end].nil?
                 Date.today + 1.day
               else
                 params[:date_end].to_time + 1.day
               end

    reason_p = params[:reason_p] || 'all'
    reason_e = params[:reason_e] || 'all'

    if reason_p == 'all'
      @data_profit = @group.map { |user| [user.email, Transaction.where(user: user.id, created_at: (date_begin..date_end), deleted: false).select { |tran| Reason.find(tran.reason).sign == false }.inject(0) { |result, tran| result + tran.sum }] }
    else
      @data_profit = @group.map { |user| [user.email, Transaction.where(user: user.id, created_at: (date_begin..date_end), deleted: false).select { |tran| tran.reason.to_s == reason_p }.inject(0) { |result, tran| result + tran.sum }] }
    end

    if reason_e == 'all'
      @data_expense = @group.map { |user| [user.email, Transaction.where(user: user.id, created_at: (date_begin..date_end), deleted: false).select { |tran| Reason.find(tran.reason).sign == true }.inject(0) { |result, tran| result + tran.sum }] }
    else
      @data_expense = @group.map { |user| [user.email, Transaction.where(user: user.id, created_at: (date_begin..date_end), deleted: false).select { |tran| tran.reason.to_s == reason_e }.inject(0) { |result, tran| result + tran.sum }] }

    end
  end

  def new_family
    name = params[:name]
    connect = params[:connect]
    user = current_user.id
    deleted = false
    action = params[:my_action]
    if action == 'true'

      if family_size = Family.find_by_sql("select * from families where name = '#{name}' ").empty?
        new_family = Family.new(name: name, connect: connect, user: user, deleted: deleted)
        new_family.save
        User.update(current_user.id, family: new_family.id)
        redirect_to base_join_path, notice: 'The group was created successfully'
      else
        redirect_to base_join_path, notice: 'This name is already taken, choose another'
      end

    else
      if Family.exists?(name: name, connect: connect)
        family_connect = Family.find_by_sql("select * from families where name = '#{name}' and connect = '#{connect}' ")[0]
        User.update(current_user.id, family: family_connect.id)
        redirect_to base_join_path, notice: 'The connection successfully completed'
      else
        redirect_to base_join_path, notice: 'Invalid name or connection password'
      end

    end
  end

  def new_transaction
    @transactions = get_records(table_name: 'transactions', add_condition: 'order by transactions.created_at DESC')[0..4]
    @reasons = get_records(table_name: 'reasons', add_condition: "and (reasons.local = false or reasons.user = #{current_user.id}) order by reasons.often DESC")
    @my_debts = get_records(table_name: 'debts', add_condition: "and (debts.local = false or debts.user = #{current_user.id})")
    @my_fast_transactions = get_records(table_name: 'fast_transactions', add_condition: "and (fast_transactions.local = false or fast_transactions.user = #{current_user.id})")
  end

  def debts
    @my_debts = get_records(table_name: 'debts', add_condition: "and (debts.local = false or debts.user = #{current_user.id})")
  end

  def delete_debt
    id = params[:id]
    href = params[:href]
    begin
      Debt.update(id, deleted: true)
      redirect_to href, notice: 'Debt was successfully deleted'
    rescue StandardError
      redirect_to href, notice: 'Debt can not be deleted'
    end
  end

  def response_on_new_transaction

    mihail_chat_id = 299_454_049
    alex_chat_id = 479_039_553

    fast_tran = params[:fast_tran]
    if fast_tran.nil?

      # begin
      query = Calc_query.new(input: params[:sum])
      sum = query.send
      # rescue StandardError
      #   sum = 404 # если не заработает html валидатор
      # end
      new_transaction = Transaction.new(
        sum: sum,
        description: params[:description],
        reason: params[:reason],
        user: current_user.id,
        local: (params[:local].nil? ? 'true' : params[:local]),
        deleted: false
      )
      Reason.update(params[:reason], often: Reason.find(params[:reason]).often + 1)
      new_transaction.save
      # отправка сообщения о транзакции (если заносится вручную)
      [alex_chat_id, mihail_chat_id].each do |id|
        Message.new(chat_id: id, sum: sum, current_user: current_user, description: params[:description], reason: Reason.find(params[:reason]).reason, enable: true).send
      end

      @data = { sum: sum,
                reason: Reason.find(params[:reason]).reason,
                user: current_user.email,
                date: my_time(new_transaction.created_at.to_s),
                sign: Reason.find(params[:reason]).sign,
                id: new_transaction.id }

      respond_to do |x|
        x.json { render json: @data.to_json }
      end

    else # if fast_tran != nil
      fast_tran = FastTransaction.find(fast_tran)

      new_transaction = Transaction.new(
        sum: fast_tran.sum,
        description: '',
        reason: fast_tran.reason,
        user: current_user.id,
        local: true,
        deleted: false
      )
      Reason.update(fast_tran.reason, often: Reason.find(fast_tran.reason).often + 1)
      new_transaction.save
      #отправка сообщения о транзакции (если заносится через быструю транзакцию)
      [alex_chat_id, mihail_chat_id].each do |id|
        Message.new(chat_id: id, sum: fast_tran.sum, current_user: current_user, reason: Reason.find(fast_tran.reason).reason, enable: true).send
      end
      @data = { sum: fast_tran.sum,
                reason: Reason.find(fast_tran.reason).reason,
                user: current_user.email,
                date: my_time(new_transaction.created_at.to_s),
                sign: Reason.find(fast_tran.reason).sign,
                id: new_transaction.id }

      respond_to do |x|
        x.json { render json: @data.to_json }
      end

    end
  end

  def new_reason
    @my_reasons = Reason.where(deleted: 'false', user: current_user.id).order(:created_at)
  end

  def delete_reason
    id = params[:id]
    begin
      Reason.update(id, deleted: 'true')
      redirect_to base_new_reason_path, notice: 'Reason was successfully deleted'
    rescue StandardError
      redirect_to base_new_reason_path, notice: 'Reason can not be deleted'
    end
  end

  def create_new_reason
    reason = params[:reason]
    sign = params[:sign]
    often = 0
    local = params[:local]
    user = current_user.id
    deleted = false

    new_reason = Reason.new(reason: reason, sign: sign, often: often, local: local, user: user, deleted: deleted)
    if Reason.exists?(reason: reason, user: user)
      redirect_to base_new_reason_path, notice: 'Reason already exists'
    else
      new_reason.save
      redirect_to base_new_reason_path, notice: 'Reason was successfully created.'
    end
  rescue StandardError
    redirect_to base_new_reason_path, notice: 'Error, reason cannot be added'
  end

  def leave_the_group
    current_family = current_user.family

    User.update(current_user.id, family: nil)

    unless User.exists?(family: current_family)
      Family.find(current_user.family).destroy
    end
    redirect_to base_join_path, notice: 'You have successfully exited the group'
  end

  def delete_transaction
    tran_id = params[:tran_id].to_i
    Transaction.update(tran_id, deleted: 'true')
    often = Reason.find(Transaction.find(tran_id).reason).often
    Reason.find(Transaction.find(tran_id).reason).update(often: often - 1)
  end

  def create_new_fast_transaction
    name = params[:name]
    reason = params[:reason]
    begin
      sum = eval(params[:sum].to_s).to_i
    rescue StandardError
      sum = 0
    end
    user = current_user.id
    local = params[:local]
    deleted = false

    begin
      newFastTran = FastTransaction.new(name: name, reason: reason, sum: sum, user: user, local: local, deleted: deleted)
      newFastTran.save
    rescue StandardError
      redirect_to base_new_fast_transaction_path, notice: 'Fast transaction cannot be created'
    end

    redirect_to base_new_fast_transaction_path, notice: 'Fast transaction was successfully created'
  end

  def new_debt
    begin
      sum = eval(params[:sum].to_s).to_i
    rescue StandardError
      sum = 0 # если не заработает html валидатор
    end

    begin
      you_debtor = params[:you_debtor]
      you_debtor = you_debtor != 'false'
      debtor = params[:debtor]
      reason = params[:reason]
      description = params[:description]
      user = current_user.id
      local = params[:local]
      deleted = false
      sign = you_debtor ? true : false
      debt_new = Debt.new(sum: sum, you_debtor: you_debtor, debtor: debtor, description: description, user: user, local: local, deleted: deleted, sign: sign)
      debt_new.save

      redirect_to base_new_transaction_path, notice: 'Debt was successfully created'
    rescue StandardError
      redirect_to base_new_transaction_path, notice: 'Debt canntot be added'
    end
  end

  def update_table
    date_begin = params[:date_begin].to_time
    date_end = params[:date_end].to_time
    user = params[:user] # all или id пользователя
    type = params[:type] != '' ? params[:type] : 'all' # all/personal/joint
    reason = params[:reason] # all или id причины
    sign = params[:sign] # all, exspense, profit

    delete_condition = 'transactions.deleted = false'

    records = []
    start_records = Transaction
                    .where(created_at: (date_begin..date_end + 1.day))
                    .where(delete_condition)
                    .order(created_at: 'desc')
    start_records.each do |x|
      flag = true
      if user == 'all'
        if has_family #try - catch to find error
        begin
          flag = false if User.find(x.user).family != has_family
        rescue
          puts x
        end
        else
          flag = false if x.user != current_user.id
        end

      else
        flag = false if x.user.to_s != user
      end

      case type
      when 'personal'
        flag = false if x.local != true
      when 'joint'
        flag = false if x.local == true
      end

      if reason != 'all'
        flag = false if x.reason.to_s != reason
      end

      case sign
      when 'expense'
        flag = false if Reason.find(x.reason).sign == false
      when 'profit'
        flag = false if Reason.find(x.reason).sign == true
      end

      records << x if flag
    end
    col_sum = records.inject(0) { |result, elem| Reason.find(elem.reason).sign == false ? result + elem.sum : result - elem.sum }

    i = 0
    @data = {}
    records.each do |tran|
      @data[i] = { id: tran.id,
                   sum: tran.sum,
                   user: User.find(tran.user).email,
                   reason: Reason.find(tran.reason).reason,
                   description: (tran.description == '' ? 'Empty' : tran.description),
                   date: my_time(tran.created_at.to_s),
                   sign: Reason.find(tran.reason).sign,
                   size: records.size,
                   col_sum: col_sum }
      i += 1
    end

    respond_to do |x|
      x.json { render json: @data }
    end
  end

  def set_aside
    @savings_users_sum = (family.map { |x| Capital.exists?(user: x.id) ? [x.email, capitals(sign:false, user: x.id) - capitals(sign:true, user: x.id), capitals(sign:false, user: x.id), capitals(sign:true, user: x.id)] : [x.email, 0, 0, 0] }).compact
    @total = @savings_users_sum.inject(0) { |result, elem| !elem.nil? ? result + elem[1] : result + 0 }
    @total = 0 if @total.nil?
  end

  def capitals(sign:, user:)
    Capital.where(user: user, deleted: false, sign: sign).pluck(:sum).sum
  end

  def create_deposit
    sign = params[:sign]
    begin
      sum = eval(params[:sum].to_s).to_i
    rescue StandardError
      sum = 0 # если не заработает html валидатор
    end
    user = current_user.id
    savings_users_sum = (family.map  { |x| Capital.exists?(user: x.id) ? [x.email, capitals(sign:false, user: x.id) - capitals(sign:true, user: x.id), capitals(sign:false, user: x.id), capitals(sign:true, user: x.id)] : [x.email, 0, 0, 0] }).compact

    current_sum = savings_users_sum.inject(0) { |result, elem| result + elem[1] }
    if sign == 'true'
      if current_sum >= sum.to_i
        capital_new = Capital.new(sum: sum, user: user, deleted: false, sign: sign)
        capital_new.save
        notice = "#{sum} rubles successfully withdrawn"
        redirect_to base_set_aside_path, notice: notice
      else
        notice = 'Too much money'
        redirect_to base_set_aside_path, notice: notice
      end
    else

      capital_new = Capital.new(sum: sum, user: user, deleted: false, sign: sign)
      capital_new.save
      notice = "#{sum} rubles pending successful"
      redirect_to base_set_aside_path, notice: notice
    end
  end

  def delete_fast_transaction
    id = params[:id]
    FastTransaction.update(id, deleted: true)
    notice = 'Fast transaciton was successfully deleted'
    redirect_to base_new_fast_transaction_path, notice: notice
  end

  def update_graph; end
end
