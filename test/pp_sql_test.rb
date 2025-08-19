# frozen_string_literal: true

require 'test_helper'

describe PpSql do
  class SubString < String
    include PpSql::ToSqlBeautify
  end

  let(:str) { SubString.new 'SELECT COUNT(*) FROM "users"' }

  after { PpSql.rewrite_to_sql_method = true }

  it 'parses provided sql' do
    assert_equal str.to_sql.lines.count, 4
  end

  it 'returns string as is' do
    PpSql.rewrite_to_sql_method = false
    assert_equal str.to_sql.lines.count, 1
  end

  it 'can be disabled with env var' do
    old_env = ENV.to_hash
    ENV.update('PPSQL_DISABLED' => '1')
    assert_equal 1, str.to_sql.lines.count
    ENV.replace old_env
  end

  it 'formats and prints with pp_sql' do
    out, = capture_io do
      str.pp_sql
    end

    assert_equal out, "SELECT\n    COUNT( * )\n  FROM\n    \"users\"\n"
  end

  it 'formats and prints with pp_sql if rewrite_to_sql_method is false' do
    PpSql.rewrite_to_sql_method = false
    out, = capture_io do
      str.pp_sql
    end

    assert_equal out, "SELECT\n    COUNT( * )\n  FROM\n    \"users\"\n"
  end
end
