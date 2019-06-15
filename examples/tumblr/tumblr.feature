Feature: Example feature

  @user2
  Scenario: As a first user I say hi to a second user
    Given I touch the "Log in" text
    Then I press view with id "email"
    Then I clear input field with id "email"
    Then I enter email "<EMAIL>"
    Then I hide my keyboard
    Then I press view with id "primary_button"
    Then I press view with id "use_password_button"
    Then I press view with id "password"
    Then I enter password "<PASSWORD>"
    Then I hide my keyboard
    Then I press view with id "action_button"
    Then I press view with id "topnav_account_button_img_active"
    Then I press view with id "composer_fab"
    Then I press view with id "compose_post_text"
    Then I wait
    Then I press view with id "text"
    Then I wait
    Then I enter text "My title"
    Then I click on screen 50% from the left and 50% from the top
    Then I enter text "My text"
    Then I press view with id "action_button"
    Then I send a signal to user 1 containing "created_post"

  @user1
  Scenario: As a second user I wait for user 1 to say hi
    Given I touch the "Get started" text
    Then I press view with id "age"
    Then I enter text "22"
    Then I hide my keyboard
    Then I press view with id "next_button"
    Then I press view with id "next"
    Then I wait for a signal containing "created_post" for 120 seconds
    Then I press view with id "topnav_explore_button_img_active"
    Then I touch the "Search" text
    Then I enter text "testKraken"
    Then I press view with id "list_item_blog_name"
    Then I see the text "My title"
    Then I see the text "My text"
