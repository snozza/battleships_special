Given(/^I am on the homepage$/) do
  visit '/'
end

Given(/^"(.*?)" is waiting$/) do |name|
  visit '/begin'
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

When(/^I choose "(.*?)"$/) do |direction|
  ("choose radio_direction")
end

Given(/^"(.*?)" has registered$/) do |player|
  register("player")
end

When(/^I register with name "(.*?)"$/) do |name|
  register(name)
end

Given(/^I am on the place ships page$/) do
  register("Andrew")
  register("Michael")
  visit '/deploy'
end

Given(/^I am waiting on the place ships page$/) do
  register("Andrew")
  register("Michael")
end

Given(/^I place all of my ships$/) do
  place_a_ship("H1", "D")
  place_all_ships
end

Given(/^"(.*?)" is on the deploy wait page$/) do |name|
  visit '/deploy_wait'
end

When(/^I place my ships$/) do
  visit '/deploy'
  place_a_ship("H1", "D")
  place_a_ship("A1", "D")
  place_a_ship("E1", "D")
  place_a_ship("F1", "D")
  place_a_ship("G1", "D")
end

Given(/^both players are registered$/) do
  Capybara.session_name = "Andrew"
  register("Andrew")
  Capybara.session_name = "Michael"
  register("Michael")
end

When(/^"(.*?)" places all of his ships$/) do |name|
  place_all_ships
end

Given(/^I am on the shoot page$/) do
  visit '/start_shooting/Andrew'
end

When(/^I sink all of my opponent's ships$/) do
  sink_all
end

When(/^I am in "(.*?)"'s browser$/) do |name|
  Capybara.session_name = name
end

def shoot(coord)
  fill_in("coordinate", :with => coord)
  click_on("Fire Away!")
end

def place_a_ship(coord, direct)
  fill_in("coordinate", :with => coord)
  choose(direct)
  click_on "Submit!"
end

def register(player)
  visit '/'
  click_on("Begin")
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

def sink_all
  coords = %w(h1, h2, a1, a2, a3, a4, e1, e2, e3, f1, f2, f3, f4, f5, g1, g2, g3)
  coords.each do |coord|
    visit '/start_shooting'
    shoot(coord)
  end
end




