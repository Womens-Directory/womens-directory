class OrgDecorator < ApplicationDecorator
  delegate_all

  def website_pretty
    m = website.match /https?:\/\/(.+)/
    return website unless m
    m[1]
  end
end
