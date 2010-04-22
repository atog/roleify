Roleify
=======

A Rails authorization plugin

Dependent on Clearance (should be configurable in the future though)

Example
=======

Make sure your User object has a "role" attribute (String).

Add an initializer
------------------

    Roleify::Role.configure(%w(role_a role_b role_c role_d role_e)) do
      {
        :role_a => { :issues =>  :all },
        :role_b => { :issues => "index" },
        :role_c => { :dashboard_issues => :all },
        :role_d => { :all => :all },
        :role_e => { :all => :all, :except => :issues }
      }
    end

In the example above "role\_a", "role\_b" and "role\_c" are the roles you are defining. The block contains the rules for these roles. There is no need to define an "admin" role, since it's added by default.

* Users with role "role\_a" are allowed to access all actions of IssuesController.
* Users with role "role\_b" are only allowed to access the index action of the IssuesController.
* Users with role "role\_c" are allowed to access all actions of Dashboard::IssuesController.
* Users with role "role\_d" are allowed to access all actions of all controllers.
* Users with role "role\_e" are allowed to access all actions of all controllers except for the actions of the issues controller.
* Users with role "admin" are allowed to access all actions of all controllers.


The controller
--------------

    class IssuesController < ActionController::Base
      include Clearance::Authentication
      include Roleify::RoleifyableController
    end

The User model
--------------

    class User < ActiveRecord::Base
      include Clearance::User
      include Roleify::RoleifyableModel
    end

The Helper
----------

    module ApplicationHelper
      include Roleify::RoleifyableHelper
    end


The View
--------

    <% allowed?(Roleify::Role::ROLE_A) do %>
      whatever you want for role_a eyes only
    <% end %>

Extra's
=======

Constants: `Roleify::Role::ADMIN`, `Roleify::Role::ROLE_A`, `Roleify::Role::ROLE_B`

Named scopes are automatically added: `User.admins`, `User.role_as`, `User.role_bs`

Methods: `User.admin?`, `User.role_a?`, `User.role_b?`



Copyright (c) 2009 Koen Van der Auwera - 10to1, released under the MIT license