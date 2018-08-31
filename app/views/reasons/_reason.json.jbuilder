# frozen_string_literal: true

json.extract! reason, :id, :reason, :sign, :often, :local, :user, :deleted, :created_at, :updated_at
json.url reason_url(reason, format: :json)
