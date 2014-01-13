[![Build Status](https://travis-ci.org/MirkoMignini/completion-progress.png?branch=master)](https://travis-ci.org/MirkoMignini/completion-progress)

completion-progress
===================

DSL for defining objects completion level (score and percentage), like LinkedIn or Facebook, but works with every object!

## Requirements

* Ruby 1.9+

## Installation

Add it to your Gemfile:

`gem 'completion-progress'`

Then:

`bundle`

## Usage

TODO

```ruby
class User
    include CompletionProgress

    ...

    completion_progress :profile1 do
      step :name, 30
      step :surname, 30
      step :email, 20
      step :age, 10, {hint: {text: 'Please add your age', href: '/profile/edit'}}
      step :phones, 10, {hint: {text: 'Please add at least a phone number', href: '/profile/edit/phones'}}
    end

    ...
end
```

## License

MIT License. Copyright 2014 Mirko Mignini (https://github.com/MirkoMignini)