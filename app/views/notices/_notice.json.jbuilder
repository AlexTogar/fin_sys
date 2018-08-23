json.extract! notice, :id, :text, :user, :destination, :tran, :deleted, :created_at, :updated_at
json.url notice_url(notice, format: :json)
