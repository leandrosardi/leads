ALTER TABLE fl_export ADD COLUMN IF NOT EXISTS allow_multiple_contacts_per_company boolean;
ALTER TABLE fl_export ADD COLUMN IF NOT EXISTS number_of_records bigint;
ALTER TABLE fl_export ADD COLUMN IF NOT EXISTS filename varchar(8000);