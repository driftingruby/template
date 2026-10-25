# frozen_string_literal: true

# Resolve copy_file sources relative to this file so the template works from
# wherever it's cloned, not just ~/driftingruby.
source_paths.unshift(__dir__)

# gsub_file! raises when nothing matches, so a change to the Rails defaults
# fails loudly instead of silently producing an unbranded app.
gsub_file! 'Gemfile', /^# Windows does not include zoneinfo files.*\ngem "tzinfo-data".*\n\n/, ''

copy_file 'tailwind/favicon.ico', 'public/favicon.ico', force: true
copy_file 'tailwind/icon.png', 'public/icon.png', force: true
copy_file 'tailwind/logo.svg', 'public/icon.svg', force: true
copy_file 'tailwind/logo.png', 'app/assets/images/logo.png'

layout = 'app/views/layouts/application.html.erb'
gsub_file! layout, '<html>', '<html class="bg-gray-200">'
gsub_file! layout, %r{<title>.*</title>}, '<title><%= content_for(:title) || "Drifting Ruby" %></title>'
# Flash is left to the views: the tailwindcss-rails scaffold and authentication
# generators already render notice/alert, so a layout flash would show twice.
gsub_file! layout, %r{<body>.*</body>}m do
  <<~ERB.strip
    <body class="min-h-screen flex flex-col p-4 md:p-8">
        <div class="flex-1 p-4 bg-white border-2 border-slate-400 shadow-lg sm:px-10 lg:px-12">
          <%= render "layouts/navigation" %>
          <main class="py-4">
            <%= yield %>
          </main>
        </div>
      </body>
  ERB
end

copy_file 'tailwind/_navigation.html.erb', 'app/views/layouts/_navigation.html.erb'
copy_file 'tailwind/_navigation_links.html.erb', 'app/views/layouts/_navigation_links.html.erb'

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

gem 'hotwire-spark', group: :development

route 'root "welcome#index"'

after_bundle do
  generate :controller, 'welcome', 'index', '--skip-routes'

  git add: '.'
  git commit: %( -m 'base')
end
