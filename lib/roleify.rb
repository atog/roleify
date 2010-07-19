module Roleify
  def actions_for_role(rules_for_role, controller_path = self.controller_path)
    current_controller = controller_path.gsub("/", "_").to_sym
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

require "roleify/role"
require "roleify/roleifyable_model"
require "roleify/roleifyable_controller"