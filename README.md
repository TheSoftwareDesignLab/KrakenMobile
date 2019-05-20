# KrakenMobile

Kraken is an open source automated android E2E testing tool that supports and validates scenarios that involve the inter-communication between two or more users. It works in a Black Box manner meaning that it’s not required to have access to the source code of the application but instead it can be run with the APK (Android package file format). Kraken uses signaling for coordinating the communication between the devices using a file based protocol.

## Technologies

Kraken uses [calabash-android](https://github.com/calabash/calabash-android) for running automated E2E tests in each device or emulator and [cucumber](https://github.com/cucumber/cucumber-ruby) for running your feature files written with Gherkin sintax. 

**Requires Ruby ~ 2.3**

## Installation

Installing and managing a Gem is done through the gem command. To Kraken's gem run the following command

    $ gem install kraken-mobile


## Signaling

Signaling is a protocol used for the communication of two or more devices running in parallel. It’s based in the idea that each emulator or real device has a communication channel where he can receive signals sent from other devices which contain information or actions that are supposed to be executed. This type of protocol is commonly used in automated mobile E2E testing tools that validate scenarios involving the inter-communication and collaboration of two or more applications.

## Writing your first test

## Running your tests

## Kraken Settings

## Properties file
