# frozen_string_literal: true

json.array! @fast_transactions, partial: 'fast_transactions/fast_transaction', as: :fast_transaction
