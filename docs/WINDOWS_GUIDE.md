# Kraken Mobile on Windows

## Prerequisites

- Ruby at least version 2.3.1
- Java JDK
- Android SDK
- Git Bash (Run as administrator)
- Chromedriver (Version ~83 recommended) or Geckodriver (Only if you use Kraken web)

You need to have configured ANDROID_HOME, ANDROID_HOME/platform_tools and JAVA_HOME in your environment variables in order to use ADB and JAVA.

## Installation

We recommend to use Bundler to manage your dependencies including kraken-mobile and calabash-android. To install Kraken follow these steps:

1. Install bundler

    ```bash
    gem install bundler
    ```

2. Create directory where all test files are going to be saved

    ```bash
    mkdir test && cd ./test
    ```

3. Inside your new directory create Gemfile where all your gems are going to be specified

    ```bash
    bundle init
    ```

4. Change Gemfile content to have the required dependencies

    ```bash
    # Contents of Gemfile
    source "https://rubygems.org"

    gem 'rubyzip', '1.2.1' # Required version for running calabas-android in Windows
    gem 'kraken-mobile'
    ```

    Windows has an issue with the latest rubyzip versions not letting sign your APK's. Look at calabash-android issue [#802](https://github.com/calabash/calabash-android/issues/802)

5. Install dependencies

    ```bash
    bundle install
    ```

6. Generate Kraken skeleton directory

    ```bash
    bundle exec kraken-mobile gen
    ```

7. Resign your APK

    ```bash
    bundle exec kraken-mobile resign <my_apk_path>
    ```

8. Run Kraken

    ```bash
    bundle exec kraken-mobile run <my_apk_path>
    ```

## Troubleshooting

### No signature files found in META-INF

If when running Kraken or resigning your application you see this error, then you need to make sure:

1. You have signed your APK with the following command.

    ```bash
    bundle exec kraken-mobile resign <my_apk_path>
    ```

2. You have your keystore configured.

    To configure your keystore calabash-android provides a nice guide to generate and configure your keystore path and calabash settings. To achieve this you will need to install calabash-android directly with the following command.

    ```bash
    gem install calabash-android
    ```

    Once calabash-android is installed follow this [guide.](https://github.com/calabash/calabash-android/wiki/Running-Calabash-Android)
