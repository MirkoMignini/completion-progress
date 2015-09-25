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
For every step define the name of the property to check, a value (in percentage or a custom value) and, optionally, a hint to explain the user how to complete the step.

```ruby
class User
    include CompletionProgress
    
    attr_accessor :name, :surname, :email, :age, :phones

    completion_progress :profile do
      step :name, 30
      step :surname, 30
      step :email, 20, {hint: {text: 'Please add your email', href: '/profile/edit'}}
      step :age, 10, {hint: {text: 'Please add your age', href: '/profile/edit'}}
      step :phones, 10, {hint: {text: 'Please add at least a phone number', href: '/profile/edit/phones'}}
    end
    
    ...
end
```

Now let's create an user object and set some parameters
```ruby
user = User.new

user.name = 'Mark'
user.surname = 'Smith'
user.email = 'mark.smith@email.com'
```

To check the completion progress simply check the value property of profile.
The completion progress is the sum of the value of every step which relative property is set, if it's a collection is required that contains at least one value.

```
user.profile.value #in this case the value is 80
user.profile.steps[:name].result #to check the result (true or false) of a single step
user.profile.hints #will contains a collection of hints for the failed steps
```

## License

MIT License. Copyright 2014 by Mirko Mignini (https://github.com/MirkoMignini)