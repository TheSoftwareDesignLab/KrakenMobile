Feature: Example feature

  @user1
  Scenario: As a first user I say hi to a second user
    Given I wait for 10 seconds
    Then I click on screen 20% from the left and 40% from the top
    Then I click on screen 80% from the left and 70% from the top
    Then I click on screen 20% from the left and 30% from the top
    Then I start a monkey with 200 events from height 5% to 95% and width 23% to 78%
