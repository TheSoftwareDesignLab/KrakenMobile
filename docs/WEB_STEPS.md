# Kraken web steps

In this section we will list all available web steps in Kraken web.

## Navigation

Navigate to a specific website.

```ruby
Then /^I navigate to page "([^\"]*)"$/
```

## Clicking

Click on a view with id.

```ruby
Then /^I click on element having id "(.*?)"$/
```

## Entering text

Enter text in a specific input with id.

```ruby
Then /^I enter "([^\"]*)" into input field having id "([^\"]*)"$/
```

Enter text on a input with CSS selector.

```ruby
Then /^I enter "([^\"]*)" into input field having css selector "([^\"]*)"$/
```

## Waiting

Wait for a specific amount of time.

```ruby
Then /^I wait for (\d+) seconds$/
```

## Assertion

Assert that in current web page a text is present and visible.

```ruby
Then /^I should see text "(.*?)"$/
```

## Kraken Signaling

Send a signal to another device containing a specific content.

```ruby
Then /^I send a signal to user (\d+) containing "([^\"]*)"$/
```

Wait for a signal coming from another device and containing specific content.

```ruby
Then /^I wait for a signal containing "([^\"]*)"$/
```

Wait for a signal coming from another device, containing specific content and for maximum amount of time.

```ruby
Then /^I wait for a signal containing "([^\"]*)" for (\d+) seconds$/
```

## Kraken Monkey

Start Kraken monkey and run a specific amount of random events on the GUI.

```ruby
Then /^I start a monkey with (\d+) events$/
```
