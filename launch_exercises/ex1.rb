module Walkable
  def walk
    puts "Let's go for a walk!"
  end
end

COLOR = 'black and white'

class Cat
  include Walkable
  @@number_of_cats = 0
  def initialize(name)
    @name = name
    @@number_of_cats += 1
  end

  attr_accessor :name

  def greet
    puts "I'm a #{COLOR} cat named #{name}."
  end

  def rename(new_name)
    self.name= new_name
  end

  def identify
    self
  end

  def to_s
    "I'm #{name}"
  end

  def self.generic_greeting
    puts "hello! I'm a cat!"
  end

  def self.total
    p @@number_of_cats
  end
end

kitty = Cat.new('Sophie')
kitty.greet
kitty.name= 'Luna'
kitty.greet
kitty.walk
Cat.generic_greeting
kitty.rename('Chloe')
kitty.greet
p kitty.identify
Cat.total
puts kitty