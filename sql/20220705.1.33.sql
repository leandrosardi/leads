ALTER TABLE fl_search ALTER COLUMN no_of_results TYPE BIGINT;

ALTER TABLE fl_search ALTER COLUMN no_of_companies TYPE BIGINT;

ALTER TABLE fl_search RENAME creation_time TO create_time;

ALTER TABLE fl_invite RENAME creation_time TO create_time;

ALTER TABLE fl_export RENAME creation_time TO create_time;
