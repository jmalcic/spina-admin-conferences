# frozen_string_literal: true

namespace :spina do
  Rake::Task[:convert_layout_parts_to_json].clear if Rake::Task.task_defined?('spina:convert_layout_parts_to_json')
  Rake::Task[:convert_page_parts_to_json].clear if Rake::Task.task_defined?('spina:convert_page_parts_to_json')

  desc 'Convert table-based partables to JSON-based parts'
  task convert_parts_to_json: [:environment, :'spina_admin_conferences:install:migrations'] do
    puts "If the upgrade migrations were missing, they should now have been copied to your migrations path.\n" \
         'If you have custom partables, you must modify the upgrade migration before running it: ' \
         "for more information, see the documentation in the migration.\n" \
         'Once the migration is ready, run `rails db:migrate`.'
  end
end
