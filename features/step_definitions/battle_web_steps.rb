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


def register(player)
  visit '/'
  click_link "game-start"
  fill_in("player", :with => player)
  click_on("Submit")
end