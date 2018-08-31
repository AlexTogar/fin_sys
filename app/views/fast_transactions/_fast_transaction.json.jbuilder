# frozen_string_literal: true

json.extract! fast_transaction, :id, :sum, :reason, :often, :user, :local, :deleted, :created_at, :updated_at
json.url fast_transaction_url(fast_transaction, format: :json)
