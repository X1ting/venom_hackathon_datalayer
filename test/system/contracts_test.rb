require "application_system_test_case"

class ContractsTest < ApplicationSystemTestCase
  setup do
    @contract = contracts(:one)
  end

  test "visiting the index" do
    visit contracts_url
    assert_selector "h1", text: "Contracts"
  end

  test "should create contract" do
    visit contracts_url
    click_on "New contract"

    fill_in "Blockchain", with: @contract.blockchain
    fill_in "Code hash", with: @contract.code_hash
    fill_in "Compiler version", with: @contract.compiler_version
    fill_in "Contract name", with: @contract.contract_name
    fill_in "Linker version", with: @contract.linker_version
    fill_in "Network", with: @contract.network
    fill_in "Project link", with: @contract.project_link
    fill_in "Tvc", with: @contract.tvc
    click_on "Create Contract"

    assert_text "Contract was successfully created"
    click_on "Back"
  end

  test "should update Contract" do
    visit contract_url(@contract)
    click_on "Edit this contract", match: :first

    fill_in "Blockchain", with: @contract.blockchain
    fill_in "Code hash", with: @contract.code_hash
    fill_in "Compiler version", with: @contract.compiler_version
    fill_in "Contract name", with: @contract.contract_name
    fill_in "Linker version", with: @contract.linker_version
    fill_in "Network", with: @contract.network
    fill_in "Project link", with: @contract.project_link
    fill_in "Tvc", with: @contract.tvc
    click_on "Update Contract"

    assert_text "Contract was successfully updated"
    click_on "Back"
  end

  test "should destroy Contract" do
    visit contract_url(@contract)
    click_on "Destroy this contract", match: :first

    assert_text "Contract was successfully destroyed"
  end
end
