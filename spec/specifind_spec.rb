require 'spec_helper'
require 'active_record'

# ActiveRecord::Base.establish_connection(
#        :adapter   => 'sqlite3',
#        :database  => 'spec/spec.sqlite3'
#     )

require 'specifind'

class Person < ActiveRecord::Base
  attr_accessible :birthday, :name, :male
end

describe Person do
  before(:all) do

    ActiveRecord::Migration.class_eval do
      create_table :people do |t|
          t.integer  :age
          t.date :birthday
          t.string :name
          t.boolean :male
       end
    end

    Person.create :name => 'Erin', :birthday => Date.new(1981, 5, 16), :male => false
    Person.create :name => 'Aaron', :birthday => Date.new(1956, 8, 6), :male => true
    Person.create :name => 'Niki', :birthday => Date.new(1992, 3, 29), :male => false
    Person.create :name => 'Nick', :birthday => Date.new(1974, 11, 1), :male => true
    Person.create :name => 'Dani', :birthday => Date.new(1987, 4, 9), :male => false
    Person.create :name => 'Dan', :birthday => Date.new(2001, 1, 17), :male => true
    Person.create :name => 'xxyxx', :birthday => nil, :male => false

  end

  after :all do
    ActiveRecord::Migration.class_eval do
      drop_table :people
    end
  end

  describe "Specifind Model" do
    it "finds instances with in_list comparator" do
      Person.find_by_name_in_list(['Erin', 'Aaron', 'Niki']).length.should == 3
    end

    it "finds instances with less_than comparator" do
      list = Person.find_by_birthday_less_than(Date.new(1957,1,1))
      list[0].name.should == 'Aaron'
    end

    it "finds instances with less_than_equals comparator" do
      list = Person.find_by_birthday_less_than_equals(Date.new(1974, 11, 1))
      list.length.should == 2
    end

    it "finds instances with greater_than comparator" do
      list = Person.find_by_birthday_greater_than(Date.new(1992,3,29))
      list[0].name.should == 'Dan'
    end

    it "finds instances with greater_than_equals comparator" do
      list = Person.find_by_birthday_greater_than_equals(Date.new(1992,3,29))
      list.length.should == 2
    end

    it "finds instances with like comparator" do
      list = Person.find_by_name_like '%n%'
      if ActiveRecord::Base.connection.class.name == "ActiveRecord::ConnectionAdapters::SQLite3Adapter"
        list.length.should == 6 # sqlite3 uses case insensitive for like. no magic way to make case sensitive
      else
        list.length.should == 4 # Erin, Aaron, Dani, Dan
      end
    end

    it "finds instances with ilike comparator" do
      list = Person.find_by_name_ilike '%N%'
      list.length.should == 6 # Erin, Aaron, Niki, Nick, Dani, Dan
    end

    it "finds instances with not_equal comparator" do
      list = Person.find_by_name_not_equal 'Dan'
      list.length.should == 6
      list.each do |p|
        p.name.should_not == 'Dan'
      end
    end

    it "finds instances with between comparator" do
      list = Person.find_by_birthday_between Date.new(2000, 1, 1), Date.new(2002, 1, 1)
      list.length.should == 1
      list[0].name.should == 'Dan'
    end

    it "finds instances with is_not_null comparator" do
      list = Person.find_by_birthday_is_not_null
      list.length.should == 6
    end

    it "finds instances with is_null comparator" do
      list = Person.find_by_birthday_is_null
      list.length.should == 1
      list[0].name.should == 'xxyxx'
    end

    it "finds instances with equals comparator" do
      list = Person.find_by_male false
      list.length.should == 4
    end

    it "works" do
    end
    it "verifies the type of objects passed in" do
      expect {Person.find_by_age_equals 'max'}.to raise_error
      expect {Person.find_by_birthday 'max'}.to raise_error
      expect {Person.find_by_name_like 16}.to raise_error
    end
  end
end