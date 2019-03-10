Feature: Login feature

  @user1
  Scenario: As a first user I can log into my app
    When I press "Login"
    Then I see "Welcome to coolest app ever"

  @user2
  Scenario: As a second user I can log into my app
    When I press "Login"
    Then I see "Welcome to coolest app ever"
