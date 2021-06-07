if Rails.env.development?
  Niceql.configure do |c|
    c.pg_adapter_with_nicesql = Rails.env.development?

    # c.indentation_base = 2
    # c.open_bracket_is_newliner = false
    # c.prettify_active_record_log_output = false
  end
end
