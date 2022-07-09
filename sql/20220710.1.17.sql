ALTER TABLE fl_export
    ADD COLUMN create_file_start_time timestamp NULL,
    ADD COLUMN create_file_end_time timestamp NULL,
    ADD COLUMN create_file_success boolean,
    ADD COLUMN create_file_error_description varchar(8000) NULL;
