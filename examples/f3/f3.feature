Feature: Example feature

  @user1
  Scenario: As a first user I say hi to a second user
    Given I press view with id "btn_login"
    Then I touch the "Email" text
    Then I press view with id "edit_email"
    Then I enter text "<EMAIL>"
    Then I hide my keyboard
    Then I press view with id "edit_password"
    Then I enter text "<PASSWORD>"
    Then I hide my keyboard
    Then I press view with id "btn_fab_login"
    Then I wait
    Then I press view with id "tab_search_beacon"
    Then I press view with id "search_option"
    Then I enter text "testKraken2"
    Then I press view with id "text_username"
    Then I press view with id "btn_ask"
    Then I enter text "My question"
    Then I hide my keyboard
    Then I press view with id "btn_ask_question"
    Then I send a signal to user 2 containing "created_question"

  @user2
  Scenario: As a second user I wait for user 1 to say hi
    Given I press view with id "btn_login"
    Then I touch the "Email" text
    Then I press view with id "edit_email"
    Then I enter text "<EMAIL>"
    Then I hide my keyboard
    Then I press view with id "edit_password"
    Then I enter text "<PASSWORD>"
    Then I hide my keyboard
    Then I press view with id "btn_fab_login"
    Then I wait for a signal containing "created_question" for 120 seconds
    Then I press view with id "tab_inbox"
    Then I see the text "My question"
