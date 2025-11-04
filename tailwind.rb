# frozen_string_literal: true
run 'bundle remove tzinfo-data'
run 'bundle install'

remove_file 'public/favicon.ico'
remove_file 'public/icon.png'
remove_file 'public/icon.svg'
copy_file '~/driftingruby/tailwind/favicon.ico', 'public/favicon.ico'
copy_file '~/driftingruby/tailwind/icon.png', 'public/icon.png'
copy_file '~/driftingruby/tailwind/logo.svg', 'public/icon.svg'
copy_file '~/driftingruby/tailwind/logo.png', 'app/assets/images/logo.png'

generate(:controller, 'welcome', 'index')

gsub_file 'app/views/layouts/application.html.erb', '<html>', '<html class="h-full bg-gray-200">'
gsub_file 'app/views/layouts/application.html.erb', '<body>', '<body class="m-4 md:m-8 lg:m-8">'
gsub_file 'app/views/layouts/application.html.erb', '<title>Template</title>', '<title>Drifting Ruby</title>'
gsub_file 'app/views/layouts/application.html.erb', '<%= yield %>' do
  <<~RUBY
    <div class="min-h-full p-4 bg-white border-2 border-slate-400 shadow-lg">
          <%= render 'layouts/navigation' %>
          <% flash.each do |type, msg| %>
            <% if type == 'alert' %>
              <%= content_tag :div, msg, class: "bg-red-500 text-white p-4 rounded mb-4", role: :alert %>
            <% else %>
              <%= content_tag :div, msg, class: "bg-blue-500 text-white p-4 rounded mb-4", role: :alert %>
            <% end %>
          <% end %>
          <div class="py-4">
            <div class="max-w-7xl sm:px-6 lg:px-8">
              <%= yield %>
            </div>
          </div>
        </div>
  RUBY
end

template '~/driftingruby/tailwind/_navigation.html.erb', 'app/views/layouts/_navigation.html.erb'
template '~/driftingruby/tailwind/_navigation_links.html.erb', 'app/views/layouts/_navigation_links.html.erb'

inject_into_file 'config/application.rb', before: '  end' do
  <<-CODE
    config.generators do |g|
      g.assets            false
      g.helper            false
      g.test_framework    nil
      g.jbuilder          false
    end
  CODE
end

gem "hotwire-spark", group: :development

route "root to: 'welcome#index'"

after_bundle do
  git :init
  git add: '.'
  git commit: %( -m 'base')
end
