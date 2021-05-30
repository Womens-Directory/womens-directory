class PhoneNumberDecorator < Draper::Decorator
  delegate_all

  def pretty
    return @pretty if @pretty
    d = number.gsub /[^\d]/, ''  # extract digits
    return @pretty = number if d.chars.count != 10  # don't prettify nums that are not 10 digits long
    @pretty = "(#{d.slice 0, 3}) #{d.slice 3, 3}-#{d.slice 6, 4}"  # (612) 555-1212
  end

  def tel_uri
    @tel ||= "tel:#{pretty}"
  end

  def sms_uri
    @sms ||= "sms:#{pretty}"
  end

  def uri
    return sms_uri if sms && !call
    tel_uri
  end
end
