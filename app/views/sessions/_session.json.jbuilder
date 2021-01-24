json.extract! session, :id, :title, :comment, :date, :duration, :created_at, :updated_at
json.url session_url(session, format: :json)
