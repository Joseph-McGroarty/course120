#last name should be initialized to an empty string by default


class Person < Integer
  attr_accessor :first_name, :last_name

  def initialize(n)
    self.name=(n)
  end

  def name
    "#{first_name} #{last_name}"
  end

  def name=(n)
    self.first_name = n.split[0]
    if n.split[1]
      self.last_name = n.split[1]
    else
      self.last_name = ''
    end
  end

  def compare_names(other_person)
    self.name == other_person.name
  end
end

p Person.ancestors