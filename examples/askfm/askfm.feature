Feature: Example feature

  @user1
  Scenario: As a first user I say hi to a second user
    Given I wait
    Then I touch the "Log in" text
    Then I press view with id "usernameInputLayout"
    Then I enter email "<EMAIL>"
    Then I press view with id "passwordInput"
    Then I enter password "<PASSWORD>"
    Then I hide my keyboard
    Then I press view with id "buttonActionLogin"
    Then I wait
    Then I wait for a signal containing "asked_question" for 60 seconds
    Then I press view with id "inboxTabIcon"
    Then I wait
    Then I click on screen 93% from the left and 7% from the top
    Then I wait
    Then I touch the "My question" text
    Then I wait
    Then I press view with id "editTextAnswerComposer"
    Then I enter answer "My answer"
    Then I press view with id "actionAnswer"
    Then I send a signal to user 2 containing "answered_question"

  @user2
  Scenario: As a second user I wait for user 1 to say hi
    Given I wait
    Then I touch the "Log in" text
    Then I press view with id "usernameInputLayout"
    Then I enter email "<EMAIL>"
    Then I press view with id "passwordInput"
    Then I enter password "<PASSWORD>"
    Then I hide my keyboard
    Then I press view with id "buttonActionLogin"
    Then I wait
    Then I press view with id "friendsTabContainer"
    Then I touch the "testKraken" text
    Then I wait
    Then I touch the "Ask me anything" text
    Then I touch the "Ask me anything" text
    Then I press view with id "editTextQuestionComposer"
    Then I press view with id "editTextQuestionComposer"
    Then I enter question "My question"
    Then I press view with id "actionQuestionAsk"
    Then I send a signal to user 1 containing "asked_question"
    Then I wait for a signal containing "answered_question" for 60 seconds
    Then I go back
    Then I press view with id "inboxTabIcon"
    Then I click on screen 93% from the left and 7% from the top
    Then I open answers tab
    Then I touch the "My question" text
    Then I should see "My answer"
