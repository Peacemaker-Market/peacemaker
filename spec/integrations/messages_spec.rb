require 'integration_helper'

feature 'viewing and managing ads', :js, :perform_jobs, :integration do
  # let!(:peer) { create(:peer) }

  scenario 'creating an ad that propagates to a peer' do
    create_ads

    test_direct_message
    test_blinded_message
  end

  def visit_peer(number, path = "marketplace")
    visit "http://peer_#{number}:3000/#{path}"
  end

  def expect_ad_to_have_propagated_to_all_peers(ad_title, expectation = :to)
    [2,3,4].each do |number|
      sleep 2
      visit_peer(number)
      expect(page).send(expectation, have_content(ad_title))
    end
  end

  def create_ads
    visit_peer(1, 'peers')
    expect(page).to have_content('Peer 2')
    click_on 'Ads'

    click_on 'New ad'

    fill_in 'Title', with: 'Farm fresh pogs'
    fill_in 'Description', with: 'Only the best'

    click_on 'Create Ad'
    expect(page).to have_content('Ad was successfully created.')
    click_on 'Back to Ads'

    expect(page).to have_content('Farm fresh pogs')
    sleep 2

    click_on 'New ad'

    fill_in 'Title', with: 'Raw milk'
    fill_in 'Description', with: 'straight from bessy'
    choose 'Blinded'

    click_on 'Create Ad'
    expect(page).to have_content('Ad was successfully created.')
    click_on 'Back to Ads'

    expect(page).to have_content('Raw milk')
    sleep 2
  end

  def test_direct_message
    visit_peer(4, 'marketplace')
    click_on 'Farm fresh pogs'
    click_on 'Message'

    fill_in 'Body', with: 'Is this still available?'
    click_on 'Send'

    sleep 2

    visit_peer(1, 'messages')
    click_on "Farm fresh pogs"
    expect(page).to have_content("Is this still available?")
    fill_in 'message_body', with: 'Yes.'
    click_on 'Send'

    sleep 2
    visit_peer(4, 'messages')
    click_on 'Farm fresh pogs'
    expect(page).to have_content('Yes.')
    fill_in 'message_body', with: "I'll take a dozen weekly. Are you in DFW area?"
    click_on 'Send'

    sleep 2
    visit_peer(1, 'messages')
    click_on "Farm fresh pogs"
    expect(page).to have_content("Is this still available?")
    expect(page).to have_content("Yes.")
    expect(page).to have_content("I'll take a dozen weekly. Are you in DFW area?")
    fill_in 'message_body', with: 'Yes, have dropoff at south end of IKEA parking lot in Grand Prairie every Tuesday at 1pm.'
    click_on 'Send'
    sleep 2
    visit_peer(4, 'messages')
    click_on 'Farm fresh pogs'
    expect(page).to have_content('Yes, have dropoff at south end')
  end

  def test_blinded_message
    visit_peer(3, 'marketplace')
    click_on 'Raw milk'
    click_on 'Message'

    fill_in 'Body', with: 'Is this still available?'
    click_on 'Send'

    sleep 2

    visit_peer(1, 'messages')
    click_on "Raw milk"
    expect(page).to have_content("Is this still available?")
    fill_in 'message_body', with: 'Yes.'
    click_on 'Send'

    sleep 2
    visit_peer(3, 'messages')
    click_on 'Raw milk'
    expect(page).to have_content('Yes.')
    fill_in 'message_body', with: "I'll take a milk share. Are you in DFW area?"
    click_on 'Send'

    sleep 2
    visit_peer(1, 'messages')
    click_on "Raw milk"
    expect(page).to have_content("Is this still available?")
    expect(page).to have_content("Yes.")
    expect(page).to have_content("I'll take a milk share. Are you in DFW area?")
    fill_in 'message_body', with: 'Yes, have dropoff at south end of IKEA parking lot in Grand Prairie every Tuesday at 1pm.'
    click_on 'Send'

    sleep 2
    visit_peer(3, 'messages')
    click_on 'Raw milk'
    expect(page).to have_content('Yes, have dropoff at south end')
  end
end
