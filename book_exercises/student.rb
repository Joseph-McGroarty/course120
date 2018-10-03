class Student
  def initialize(n, g)
    @name = n
    self.grade = g
  end
  attr_reader :name

  def better_grade_than?(other_student)
    true if self.grade > other_student.grade
  end

  protected
  attr_accessor :grade
end

joe = Student.new('Joe', 99)
bob = Student.new('Bob', 78)

puts "Well done!" if joe.better_grade_than?(bob)
puts "Good for Bob!" if bob.better_grade_than?(joe)

joe.grade