# frozen_string_literal: true

json.extract! family, :id, :name, :connect, :user, :deleted, :created_at, :updated_at
json.url family_url(family, format: :json)
