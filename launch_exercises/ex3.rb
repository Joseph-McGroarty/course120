module Transportation
  class Vehicle
    attr_reader :year

    def initialize(year)
      @year = year
    end
  end

  module Towable
    def tow
      puts "I can tow a trailer!"
    end
  end

  class Car < Vehicle
    #
  end

  class Truck < Vehicle
    include Towable
    def initialize(year, bed_type)
      super(year)
      start_engine
      @bed_type = bed_type
    end
    def start_engine
      puts 'Ready to go!'
    end
  end
end

truck1 = Transportation::Truck.new(1994, 'short')
puts truck1.year

car1 = Transportation::Car.new(2006)
puts car1.year

truck1.tow

# Cat, Animal

# cat, Animal, (list of stuff every obj has like Basic Object and Kernel, finds nothing and throws an error)

# Bird, Flyable, Animal