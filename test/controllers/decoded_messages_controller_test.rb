require "test_helper"

class DecodedMessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @decoded_message = decoded_messages(:one)
  end

  test "should get index" do
    get decoded_messages_url
    assert_response :success
  end

  test "should get new" do
    get new_decoded_message_url
    assert_response :success
  end

  test "should create decoded_message" do
    assert_difference("DecodedMessage.count") do
      post decoded_messages_url, params: { decoded_message: { blockchain: @decoded_message.blockchain, body_type: @decoded_message.body_type, dst: @decoded_message.dst, ext_id: @decoded_message.ext_id, name: @decoded_message.name, network: @decoded_message.network, src: @decoded_message.src } }
    end

    assert_redirected_to decoded_message_url(DecodedMessage.last)
  end

  test "should show decoded_message" do
    get decoded_message_url(@decoded_message)
    assert_response :success
  end

  test "should get edit" do
    get edit_decoded_message_url(@decoded_message)
    assert_response :success
  end

  test "should update decoded_message" do
    patch decoded_message_url(@decoded_message), params: { decoded_message: { blockchain: @decoded_message.blockchain, body_type: @decoded_message.body_type, dst: @decoded_message.dst, ext_id: @decoded_message.ext_id, name: @decoded_message.name, network: @decoded_message.network, src: @decoded_message.src } }
    assert_redirected_to decoded_message_url(@decoded_message)
  end

  test "should destroy decoded_message" do
    assert_difference("DecodedMessage.count", -1) do
      delete decoded_message_url(@decoded_message)
    end

    assert_redirected_to decoded_messages_url
  end
end
