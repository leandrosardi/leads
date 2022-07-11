ALTER TABLE fl_export ADD COLUMN IF NOT EXISTS create_file_start_time timestamp NULL;
ALTER TABLE fl_export ADD COLUMN IF NOT EXISTS create_file_end_time timestamp NULL;
ALTER TABLE fl_export ADD COLUMN IF NOT EXISTS create_file_success boolean;
ALTER TABLE fl_export ADD COLUMN IF NOT EXISTS create_file_error_description varchar(8000) NULL;
