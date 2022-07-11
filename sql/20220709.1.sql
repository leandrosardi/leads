ALTER TABLE fl_export_lead ADD COLUMN IF NOT EXISTS delete_time TIMESTAMP NULL;

ALTER TABLE fl_export_lead ADD COLUMN IF NOT EXISTS added_manually BOOLEAN NULL;

ALTER TABLE fl_export_lead ADD COLUMN IF NOT EXISTS create_Time TIMESTAMP NULL;

UPDATE fl_export_lead SET create_Time = current_timestamp WHERE create_time IS NULL;

ALTER TABLE fl_export_lead ALTER COLUMN create_Time SET NOT NULL;

ALTER TABLE fl_export_lead ADD COLUMN IF NOT EXISTS id_user UUID NULL;

--ALTER TABLE fl_export_lead ADD CONSTRAINT fk_fl_export_lead__id_user FOREIGN KEY (id_user) REFERENCES "user"(id);

