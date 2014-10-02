Feature: Placing Ships
  In order deploy
  As a well-eqipped player
  I want to place all of my ships

  Scenario:
    Given I am on the place ships page
    When I fill in "coordinate" with "C1"
    And I fill in "direction" with "R"
    And I click "Submit!"
    Then I should see "battleship"
