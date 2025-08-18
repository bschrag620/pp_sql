# frozen_string_literal: true

namespace :pp_sql do
  desc 'Hook that is ran before rails db:migrate that will disable pp_sql when disable_during_db_migrate is set to true'

  task :disable_during_db_migrate do
    if PpSql.disable_during_db_migrate
      PpSql.add_rails_logger_formatting = false
      PpSql.rewrite_to_sql_method = false
    end
  end
end

Rake::Task['db:migrate'].enhance(['pp_sql:disable_during_db_migrate'])
