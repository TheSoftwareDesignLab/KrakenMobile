Feature: Example feature

  @user1
  Scenario: As a first user I say hi to a second user
    Given I wait
    Then I press view with id "button_BluetoothPlay"
    Then I press view with id "button_StartNewTable"
    Then I press view with id "enter_your_name_editText_btpreplay"
    Then I press view with id "button_pre_single_x_btpreplay"
    Then I enter user "Test1"
    Then I hide my keyboard
    Then I press view with id "button_start_playing_bluetooth"
    Then I wait
    Then I see the text "Test2"
    Then I press view with id "btnGrid11"
    Then I send a signal to user 2 containing "first_move"
    Then I wait for a signal containing "second_move" for 30 seconds
    Then I press view with id "btnGrid22"
    Then I send a signal to user 2 containing "third_move"
    Then I wait for a signal containing "fourth_move" for 30 seconds
    Then I press view with id "btnGrid33"
    Then I see the text "1"

  @user2
  Scenario: As a second user I wait for user 1 to say hi
    Given I wait
    Then I press view with id "button_BluetoothPlay"
    Then I press view with id "button_JoinTable"
    Then I press view with id "enter_your_name_editText_btpreplay_slave"
    Then I enter user "Test2"
    Then I hide my keyboard
    Then I press view with id "button_start_playing_bluetooth_slave"
    Then I touch the "OnePlus2" text
    Then I wait for a signal containing "first_move" for 30 seconds
    Then I press view with id "btnGrid21"
    Then I send a signal to user 1 containing "second_move"
    Then I wait for a signal containing "third_move" for 30 seconds
    Then I press view with id "btnGrid12"
    Then I send a signal to user 1 containing "fourth_move"
