Navy
====

Navy support rendering for horizontal, multi-level navigation bars. Sections are dynamic and can depend on user permissions etc.

Some of the features are:

- A simple but powerful DSL to describe the navigation structure
- Subnavigations can be previewed by clicking an expand arrow
- Sections that don't fit into the navigation bar are automatically moved into a dropdown


How it works
-----------

The gem provides the DSL to specify the navigation structure as well as a renderer that outputs appropriate HTML.

To style it, we provide a sample .sass stylesheet you have to copy and include into your stylesheet, as well as adapt to your design.

The javascript functionality is provided in navy.js that you have to copy and include in your application.


Caveats
-------

The gem should be considered in an alpha state.

Styles are not very flexible yet, it might be hard to adapt them to your needs.

The standard styles do not work well with old browsers (e.g. IE 8).

The JavaScript features are somewhat dependent on the CSS (to determine when sections will be collapsed). In particular, you have to make sure that the dropdown arrow floats correctly right of the navigation sections.

Some assets have to be copied manually, there is no generator yet.


Installation
------------

Put this into your Gemfile:

    gem 'makandra-navy', :require => 'navy'


Copy stylesheets, javascripts and (perhaps) cucumber steps from /assets into your project.



Usage
-----

Navigation structure is defined with a class like this (somewhere in your load path):

    class Navigation
      include Navy::Description

      navigation :main do

        section :dashboard, "Dashboard", root_path

        if current_user.admin?
          section :admin do
            section :admin_users, "Users", admin_users_path

            if current_user.may_admin_projects?
              section :admin_projects, "Projects", admin_projects_path
            end
          end
        end
      end

      navigation :footer do
        section :terms, "Terms and Conditions", terms_and_conditions_path
        section :imprint, "Imprint", imprint_path
      end

    end


This is all evaluated in your view context, so helpers will work.
  
To actually render a navigation, do this in your view:

    <%= render_navigation Navigation.main, :collapse => true %>

    <%= render_navigation Navigation.footer %>


The `:collapse => true` option enables the automatic moving of navigation sections into a dropdown if they do not fit.



Credits
-------

Tobias Kraze, Henning Koch
