Feature: Example feature

  @user2
  Scenario: As a first user I say hi to a second user
    Given I wait
    Then I press view with id "multibtn"
    Then I press "Connect devices"
    Then I wait
    Then I touch the "OnePlus2" text
    Then I wait
    Then I wait
    Then I press "Screen + controller (Server)"
    Then I click on screen 50% from the left and 98% from the top
    Then I press view with id "singlestart"
    Then I wait
    Then I send a signal to user 1 containing "start"
    Then I start a monkey with 1000 events
    Then I wait for a signal containing "user1_first_round" for 120 seconds
    Then I send a signal to user 1 containing "start_second_round"
    Then I start a monkey with 1000 events


  @user1
  Scenario: As a second user I wait for user 1 to say hi
    Given I wait
    Then I press view with id "multibtn"
    Then I wait for a signal containing "start" for 120 seconds
    Then I start a monkey with 1000 events
    Then I send a signal to user 2 containing "user1_first_round"
    Then I wait for a signal containing "start_second_round" for 120 seconds
    Then I start a monkey with 1000 events
