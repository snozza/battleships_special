Given(/^I am on the homepage$/) do
  visit '/'
end

When(/^I click on "(.*?)"$/) do |button|
  click_on(button)
end

Then(/^I should see "(.*?)"$/) do |text|
  page.should have_content(text)
end

When(/^I fill in "(.*?)" with "(.*?)"$/) do |field, value|
  fill_in(field, :with => value)
end

When(/^I click "(.*?)"$/) do |button|
  click_on(button)
end

Given(/^"(.*?)" has registered$/) do |player|
  visit '/' 
end

When(/^I register with name "(.*?)"$/) do |name|
  register(name)
end

Given(/^I am on the place ships page$/) do
  register("Andrew")
  register("Michael")
  visit '/deploy/Michael'
  
end

Given(/^I place all of my ships$/) do
  visit '/deploy/Andrew'
  place_a_ship("H1", "D")
  place_all_ships
end

Given(/^"(.*?)" is on the deploy wait page$/) do |name|
  visit '/deploy_wait'
end

When(/^I place my ships$/) do
  visit '/deploy/Michael'
  place_a_ship("H1", "D")
  place_a_ship("A1", "D")
  place_a_ship("E1", "D")
  place_a_ship("F1", "D")
  place_a_ship("G1", "D")
end

Given(/^both players are registered$/) do
  register("Andrew")
  register("Michael")
end

When(/^"(.*?)" places all of his ships$/) do |name|
  visit "/deploy/#{name}"
  place_all_ships
end

Given(/^I am on the shoot page$/) do
  visit '/start_shooting/Andrew'
end

def place_a_ship(coord, direct)
  fill_in("coordinate", :with => coord)
  fill_in("direction", :with => direct)
  click_on "Submit!"
end

def register(player)
  visit '/'
  click_link "game-start"
  fill_in("player", :with => player)
  click_on("Submit")
end

def place_all_ships
  place_a_ship("H1", "D")
  place_a_ship("A1", "D")
  place_a_ship("E1", "D")
  place_a_ship("F1", "D")
  place_a_ship("G1", "D")
end

