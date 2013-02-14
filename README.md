Specifind
=========

Specifind offers advanced ActiveRecord dynamic find\_by_* methods that include comparators. Coupled with some solid SQL injection mitigation through strict verification of type and string escaping, your find methods can become much more readable.

#### Examples

Here is the person class that is used in the test/dummy app:

    class Person < ActiveRecord::Base
      attr_accessible :age, :birthday, :name
      acts_as_findable
    end

Specifind is automatically included in ActiveRecord once it is added to your Gemfile. `acts_as_findable` will enable a model to employ specifind's find\_by_* methods. Given the three attributes above, here are some examples of methods you could use to slice your data:
`Person.find_by_age_greater_than_or_birthday_between 15, DateTime.new(1985, 1, 1),DateTime.new(1987,3,6)`

`Person.find_by_name_like '%a%'`

`Person.find_by_name_is_not_null`

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

#### Notes
1. Currently, the ilike comparator only works with mysql (to the best of my knowledge)

### Todos
1. Implement boolean operator logic (eg. find\_by\_age\_greater\_than\_or\_name\_like)
2. Implement ability to use the same parameter multiple times (currently find_by_age_greater_than_and_age_less_than will choke)