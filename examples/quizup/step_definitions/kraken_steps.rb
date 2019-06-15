require 'kraken-mobile/runners/calabash/android/kraken_steps'

Then "I enter email" do
  tap_when_element_exists("android.widget.EditText id:'edit_text' index:0")
  enter_text("<EMAIL>")
end

Then "I enter password" do
  tap_when_element_exists("android.widget.EditText id:'edit_text' index:1")
  enter_text("<PASSWORD>")
end

Then "I enter email 2" do
  tap_when_element_exists("android.widget.EditText id:'edit_text' index:0")
  enter_text("<EMAIL>")
end

Then "I enter password 2" do
  tap_when_element_exists("android.widget.EditText id:'edit_text' index:1")
  enter_text("<PASSWORD>")
end

Then "I answer a question" do
  tap_when_element_exists("* id:'btnButtonText'")
  sleep 5
end
