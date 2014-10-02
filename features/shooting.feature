Feature: Shooting at each other
  In order to shoot at each other
  As a sniper
  I want to target the opponent's grid

  Scenario: All ships placed
    Given both players are registered
    When "Andrew" places all of his ships
    And I place my ships
    Then I should see "Waiting to shoot!"

  Scenario: Shooting
    Given I am on the waiting to shoot page
    When it is my turn
    And I fill in "coordinate" with "A1"
    And I click on "Fire Away!"
    Then I should see "You HIT your opponent's ship!!!"



