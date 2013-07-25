class Numeric
  def restrict(var = {})
    min = var[:min] || 0
    max = var[:max] || 255

    self < min ? min : (self > max ? max : self)
  end

  def to_hex
    to_s(base=16).rjust(2, '0')
  end
end
