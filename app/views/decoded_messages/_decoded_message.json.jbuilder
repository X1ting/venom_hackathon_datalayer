json.extract! decoded_message, :id, :blockchain, :network, :ext_id, :src, :dst, :body_type, :name, :created_at, :updated_at
json.url decoded_message_url(decoded_message, format: :json)
