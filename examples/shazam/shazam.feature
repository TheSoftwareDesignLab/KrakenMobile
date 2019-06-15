Feature: Example feature

  @user2
  Scenario: As a valid user I can log into my app
    Given I wait for a signal containing "ready_to_play" for 60 seconds
    Then I click on screen 50% from the left and 50% from the top
    Then I send a signal to user 1 containing "start_playing"
    Then I wait for "<SONG>" to appear
    Then I see the text "<SONG>"
    Then I see the text "<BAND_NAME>"
    Then I send a signal to user 1 containing "stop_playing"

  @user1
  Scenario: As a valid user I can log into my app
    Given I wait
    Then I press view with id "button_login"
    Then I press view with id "username_text"
    Then I enter email "<EMAIL>"
    Then I hide my keyboard
    Then I press view with id "password_text"
    Then I enter password "<PASSWORD>"
    Then I hide my keyboard
    Then I press view with id "login_button"
    Then I press view with id "search_tab"
    Then I press view with id "find_search_field"
    Then I press view with id "query"
    Then I enter song name "<SONG>"
    Then I hide my keyboard
    Then I wait for "<SONG>" to appear
    Then I send a signal to user 2 containing "ready_to_play"
    Then I wait for a signal containing "start_playing" for 30 seconds
    Then I press view with id "text1"
    Then I wait for a signal containing "stop_playing" for 30 seconds
    Then I press view with id "playPause"
