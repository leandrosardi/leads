/*
SET enable_experimental_alter_column_type_general = true;

ALTER TABLE fl_lead ALTER COLUMN stat_has_email TYPE boolean USING (stat_has_email::int::bool);
ALTER TABLE fl_lead ALTER COLUMN stat_has_phone TYPE boolean USING (stat_has_phone::int::bool);

ALTER TABLE fl_search ALTER COLUMN saved TYPE boolean USING (saved::int::bool);
ALTER TABLE fl_search ALTER COLUMN "temp" TYPE boolean USING ("temp"::int::bool);

ALTER TABLE fl_search_industry ALTER COLUMN positive TYPE boolean USING (positive::int::bool);
ALTER TABLE fl_search_location ALTER COLUMN positive TYPE boolean USING (positive::int::bool);
ALTER TABLE fl_search_position ALTER COLUMN positive TYPE boolean USING (positive::int::bool);

SET enable_experimental_alter_column_type_general = false;
*/

/*
delete from fl_data;
delete from fl_lead;
delete from fl_company;
*/

select * from fl_company

select * from fl_lead

select * from fl_data order by id_lead


