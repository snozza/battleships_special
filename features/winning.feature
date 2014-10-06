Feature: Winning a Game
  In order to win a game
  As a fierce terminator player
  I need to sink all of my opponent's ships

  Background: Setup of Ships
    Given both players are registered
    When I place my ships
    When I am in "Andrew"'s browser
    And I place my ships

  Scenario: Winning
    When I sink all of my opponent's ships
    Then I should see "Won"
    When I click on "reset"
    Then I should see "What's your name?"
