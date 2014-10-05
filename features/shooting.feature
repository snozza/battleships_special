Feature: Shooting at each other
  In order to shoot at each other
  As a sniper
  I want to target the opponent's grid

  Background: Setup of Ships
    Given both players are registered
    When I place my ships
    And "Andrew" places all of his ships
    Then I should see "Let's Shoot!" 

  Scenario: Shooting and Hitting
    When I fill in "coordinate" with "A1"
    And I click on "Fire Away!"
    Then I should see "You HIT your opponent's ship!!!"

  Scenario: Shooting and Missing
    When I fill in "coordinate" with "J9"
    And I click on "Fire Away!"
    Then I should see "You Suck"


  



