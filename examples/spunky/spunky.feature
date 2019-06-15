Feature: Example feature

@user1
Scenario: As a valid user I can log into my app
  Given I wait
  Then I press "Jugar"
  Then I toggle checkbox number 2
  Then I press view with id "RAmigos"
  Then I press "Siguiente"
  Then I drag from 90:10 to 10:10 moving with 1 steps
  Then I press "Jugar trivia"
  Then I wait for the view with id "textViewCodigo" to appear
  Then I send a signal to user 2 containing the game code
  Then I wait for a signal containing "user2_ok" for 30 seconds
  Then I press "Empezar"
  Then I send a signal to user 2 containing "start"
  Then I press view with id "BPreguntaA"
  Then I press view with id "snackbar_action"
  Then I press view with id "BPreguntaA"
  Then I press view with id "snackbar_action"
  Then I press view with id "BPreguntaA"
  Then I press view with id "snackbar_action"
  Then I press view with id "BPreguntaA"
  Then I press view with id "snackbar_action"
  Then I press view with id "BPreguntaA"
  Then I press view with id "snackbar_action"
  Then I press view with id "BPreguntaA"
  Then I press view with id "snackbar_action"
  Then I press view with id "BPreguntaA"
  Then I press view with id "snackbar_action"
  Then I press view with id "BPreguntaA"
  Then I press view with id "snackbar_action"
  Then I press view with id "BPreguntaA"
  Then I press view with id "snackbar_action"
  Then I press view with id "BPreguntaA"
  Then I press view with id "snackbar_action"
  Then I press view with id "BPreguntaA"
  Then I press view with id "snackbar_action"
  Then I press view with id "BPreguntaA"
  Then I press view with id "snackbar_action"
  Then I press view with id "BPreguntaA"
  Then I press view with id "snackbar_action"
  Then I press view with id "BPreguntaA"
  Then I press view with id "snackbar_action"
  Then I send a signal to user 2 containing "finished"
  Then I wait for a signal containing "user2_fin" for 60 seconds
  Then I see the text "user2"

@user2
Scenario: As a valid user I can log into my app
  Given I wait
  Then I press "Unirse"
  Then I press view with id "button1"
  Then I press view with id "editTextApodo"
  Then I enter username "user2"
  Then I hide my keyboard
  Then I press view with id "editTextUnirse"
  Then I wait for game code and enter it
  Then I hide my keyboard
  Then I press "Unirme"
  Then I send a signal to user 1 containing "user2_ok"
  Then I wait for a signal containing "start" for 30 seconds
  Then I press view with id "BPreguntaA"
  Then I press view with id "snackbar_action"
  Then I press view with id "BPreguntaA"
  Then I press view with id "snackbar_action"
  Then I press view with id "BPreguntaA"
  Then I press view with id "snackbar_action"
  Then I press view with id "BPreguntaA"
  Then I press view with id "snackbar_action"
  Then I press view with id "BPreguntaA"
  Then I press view with id "snackbar_action"
  Then I press view with id "BPreguntaA"
  Then I press view with id "snackbar_action"
  Then I press view with id "BPreguntaA"
  Then I press view with id "snackbar_action"
  Then I press view with id "BPreguntaA"
  Then I press view with id "snackbar_action"
  Then I press view with id "BPreguntaA"
  Then I press view with id "snackbar_action"
  Then I press view with id "BPreguntaA"
  Then I press view with id "snackbar_action"
  Then I press view with id "BPreguntaA"
  Then I press view with id "snackbar_action"
  Then I press view with id "BPreguntaA"
  Then I press view with id "snackbar_action"
  Then I press view with id "BPreguntaA"
  Then I press view with id "snackbar_action"
  Then I press view with id "BPreguntaA"
  Then I press view with id "snackbar_action"
  Then I wait for a signal containing "finished" for 60 seconds
  Then I send a signal to user 1 containing "user2_fin"
