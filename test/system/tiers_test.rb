require "application_system_test_case"

class TiersTest < ApplicationSystemTestCase
  setup do
    @tier = tiers(:one)
  end

  test "visiting the index" do
    visit tiers_url
    assert_selector "h1", text: "Tiers"
  end

  test "should create tier" do
    visit tiers_url
    click_on "New tier"

    fill_in "Id", with: @tier.id
    fill_in "Minspent", with: @tier.minSpent
    fill_in "Name", with: @tier.name
    click_on "Create Tier"

    assert_text "Tier was successfully created"
    click_on "Back"
  end

  test "should update Tier" do
    visit tier_url(@tier)
    click_on "Edit this tier", match: :first

    fill_in "Id", with: @tier.id
    fill_in "Minspent", with: @tier.minSpent
    fill_in "Name", with: @tier.name
    click_on "Update Tier"

    assert_text "Tier was successfully updated"
    click_on "Back"
  end

  test "should destroy Tier" do
    visit tier_url(@tier)
    click_on "Destroy this tier", match: :first

    assert_text "Tier was successfully destroyed"
  end
end
