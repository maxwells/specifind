Specifind
=========

[![Code Climate](https://codeclimate.com/github/maxwells/specifind.png)](https://codeclimate.com/github/maxwells/specifind)
[![Build Status](https://travis-ci.org/maxwells/specifind.png?branch=master)](https://travis-ci.org/maxwells/specifind)

Specifind offers advanced ActiveRecord dynamic find\_by_* methods that include comparators (like the grails ORM). Coupled with some questionable SQL injection mitigation through strict verification of type and string escaping, your find methods will be much more readable. If an object of the wrong type (based on the type of the corresponding column of the db) is passed into a finder, it will raise an exception. Ruby 1.9.2 and above are supported

#### Installation

Include specifind in your Rails Gemfile

	gem 'specifind'
	
and

	$ bundle

#### Comparators
1. in\_list (list)
2. less\_than (value)
3. less\_than\_equals (value)
4. greater\_than (value)
5. greater\_than\_equals (value)
6. like (String) - as you'd enter it as SQL (eg. 'alpha%' for items starting with alpha)
7. ilike (String) - case insensitive like
8. not\_equal (value)
9. between (lower value, upper value)
10. is\_not\_null
11. is\_null
12. equals (value) - shorthand is to leave comparator blank (eg. find\_by\_name would mean find\_by\_name\_equals)

#### Usage

Here is an example person class:

    class Person < ActiveRecord::Base
      attr_accessible :age, :birthday, :name
    end

Specifind is automatically included in ActiveRecord once it is added to your Gemfile. Given the three attributes above, here are some examples of methods you could use to slice your data:

`Person.find_by_age_greater_than_and_birthday_between 15, DateTime.new(1985, 1, 1), DateTime.new(1987,3,6)`

`Person.find_by_name_like '%a%'`

`Person.find_by_name_is_not_null`

#### Notes
1. Currently, the ilike comparator only works with mysql (to the best of my knowledge)
2. Unlike built in ActiveRecord methods, Specifind methods will always return a list, even if it only has one instance in it

### Todos
1. Implement boolean operator logic (eg. find\_by\_age\_greater\_than\_or\_name\_like)
2. Implement ability to use the same parameter multiple times (currently find_by_age_greater_than_and_age_less_than will choke)
