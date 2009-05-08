module Roleify
  module RoleifyableModel

    def self.included(base)
      base.attr_accessible :role

      if defined? Role::ROLES
        Role::ROLES.each do |role|
          base.named_scope(role.tableize.to_sym, :conditions => {:role => eval("Role::#{role.upcase}")})

          define_method("#{role}?") do
            self.role == eval("Role::#{role.upcase}")
          end
        end
      end

    end

  end
end
