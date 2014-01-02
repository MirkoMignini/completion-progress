require 'test/unit'
require_relative '../lib/completion-progress'

class CompletionProgressTest < Test::Unit::TestCase

  class User
    include CompletionProgress

    attr_accessor :name, :surname, :age, :phones, :options

    def initialize
      @phones = Array.new
      @options = Hash.new
    end

    completion_progress :profile1 do
      step :name, 40
      step :surname, 40
      step :age, 20
    end

    completion_progress :profile2 do
      step :name, 20
      step :surname, 20
      step :age, 10
    end

    completion_progress :partial_profile do
      step :name, 40
    end

    completion_progress :partial_profile do
      step :surname, 40
    end

    completion_progress :profile_auto_update_false, auto_update: false do
      step :name, 40
    end

    completion_progress :profile_steps do
      step :name, 5
      step :phones, 5
      step :options, 5
    end

  end

  def test_setup
    user = User.new
    assert_not_nil(user)
  end

  def test_add_method
    user = User.new
    assert_not_nil(user.profile1)
    assert_not_nil(user.profile2)
  end

  def test_steps
    user = User.new
    assert_equal(user.profile1.steps.count, 3)

    assert_not_nil(user.profile1.steps[:name])
    assert_equal(user.profile1.steps[:name].value, 40)

    assert_equal(user.profile1.steps[:surname].value, 40)
    assert_not_nil(user.profile1.steps[:surname])

    assert_equal(user.profile1.steps[:age].value, 20)
    assert_not_nil(user.profile1.steps[:age])
  end

  def test_values
    user = User.new
    assert_equal(user.profile1.value, 0)

    user.name = 'Mirko'
    assert_equal(user.profile1.value, 40)
    user.surname = 'Mignini'
    assert_equal(user.profile1.value, 80)
    user.age = 33
    assert_equal(user.profile1.value, 100)
  end

  def test_multi_object
    user = User.new
    user.name = 'Mirko'
    assert_equal(user.profile1.value, 40)
    assert_equal(user.profile2.value, 20)
  end

  def test_auto_update
    user = User.new
    assert_equal(user.profile_auto_update_false.value, 0)
    user.name = 'Mirko'
    assert_equal(user.profile_auto_update_false.value, 0)
    user.profile_auto_update_false.update
    assert_equal(user.profile_auto_update_false.value, 40)
  end

  def test_variable_types
    user = User.new
    assert_equal(user.profile_steps.value, 0)

    user.name = 'Mirko'
    assert_equal(user.profile_steps.value, 5)

    user.phones << '0911234567'
    assert_equal(user.profile_steps.value, 10)

    user.options['test'] = 'hello'
    assert_equal(user.profile_steps.value, 15)
  end

end