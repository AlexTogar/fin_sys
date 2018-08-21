json.extract! transaction, :id, :sum, :description, :reason, :score, :user, :local, :debt_sum, :debtor, :deleted, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
