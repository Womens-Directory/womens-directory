module UserPermissions
  class << self
    def set_all!(current_user, params)
      raise "Not authorized" unless current_user.can? :manage, :user_permissions

      # Don't let admins lock themselves or other admins out
      forbidden = User.all.filter { |u| u == current_user || u.superadmin? }

      users_by_id = {}
      matcher = /(\d+)-(.+)/
      params.each do |k, v|
        next unless result = matcher.match(k) # ignore form keys like `authentication_token`
        id, role = result.captures

        unless users_by_id[id]
          user = User.find(id)
          next if forbidden.include?(user)
          user.roles = []
          users_by_id[id] = user
        end

        if v == '1'
          users_by_id[id].roles << role.to_sym
        elsif v == '0'
          # do nothing
        else
          raise "Invalid value #{v}"
        end
      end

      users = users_by_id.values
      ApplicationRecord.transaction { users.each(&:save!) }
      return users.count
    end
  end
end
