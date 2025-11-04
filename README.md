# Template

This is the template that is used for creating new projects for
Drifting Ruby episodes.

# Usage

Download the template to a directory. Personally, I keep mine under
`~/driftingruby`.

You can then create a new Rails application with this template.

    rails new example -m ~/<TEMPLATE_LOCATION>/tailwind.rb

*NOTE:* When I'm creating a new application, I omit the `-m` flag since
I have a `~/.railsrc` file which contains the flag.

    # ~/.railsrc
    --skip-spring
    --asset-pipeline propshaft
    --skip-jbuilder
    --skip-test
    --skip-system-test
    --css tailwind
    --quiet
    --pre
    -m ~/driftingruby/tailwind.rb

*Additional NOTE:* I'm also creating these projects with the
latest version of Rails. At the time of writing this is `Rails 8.1.0`.
