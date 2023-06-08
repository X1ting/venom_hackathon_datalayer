class DecodedMessageSerializer
  include JSONAPI::Serializer
  attributes :blockchain, :network, :ext_id, :src, :dst, :body_type, :name, :value, :header, :contract_uuid, :ext_created_at
end
