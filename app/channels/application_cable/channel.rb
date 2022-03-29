module ApplicationCable
  class Channel < ActionCable::Channel::Base
  end
end

# https://api.rubyonrails.org/classes/ActionCable/Channel/Base.html
# The channel provides the basic structure of grouping behavior into logical units when communicating
#over the WebSocket connection. You can think of a channel like a form of controller, but one that's
#capable of pushing content to the subscriber in addition to simply responding to the subscriber's
#direct requests.
#ActionCable: https://guides.rubyonrails.org/action_cable_overview.html

# Action Cable seamlessly integrates WebSockets with the rest of your Rails application.
#It allows for real-time features to be written in Ruby in the same style and form as the rest of
#your Rails application, while still being performant and scalable. It's a full-stack offering that
#kprovides both a client-side JavaScript framework and a server-side Ruby framework.

# what is WebSocket: https://en.wikipedia.org/wiki/WebSocket
# WebSocket is a computer communications protocol, providing full-duplex communication channels
# over a single TCP connection. his is made possible by providing a standardized way for the server
#to send content to the client without being first requested by the client, and allowing messages
#
# to be passed back and forth while keeping the connection open. In this way, a two-way ongoing
#conversation can take place between the client and the server

# what is this and how are we using it?
