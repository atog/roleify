module Roleify
  module RoleifyableController

    #TODO make deny action configurable, now depends on Clearance

    def allowed?
      # no user, no role deny access
      deny_access && return unless current_user && current_user.role
      # admin user, ok
      return if current_user.role.to_sym == Roleify::Role::ADMIN.to_sym
      # else check rules
      if Roleify::Role::RULES[current_user.role.to_sym] &&
         (actions = Roleify::Role::RULES[current_user.role.to_sym][self.controller_name.to_sym])
        return actions == :all || Array(actions).include?(self.action_name) || deny_access
      end
      # no rules, deny access
      deny_access
    end

  end
end
