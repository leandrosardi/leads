ALTER TABLE fl_export
    ADD COLUMN allow_multiple_contacts_per_company boolean,
    ADD COLUMN number_of_records bigint,
    ADD COLUMN filename varchar(8000);