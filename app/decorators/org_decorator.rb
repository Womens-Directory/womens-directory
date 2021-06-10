class OrgDecorator < Draper::Decorator
  delegate_all

  def website_pretty
    m = website.match /https?:\/\/(.+)/
    return website unless m
    m[1]
  end
end
