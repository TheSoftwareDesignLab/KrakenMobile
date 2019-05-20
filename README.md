# KrakenMobile

Kraken is an open source automated android E2E testing tool that supports and validates scenarios that involve the inter-communication between two or more users. It works in a Black Box manner meaning that it’s not required to have access to the source code of the application but instead it can be run with the APK (Android package file format). Kraken uses signaling for coordinating the communication between the devices using a file based protocol.

## Technologies

Kraken uses [calabash-android](https://github.com/calabash/calabash-android) for running automated E2E tests in each device or emulator and [cucumber](https://github.com/cucumber/cucumber-ruby) for running your feature files written with Gherkin sintax. 

## Installation

### Prerequisites

Kraken requires Ruby 2.20 or higher but we recommend using ~2.3 version. We use calabash-android as runner, you can check their prerequisites at this [link](https://github.com/calabash/calabash-android/blob/master/documentation/installation.md)


Installing and managing a Gem is done through the gem command. To install Kraken's gem run the following command

    $ gem install kraken-mobile


## Signaling

Signaling is a protocol used for the communication of two or more devices running in parallel. It’s based in the idea that each emulator or real device has a communication channel where he can receive signals sent from other devices which contain information or actions that are supposed to be executed. This type of protocol is commonly used in automated mobile E2E testing tools that validate scenarios involving the inter-communication and collaboration of two or more applications.

## Writing your first test

### Generate cucumber feature skeleton

First you need to generate the cucumber feature skeleton where your tests are going to be saved. To achieve this you should run `kraken-mobile gen`. It will create the skeleton in your current folder like this:

    features
    |_support
    | |_app_installation_hooks.rb
    | |_app_life_cycle_hooks.rb
    | |_env.rb
    |_step_definitions
    | |_kraken_steps.rb
    |_my_first.feature

### Write a test

The features goes in the features foler and should have the ".feature" extension.

You can start out by looking at features/my_first.feature. You should also check calabash [predefined steps](https://github.com/calabash/calabash-android/blob/master/ruby-gem/lib/calabash-android/canned_steps.md).

### Syntax

In Kraken each feature is a test and each scenario within a feature is a test case that is run in a device. Each device is identified as an user and numbered from 1 to N. Ex: @user1, @user2, @user3. To check what is the number of a given device you should run `kraken-mobile devices`

    List of devices attached
    user1 - emulator-5554 - Android_SDK_built_for_x86
    user2 - emulator-5556 - Android_SDK_built_for_x86

After identifying what number each device has, you can write your test case giving each scenario the tag of a given device like so:

    Feature: Example feature

      @user1
      Scenario: As a first user I say hi to a second user
        Given I wait
        Then I send a signal to user 2 containing "hi"

      @user2
      Scenario: As a second user I wait for user 1 to say hi
        Given I wait for a signal containing "hi"
        Then I wait

## Running your tests

To run your test:

    kraken-mobile run <apk>

Kraken with the help of Calabash-Android will install an instrumentation along with your app and will start your tests in all devices connected (Check Kraken Settings section in order to learn how to specify in what devices your tests should be run).

## Kraken Settings

## Properties file
