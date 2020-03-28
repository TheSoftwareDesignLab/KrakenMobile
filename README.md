<p align="center">
    <img src="./reporter/assets/images/kraken.png" alt="kraken logo" width="140" height="193">


<h1 align="center">Kraken Mobile</h1>

Kraken is an open source automated android E2E testing tool that supports and validates scenarios that involve the inter-communication between two or more users. It works in a Black Box manner meaning that it is not required to have access to the source code of the application but instead it can be run with the APK (Android package file format). Kraken uses signaling for coordinating the communication between the devices using a file based protocol.

**Kraken is partially supported by a Google Latin America Research Award (LARA) 2018**

# Video
[![krakenThumbnail](./reporter/assets/images/krakenThumbnail.jpg)](https://www.youtube.com/watch?v=hv5gFIpW3gM&list=PLF5U8kfVgRcJ3RCHt7cWmwlqN93brbVW-&index=1)

# Publications

- _"Kraken-Mobile: Cross-Device Interaction-based Testing of Android Apps"_, [William Ravelo-Méndez](https://ravelinx22.github.io/), [Camilo Escobar-Velásquez](https://caev03.github.io), and  [Mario Linares-Vásquez](https://profesores.virtual.uniandes.edu.co/mlinaresv/en/inicio-en/), _Proceedings of the 35th IEEE International Conference  on Software Maintenance and Evolution ([ICSME'19](https://icsme2019.github.io/))_, Tool Demo Track, Cleveland, OH, USA, September 30th - October 4th, 2019, to appear 4 pages (52% Acceptance Rate) [[pdf](https://thesoftwaredesignlab.github.io/KrakenMobile/assets/pdfs/icsme19.pdf)][[bibtex](https://thesoftwaredesignlab.github.io/KrakenMobile/assets/pdfs/icsme19.bib)]

# Technologies

Kraken uses [calabash-android](https://github.com/calabash/calabash-android) for running automated E2E tests in each device or emulator and [cucumber](https://github.com/cucumber/cucumber-ruby) for running your feature files written with Gherkin sintax.


# Installation

### Prerequisites

Kraken requires Ruby 2.20 or higher but we recommend using ~2.3 version. We use calabash-android as runner, you can check their prerequisites at this [link](https://github.com/calabash/calabash-android/blob/master/documentation/installation.md). Installing and managing a Gem is done through the gem command. To install Kraken's gem run the following command.

```shell
$ gem install kraken-mobile
```

# Signaling

Signaling is a protocol used for the communication of two or more devices running in parallel. It is based in the idea that each emulator or real device has a communication channel where he can receive signals sent from other devices which contain information or actions that are supposed to be executed. This type of protocol is commonly used in automated mobile E2E testing tools that validate scenarios involving the inter-communication and collaboration of two or more applications.

# Writing your first test

### Generate cucumber feature skeleton

First you need to generate the cucumber feature skeleton where your tests are going to be saved. To achieve this you should run `kraken-mobile gen`. It will create the skeleton in your current folder like this:

```
features
|_support
| |_app_installation_hooks.rb
| |_app_life_cycle_hooks.rb
| |_env.rb
|_step_definitions
| |_kraken_steps.rb
|_my_first.feature
```

### Write a test

The features goes in the features foler and should have the ".feature" extension. You can start out by looking at `features/my_first.feature`. You should also check calabash [predefined steps](https://github.com/calabash/calabash-android/blob/master/ruby-gem/lib/calabash-android/canned_steps.md).

### Syntax

In Kraken each feature is a test and each scenario within a feature is a test case that is run in a device. Each device is identified as an user and numbered from 1 to N. Ex: @user1, @user2, @user3. To check what is the number of a given device you should run `kraken-mobile devices`.

```shell
List of devices attached
user1 - emulator-5554 - Android_SDK_built_for_x86
user2 - emulator-5556 - Android_SDK_built_for_x86
```

After identifying what number each device has, you can write your test case giving each scenario the tag of a given device like so:

```Gherkin
Feature: Example feature
  
  @user1
  Scenario: As a first user I say hi to a second  user
  Given I wait
  Then I send a signal to user 2 containing "hi"

  @user2
  Scenario: As a second user I wait for user 1  to say hi
  Given I wait for a signal containing "hi"
  Then I wait
```

# Kraken steps

Kraken offers two main steps to help synchronizing your devices.

### Signaling steps

To wait for a signal coming from another device for 10 seconds that is Kraken default timeout use the following step.
```
Then /^I wait for a signal containing "([^\"]*)"$/
```
To wait for a signal coming from another device for an specified number of seconds use the following step

```
Then /^I wait for a signal containing "(  [^\"]*)" for (\d+) seconds$/
```

To send a signal to another specified device use the following step

```
Then /^I send a signal to user (\d+) containing "([^\"]*)"$/
```

### Signaling functions

Kraken internal implementation of the signaling steps use the following functions.

```ruby
readSignal(channel, content, timeout)
```

Waits for a signal with the specified content in the channel passed by parameter. This functions waits for the specified number of seconds in the timeout parameter before throwing an exception.

 **Note: The channel parameter has to be the number of a device such as @user1, @user2, @userN**

```ruby
writeSignal(channel, content)
```

Writes content to a channel passed by parameter.

**Note: The channel parameter has to be the number of a device such as @user1, @user2, @userN**

# Running your tests

To run your test:

```shell
$ kraken-mobile run <apk>
```

Kraken with the help of Calabash-Android will install an instrumentation along with your app and will start your tests in all devices connected (Check Kraken Settings section in order to learn how to specify in what devices your tests should be run).

# Kraken Settings

Kraken uses kraken_mobile_settings.json to specify in what devices the tests should be run.

### Generate settings file

The following command will show you the available connected devices or emulators and let you choose which ones you want to use.

```shell
$ kraken-mobile setup
```

### Run tests with settings file

``` shell
$ kraken-mobile run <apk> --configuration=<kraken_mobile_settings_path>
```

# Properties file

Kraken uses properties files to store sensitive data such as passwords or api keys that should be used in your test cases.

### Generate properties file

The properties files should be a manually created JSON file with the following structure.

```json
{
  "@user1": {
    "PASSWORD": "test"
  },
  "@user2": {
    "PASSWORD": "test2"
  }
}
```
    
### Use properties file in your test

You can use the specified properties using the following sintax.

```Gherkin
@user1
Scenario: As a user
    Given I wait
    Then I see the text "<PASSWORD>"
```

### Run tests with settings file

```
kraken-mobile run <apk> --properties=<kraken_mobile_properties_path>
```

# Use fake strings in tests

Kraken offers a Fake string generator thanks to the Ruby gem [Faker](https://github.com/faker-ruby/faker), the list of supported faker types are listed as follows:

* Name
* Number
* Email
* String
* String Date

### Use a faker in a test

Kraken keeps a record of every Fake string generated, thats why each string will have an id associated. To generate a Faker string you need to follow the structure "$FAKERNAME_ID".

```Gherkin
@user1
Scenario: As a user
    Given I wait
    Then I enter text "$name_1" into field with id "view"
```

### Reusing a fake string

As mentioned before, Kraken keeps record of every string generated with an id given to each string, this gives you the possibility of reusing this string later in your scenario. To reuse a string you can you need to append a $ character to the fake string as follows:

```Gherkin
@user1
Scenario: As a user
    Given I wait
    Then I enter text "$name_1" into field with id "view"
    Then I press "add_button"
    Then I should see "$$name_1"
```

# Examples


| Application  | Video | Feature File | Steps Definition | Properties file | Settings File | Report Link |
|:-------------|:-------------|:-------------|:------------------|:-------|:-------|:-------|
| Infinite Words | [video](https://www.youtube.com/watch?v=4lX7mO80w-4&list=PLF5U8kfVgRcJ3RCHt7cWmwlqN93brbVW-&index=3&t=0s)|[.feature](/examples/infinite-words/infinite_words.feature)|--- | ---  | ---  | [report](/examples/infinite-words/report/index.html) |
| QuizUp | [video](https://www.youtube.com/watch?v=2mhZVTK0r6k&list=PLF5U8kfVgRcJ3RCHt7cWmwlqN93brbVW-&index=4&t=1s) | [.feature](/examples/quizup/quizup.feature)|[stepsDef](../gh-pages/examples/quizup/step_definitions/kraken_steps.rb) | --- |  --- | [report](/examples/quizup/report/index.html)  |
| Spotify/Shazam | [video](https://www.youtube.com/watch?v=7AKsfY1KFX0&list=PLF5U8kfVgRcJ3RCHt7cWmwlqN93brbVW-&index=5&t=0s) | [.feature](/examples/shazam/shazam.feature)|[stepsDef](../gh-pages/examples/shazam/step_definitions/kraken_steps.rb) | [.json](/examples/shazam/kraken_properties.json) |  [.json](/examples/shazam/kraken_mobile_settings.json) | [report](/examples/shazam/report/index.html)  |
| Spunky | [video](https://www.youtube.com/watch?v=WOhRWkdFaVk&list=PLF5U8kfVgRcJ3RCHt7cWmwlqN93brbVW-&index=6&t=25s) | [.feature](/examples/spunky/spunky.feature)|[stepsDef](../gh-pages/examples/spunky/step_definitions/kraken_steps.rb) | --- |  --- | [report](/examples/spunky/report/index.html)  |
| Picap | [video](https://www.youtube.com/watch?v=RozQrmH_Z5k&list=PLF5U8kfVgRcJ3RCHt7cWmwlqN93brbVW-&index=7&t=3s) | [.feature](/examples/picap/picap.feature)|[stepsDef](../gh-pages/examples/picap/step_definitions/kraken_steps.rb) | [.json](/examples/picap/kraken_properties.json) |  --- | [report](/examples/picap/report/index.html)  |
| AskFM | [video](https://www.youtube.com/watch?v=d9Gbdx8kFX8&list=PLF5U8kfVgRcJ3RCHt7cWmwlqN93brbVW-&index=8&t=0s) | [.feature](/examples/askfm/askfm.feature)|[stepsDef](../gh-pages/examples/askfm/step_definitions/kraken_steps.rb) | --- |  --- | [report](/examples/askfm/report/index.html)  |
| Stick Men Fight | [video](https://www.youtube.com/watch?v=36OJKNj0nSo&list=PLF5U8kfVgRcJ3RCHt7cWmwlqN93brbVW-&index=9&t=4s) | [.feature](/examples/stick/stick.feature)|--- | --- |  --- | [report](/examples/stick/report/index.html)  |
| Tic Tac Toe | [video](https://www.youtube.com/watch?v=F9pDJDYsL_w&list=PLF5U8kfVgRcJ3RCHt7cWmwlqN93brbVW-&index=10&t=2s) | [.feature](/examples/tictactoe/tictactoe.feature)|[stepsDef](../gh-pages/examples/tictactoe/step_definitions/kraken_steps.rb) | --- |  --- | [report](/examples/tictactoe/report/index.html)  |
| Tumblr | [video](https://www.youtube.com/watch?v=eqFej2uJz4k&list=PLF5U8kfVgRcJ3RCHt7cWmwlqN93brbVW-&index=11&t=3s) | [.feature](/examples/tumblr/tumblr.feature)|[stepsDef](../gh-pages/examples/tumblr/step_definitions/kraken_steps.rb) | [.json](/examples/tumblr/kraken_properties.json) |  --- | [report](/examples/tumblr/report/index.html)  |
| F3 | [video](https://www.youtube.com/watch?v=vESh6Jyp-so&list=PLF5U8kfVgRcJ3RCHt7cWmwlqN93brbVW-&index=12&t=0s) | [.feature](/examples/f3/f3.feature)|[stepsDef](../gh-pages/examples/f3/step_definitions/kraken_steps.rb) | [.json](/examples/f3/kraken_properties.json) |  --- | [report](/examples/f3/report/index.html)  |
