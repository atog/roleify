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

    def actions_for_role(rules_for_role)
      current_controller = self.controller_path.gsub("/", "_").to_sym
      if rules_for_role
        if rules_for_role[:except] && (rules_for_role[:except] == current_controller  || Array(rules_for_role[:except]).include?(current_controller))
          nil
        elsif rules_for_role[:all]
          rules_for_role[:all]
        else
          rules_for_role[current_controller]
        end
      end
    end

  end
end
