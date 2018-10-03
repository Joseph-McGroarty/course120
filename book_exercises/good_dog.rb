class GoodDog

  DOG_YEARS = 7

  @@number_of_dogs = 0

  def initialize(n, h, w, a)
    self.name = n
    self.height = h
    self.weight = w
    @@number_of_dogs += 1
    self.age = a * DOG_YEARS
  end

  def self.total_number_of_dogs
    @@number_of_dogs
  end

  attr_accessor :name, :height, :weight, :age

  def change_info(n, h, w)
    self.name = n
    self.height = h
    self.weight = w
  end

  def info
    "#{name} is #{height} tall and weighs #{weight}."
  end

  def speak
    puts "#{self.name} says 'Arf!'"
  end

  def to_so
    'text'
  end

  def what_is_self
    self
  end
end

sparky = GoodDog.new('Sparky', '7 inches', '7 lbs', 1)
sparky.weight=('5 lbs')
jacob = GoodDog.new('Jacob', '22 inches', '62 lbs', 3)

p sparky.name
p jacob.name

sparky.name= 'Ruby'
jacob.name= 'Jake'

p sparky.name
p jacob.name

jacob.speak

jacob.change_info('Jacob', '23 inches', '65 lbs')
p jacob.info

p GoodDog.total_number_of_dogs

p jacob.what_is_self