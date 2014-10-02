Feature: Starting a game
  In order to play battleships
  As a cool player
  I want to begin a new game

  Scenario: Registering first player
    Given I am on the homepage
    When I click on "Begin"
    Then I should see "What's your name?"

  Scenario: Registering first player
    Given I am on the homepage
    When I click on "Begin"
    When I fill in "player" with "Andrew"
    And I click "Submit"
    Then I should see "Waiting for other player"

  Scenario: Registering second player
    Given "Andrew" has registered
    When I register with name "Michael"
    Then I should see "Let's place your ships!!"

  
