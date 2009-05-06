module Roleify
  class Role

    def self.configure(roles)
      raise unless block_given?
      const_set(:ROLES, Array(roles) << "admin")
      ROLES.each { |role| const_set(role.upcase.to_sym, role) }
      const_set(:RULES, yield)
    end

  end
end
