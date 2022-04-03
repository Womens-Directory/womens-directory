module UserPermissions
  class << self
    def set_all!(current_user, params)
      raise "Not authorized" unless current_user.can? :manage, :user_permissions

      users = {}
      matcher = /(\d+)-(.+)/
      params.each do |k, v|
        result = matcher.match k
        raise "Invalid key #{k}" unless result
        id, role = result.captures
        users[id] ||= User.find(id)
        puts k, v
        if v == '1'
          users[id].roles << role.to_sym
        elsif v == '0'
          # do nothing
        else
          raise "Invalid value #{v}"
        end
      end

      users.values.each(&:save!)
    end
  end
end
