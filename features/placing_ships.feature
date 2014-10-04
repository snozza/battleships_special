Feature: Placing Ships
  In order deploy
  As a well-eqipped player
  I want to place all of my ships

  Scenario: Placing first ship
    Given I am on the place ships page
    When I fill in "coordinate" with "C1"
    And I choose "Right"
    And I click "Submit!"
    Then I should see "Patrolboat"

  Scenario: Placing all ships
    Given I am waiting on the place ships page
    And I place all of my ships
    Then I should see "Waiting for other weirdo to place ships"


