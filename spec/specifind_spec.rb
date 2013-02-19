require 'spec_helper'
require 'active_record'
require 'specifind'

class Person < ActiveRecord::Base
  attr_accessible :age, :birthday, :name, :male
  acts_as_findable
end

describe Person do
  before(:all) do

    ActiveRecord::Base.establish_connection(
       :adapter   => 'sqlite3',
       :database  => 'spec/spec.sqlite3'
    )

    ActiveRecord::Migration.class_eval do
      create_table :people do |t|
          t.integer  :age
          t.date :birthday
          t.string :name
          t.boolean :male
       end
    end

  end

  after(:all) do
    ActiveRecord::Migration.class_eval do
      drop_table :people
    end
  end

  describe "SpecifindSpec" do
    it "includes SpecifindWorkings through acts_as_findable" do
      Person.ancestors.select{|a| a.class == Module}.include?(Specifind::SpecifindWorkings).should eq(true)
    end
    it "works" do
      max = Person.create age: 23, name: 'max', birthday: Date.new(1989, 3, 6), male: true
      zach = Person.create age: 27, name: 'zach', birthday: Date.new(1985, 7, 4), male: true
      lisa = Person.create age: 58, name: 'lisa', birthday: Date.new(1955, 11, 3), male: false
      bill = Person.create age: 57, name: 'bill', birthday: Date.new(1956, 9, 5), male: true
      Person.find_by_age_equals(23).should eq([max])
      Person.find_by_birthday_between(Date.new(1980,1,1), Date.new(1990,1,1)).length.should eq(2)
      Person.find_by_name_like('%a%').length.should eq(3)
      Person.find_by_male(false)[0].id.should eq(lisa.id)
      Person.delete_all
    end
    it "verifies the type of objects passed in" do
      max = Person.create age: 23, name: 'max', birthday: Date.new(1989, 3, 6), male: true
      zach = Person.create age: 27, name: 'zach', birthday: Date.new(1985, 7, 4), male: true
      lisa = Person.create age: 58, name: 'lisa', birthday: Date.new(1955, 11, 3), male: false
      bill = Person.create age: 57, name: 'bill', birthday: Date.new(1956, 9, 5), male: true
      expect {Person.find_by_age_equals 'max'}.to raise_error
      expect {Person.find_by_birthday 'max'}.to raise_error
      expect {Person.find_by_name_like 16}.to raise_error
      Person.delete_all
    end
  end
end