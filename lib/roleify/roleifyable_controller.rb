module Roleify
  module RoleifyableController

    def self.included(base)
      base.before_filter :allowed?
    end

    #TODO make deny action configurable, now depends on Clearance

    def allowed?
      # no user, no role deny access
      deny_access && return unless current_user && current_user.role
      # admin user, ok
      return if current_user.role.to_sym == Roleify::Role::ADMIN.to_sym
      # else check rules
      if actions = actions_for_role(Roleify::Role::RULES[current_user.role.to_sym])
        return actions == :all || Array(actions).include?(self.action_name) || deny_access
      end
      # no rules, deny access
      deny_access
    end

  end
end
