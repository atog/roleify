module Roleify
  module RoleifyableHelper

    def allowed?(*roles, &block)
      if roles && (current_user.admin? || roles.include?(current_user.role))
        concat capture(&block)
      end
    end
    
    def allowed?(controller_url, action = "index")
      # no user, no role
      return false unless current_user && current_user.role
      # admin user, ok
      return true if current_user.role.to_sym == Roleify::Role::ADMIN.to_sym
      # else check rules
      if actions = actions_for_role(Roleify::Role::RULES[current_user.role.to_sym], controller_url)
        return actions == :all || Array(actions).include?(action.to_sym)
      end
      # no rules
      false
    end

  end
end