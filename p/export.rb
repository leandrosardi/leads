while true

  exports = Leads::FlExport.where(:create_file_start_time => NULL)
  exports.each do |export|
    export.create_file_start_time = now
    export.save

    begin
      export.do
    rescue => e
      export.create_file_end_time = now
      export.create_file_success = false
      export.create_file_error_description = e.message
      export.save
    end

    export.create_file_end_time = now
    export.create_file_success=true
    export.save
  end

end