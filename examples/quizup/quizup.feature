Feature: Example feature

  @user1
  Scenario: As a first user I say hi to a second user
    Given I wait
    Then I click on screen 0% from the left and 95% from the top
    Then I wait
    Then I touch the "Log In with Email" text
    Then I wait
    Then I enter email
    Then I enter password
    Then I press view with id "email_login_button"
    Then I send a signal to user 2 containing "finished_login_user1"
    Then I wait for a signal containing "finished_login_user2" for 60 seconds
    Then I wait for a signal containing "sended_invitation" for 60 seconds
    Then I touch the "ACCEPT" text
    Then I send a signal to user 2 containing "accepted_invitation"
    Then I answer a question
    Then I answer a question
    Then I answer a question
    Then I answer a question
    Then I answer a question
    Then I answer a question
    Then I answer a question
    Then I wait

  @user2
  Scenario: As a first user I say hi to a second user
    Given I wait
    Then I click on screen 0% from the left and 100% from the top
    Then I wait
    Then I touch the "Log In with Email" text
    Then I wait
    Then I enter email 2
    Then I enter password 2
    Then I press view with id "email_login_button"
    Then I wait for a signal containing "finished_login_user1" for 60 seconds
    Then I send a signal to user 1 containing "finished_login_user2"
    Then I wait for 4 seconds
    Then I touch the "Logos" text
    Then I wait
    Then I touch the "Play" text
    Then I touch the "Test" text
    Then I send a signal to user 1 containing "sended_invitation"
    Then I wait for a signal containing "accepted_invitation" for 60 seconds
    Then I answer a question
    Then I answer a question
    Then I answer a question
    Then I answer a question
    Then I answer a question
    Then I answer a question
    Then I answer a question
    Then I wait
