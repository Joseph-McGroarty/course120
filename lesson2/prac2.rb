class Mammal
  def run
    'running!'
  end

  def jump
    'jumping!'
  end

  def speak
    'bark!'
  end
end

class Dog < Mammal
  def swim
    'swimming!'
  end

  def fetch
    'fetching!'
  end

  def speak
    'bark!'
  end
end

class Cat < Mammal
  def speak
    'meow!'
  end
end

class Bulldog < Dog
  def swim
    "can't swim!"
  end
end