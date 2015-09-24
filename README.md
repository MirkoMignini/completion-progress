[![Build Status](https://travis-ci.org/MirkoMignini/completion-progress.png?branch=master)](https://travis-ci.org/MirkoMignini/completion-progress)

completion-progress
===================

DSL to calculate completion level (in percentage or score) of an object based on the value of its properties.

## Requirements

* Ruby 1.9+

## Installation

Add it to your Gemfile:

`gem 'completion-progress'`

Then:

`bundle`

## Usage

Use the completion-progress dsl to define the steps.
For every step define a name, a value (in percentage or a custom value) and, optionally, a hint to explain the user how to complete the step.

```ruby
class User
    include CompletionProgress

    completion_progress :profile do
      step :name, 30
      step :surname, 30
      step :email, 20
      step :age, 10, {hint: {text: 'Please add your age', href: '/profile/edit'}}
      step :phones, 10, {hint: {text: 'Please add at least a phone number', href: '/profile/edit/phones'}}
    end
    
    ...
end

user = User.new

#set the user properties to custom values

user.profile.value #will contains the sum of the values of all the steps which value is not null or empty
user.profile1.steps[:name].result #check the result (true or false) of a single step
```

## License

MIT License. Copyright 2014 by Mirko Mignini (https://github.com/MirkoMignini)