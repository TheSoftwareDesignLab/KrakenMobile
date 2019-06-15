Feature: Example feature

  @user1
  Scenario: As a second user I wait for user 1 to say hi
    Given I wait
    Then I touch the "Login" text
    Then I press view with id "txt_email"
    Then I enter email "<EMAIL>"
    Then I press view with id "txt_password"
    Then I enter password "<PASSWORD>"
    Then I hide my keyboard
    Then I press view with id "btn_sign_in"
    Then I wait
    Then I press view with id "buttonMenu"
    Then I touch the "Change to driver" text
    Then I send a signal to user 2 containing "ready_to_receive"
    Then I wait for a signal containing "ordered_picap" for 60 seconds
    Then I touch the "ACEPTAR" text
    Then I wait for 5 seconds
    Then I drag from 10:99 to 90:99 moving with 20 steps
    Then I wait for 5 seconds
    Then I drag from 10:99 to 90:99 moving with 20 steps
    Then I travel
    Then I drag from 10:99 to 90:99 moving with 20 steps
    Then I see "Calificar"
    Then I send a signal to user 2 containing "finished"

  @user2
  Scenario: As a first user I say hi to a second user
    Given I wait
    Then I touch the "Login" text
    Then I press view with id "txt_email"
    Then I enter email "<EMAIL>"
    Then I press view with id "txt_password"
    Then I enter password "<PASSWORD>"
    Then I hide my keyboard
    Then I press view with id "btn_sign_in"
    Then I wait
    Then I touch the "Work" text
    Then I wait for 2 seconds
    Then I touch the "CONFIRM" text
    Then I wait for 2 seconds
    Then I touch the "MOTO" text
    Then I wait for a signal containing "ready_to_receive" for 60 seconds
    Then I touch the "ORDER" text
    Then I send a signal to user 1 containing "ordered_picap"
    Then I wait for a signal containing "finished" for 360 seconds
    Then I see "Total to charge"
