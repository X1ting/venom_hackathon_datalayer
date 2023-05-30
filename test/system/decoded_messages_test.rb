require "application_system_test_case"

class DecodedMessagesTest < ApplicationSystemTestCase
  setup do
    @decoded_message = decoded_messages(:one)
  end

  test "visiting the index" do
    visit decoded_messages_url
    assert_selector "h1", text: "Decoded messages"
  end

  test "should create decoded message" do
    visit decoded_messages_url
    click_on "New decoded message"

    fill_in "Blockchain", with: @decoded_message.blockchain
    fill_in "Body type", with: @decoded_message.body_type
    fill_in "Dst", with: @decoded_message.dst
    fill_in "Ext", with: @decoded_message.ext_id
    fill_in "Name", with: @decoded_message.name
    fill_in "Network", with: @decoded_message.network
    fill_in "Src", with: @decoded_message.src
    click_on "Create Decoded message"

    assert_text "Decoded message was successfully created"
    click_on "Back"
  end

  test "should update Decoded message" do
    visit decoded_message_url(@decoded_message)
    click_on "Edit this decoded message", match: :first

    fill_in "Blockchain", with: @decoded_message.blockchain
    fill_in "Body type", with: @decoded_message.body_type
    fill_in "Dst", with: @decoded_message.dst
    fill_in "Ext", with: @decoded_message.ext_id
    fill_in "Name", with: @decoded_message.name
    fill_in "Network", with: @decoded_message.network
    fill_in "Src", with: @decoded_message.src
    click_on "Update Decoded message"

    assert_text "Decoded message was successfully updated"
    click_on "Back"
  end

  test "should destroy Decoded message" do
    visit decoded_message_url(@decoded_message)
    click_on "Destroy this decoded message", match: :first

    assert_text "Decoded message was successfully destroyed"
  end
end
