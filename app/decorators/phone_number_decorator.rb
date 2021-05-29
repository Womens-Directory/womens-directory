class PhoneNumberDecorator < Draper::Decorator
  delegate_all

  def pretty
    d = number.gsub /[^\d]/, ''  # digits
    return number if d.chars.count != 10
    "(#{d.slice 0, 3}) #{d.slice 3, 3}-#{d.slice 6, 4}"
  end
end
