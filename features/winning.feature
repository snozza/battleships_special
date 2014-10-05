Feature: Winning a Game
  In order to win a game
  As a fierce terminator player
  I need to sink all of my opponent's ships

  Background: Setup of Ships
    Given both players are registered
    When I place my ships
    And "Andrew" places all of his ships

  Scenario: Winning
    When I sink all of my opponent's ships
    Then I should see "Won"
