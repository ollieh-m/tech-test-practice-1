require "rails_helper"

RSpec.describe "User gets favourite language", type: :feature do
  scenario "Enters github username" do
    stub_request(:get, "https://api.github.com/users/username/repos").to_return(
      body: github_repos_response, status: 200)

    visit new_programming_language_suggestion_path
    fill_in "username", with: "username"
    click_on "Submit"

    expect(page).to have_content "Ruby"
  end

  def github_repos_response
    File.read(Rails.root.to_s + "/spec/fixtures/get_ruby_repo_example.json")
  end
end
