module Roleify
  module RoleifyableHelper

    def allowed?(*roles, &block)
      if roles && (current_user.admin? || roles.include?(current_user.role))
        concat capture(&block)
      end
    end

  end
end