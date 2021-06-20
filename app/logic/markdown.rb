class Markdown
  class << self
    MD_CTRL_CHARS = '\`*_{[<(#+-.!|'

    def escape(msg)
      m = msg.to_s.dup
      MD_CTRL_CHARS.chars.each { |c| m.gsub! c, "\\#{c}" }
      return m
    end
  end
end
