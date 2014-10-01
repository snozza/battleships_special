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

Given(/^I am registered as "(.*?)"$/) do |name|
  register(name)
end

When(/^"(.*?)" registers$/) do |name|
  register(name)
end

When(/^I register with "(.*?)"$/) do |name|
  register(name)
end

def register(player)
  visit '/'
  click_link "game-start"
  fill_in("player", :with => player)
  click_on("Submit")
end