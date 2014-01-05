require 'minitest/autorun'
require_relative '../lib/completion-progress'

class CompletionProgressTest < Minitest::Test

  class User
    include CompletionProgress

    attr_accessor :name, :surname, :age, :phones, :options, :custom_value

    def initialize
      @phones = Array.new
      @options = Hash.new
    end

    completion_progress :profile1 do
      step :name, 40, {hint: {text: 'Test hint', href: '/profile/edit', options: {custom: 10}}}
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
      step :custom, 5 do
        @custom_value
      end
    end

    completion_progress :profile_percent do
      step :name, 10
      step :surname, 10
      step :age, 10
      step :phones, 10
      step :custom_value, 10
    end

  end

  def test_setup
    user = User.new
    refute_nil(user)
  end

  def test_add_method
    user = User.new
    refute_nil(user.profile1)
    refute_nil(user.profile2)
  end

  def test_steps
    user = User.new
    assert_equal(user.profile1.steps.count, 3)

    refute_nil(user.profile1.steps[:name])
    assert_equal(user.profile1.steps[:name].value, 40)

    refute_nil(user.profile1.steps[:surname])
    assert_equal(user.profile1.steps[:surname].value, 40)

    refute_nil(user.profile1.steps[:age])
    assert_equal(user.profile1.steps[:age].value, 20)
  end

  def test_results
    user = User.new
    assert_equal(user.profile1.steps.count, 3)

    assert_equal(user.profile1.steps[:name].result, false)
    assert_equal(user.profile1.steps[:surname].result, false)
    assert_equal(user.profile1.steps[:age].result, false)

    user.name = 'Mirko'
    assert_equal(user.profile1.steps[:name].result, true)
    assert_equal(user.profile1.steps[:surname].result, false)
    assert_equal(user.profile1.steps[:age].result, false)

    user.surname = 'Mignini'
    assert_equal(user.profile1.steps[:name].result, true)
    assert_equal(user.profile1.steps[:surname].result, true)
    assert_equal(user.profile1.steps[:age].result, false)

    user.age = 33
    assert_equal(user.profile1.steps[:name].result, true)
    assert_equal(user.profile1.steps[:surname].result, true)
    assert_equal(user.profile1.steps[:age].result, true)
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

    user.custom_value = true
    assert_equal(user.profile_steps.value, 20)
  end

  def test_hints
    user = User.new
    refute_nil(user.profile1.hints)
    assert_equal(user.profile1.hints.count, 3)

    assert_equal(user.profile1.hints[:name].text, 'Test hint')
    assert_equal(user.profile1.hints[:name].href, '/profile/edit')
    assert_equal(user.profile1.hints[:name].options[:custom], 10)

    assert_equal(user.profile1.hints[:surname].text, 'Fill surname')
    assert_equal(user.profile1.hints[:surname].href, '')
    assert_equal(user.profile1.hints[:surname].options.count, 0)

    user.name = 'Mirko'
    assert_equal(user.profile1.hints.count, 2)

    user.surname = 'Mignini'
    assert_equal(user.profile1.hints.count, 1)

    user.age = 33
    assert_equal(user.profile1.hints.count, 0)
  end

  def test_percent
    user = User.new
    assert_equal(user.profile_percent.percent, 0)
    user.name = 'Mirko'
    assert_equal(user.profile_percent.percent, 20)
    user.surname = 'Mignini'
    assert_equal(user.profile_percent.percent, 40)
    user.age = 33
    assert_equal(user.profile_percent.percent, 60)
    user.phones = '0911234567'
    assert_equal(user.profile_percent.percent, 80)
    user.custom_value = 'test'
    assert_equal(user.profile_percent.percent, 100)
  end

  def test_partials
    user = User.new
    assert_equal(user.partial_profile.steps.count, 2)
  end

end