require "rails/generators"
require "rails/generators/active_record"

module HitsCounter
  # Installs HitsCounter in a rails app.
  class InstallGenerator < ::Rails::Generators::Base
    include ::Rails::Generators::Migration

    # Class names of MySQL adapters.
    # - `MysqlAdapter` - Used by gems: `mysql`, `activerecord-jdbcmysql-adapter`.
    # - `Mysql2Adapter` - Used by `mysql2` gem.
    MYSQL_ADAPTERS = [
      "ActiveRecord::ConnectionAdapters::MysqlAdapter",
      "ActiveRecord::ConnectionAdapters::Mysql2Adapter"
    ].freeze

    source_root File.expand_path("../templates", __FILE__)

    desc "Generates (but does not run) a migration to add the hc_matching_hits table."

    def create_migration_file
      add_hits_counter_migration("create_hc_matching_hits_table")
    end

    def copy_initializer_file
      copy_file "initializer.rb", "config/initializers/hits_counter.rb"
    end

    def self.next_migration_number(dirname)
      ::ActiveRecord::Generators::Base.next_migration_number(dirname)
    end

    protected

    def add_hits_counter_migration(template)
      migration_dir = File.expand_path("db/migrate")
      if self.class.migration_exists?(migration_dir, template)
        ::Kernel.warn "Migration already exists: #{template}"
      else
        migration_template(
          "#{template}.rb.erb",
          "db/migrate/#{template}.rb",
          migration_version: migration_version,
          table_options: table_options
        )
      end
    end

    private

    def migration_version
      major = ActiveRecord::VERSION::MAJOR
      if major >= 5
        "[#{major}.#{ActiveRecord::VERSION::MINOR}]"
      end
    end

    def mysql?
      MYSQL_ADAPTERS.include?(ActiveRecord::Base.connection.class.name)
    end

    # user utf8
    def table_options
      if mysql?
        ', { options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci" }'
      else
        ""
      end
    end

  end
end
