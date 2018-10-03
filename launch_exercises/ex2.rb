class Person
  attr_writer :secret
  @secret = 'this is a secret'

  def share_secret
    puts secret
  end

  def compare_secret(other_person)
    secret == other_person.secret
  end

  protected

  attr_reader :secret
end

person1 = Person.new
person1.secret= 'this is a secret added from outside the method.'
person1.share_secret
person2 = Person.new
person2.secret= 'another secret'
p person1.compare_secret(person2)