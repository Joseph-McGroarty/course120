class Vehicle
  @@number_of_vehicles = 0

  def initialize(yr, clr, mdl)
    @@number_of_vehicles += 1
    @year = yr
    @color = clr
    @model = mdl
    @current_speed = 0
  end

  attr_accessor :color, :current_speed
  attr_reader :year, :model

  def self.how_many_vehicles
    print @@number_of_vehicles
  end

  def to_s
    "The #{color} #{year} #{model} is going #{current_speed} mph."
  end

  def self.gas_milage(miles, gallons)
    "#{miles / gallons} mpg."
  end

  def speed_up(incr)
    self.current_speed += incr
  end

  def brake(dcrs)
    self.current_speed -= dcrs
  end

  def turn_off
    self.current_speed = 0
  end

  def spray_paint(clr)
    self.color = clr
  end

  def age
    "the vehicle is #{calculate_age} years old."
  end

  private

  def calculate_age
    Time.now.year - self.year
  end
end

class MyCar < Vehicle
  VEHICLE_TYPE = 'car'
  def self.what_am_i
    "I'm a car!"
  end
end

module BlowSmokeable
  def blow_smoke
    puts "*puff puff*"
  end
end

class MyTruck < Vehicle

  VEHICLE_TYPE = 'truck'
  include BlowSmokeable
  def self.what_am_i
    "I'm a truck!"
  end
end

my_honda = MyCar.new(2003, 'blue', 'Honda Civic')
Vehicle.how_many_vehicles

mail_truck = MyTruck.new(1998, 'white and blue', 'unknown model')
mail_truck.blow_smoke

mail_truck.speed_up(25)
puts mail_truck.current_speed

puts my_honda.age