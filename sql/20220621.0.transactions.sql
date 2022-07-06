CREATE TABLE IF NOT EXISTS fl_search (
    id uuid not null,
    id_user uuid,
    name varchar (8000),
    creation_time timestamp not null,
    no_of_results int,
    no_of_companies int,
    description varchar (8000),
    saved boolean not null,
    temp boolean null,
    PRIMARY KEY (id),
    FOREIGN KEY (id_user) REFERENCES "user"(id)
);

CREATE TABLE IF NOT EXISTS fl_industry (
    id uuid not null,
    code varchar(500) NOT NULL,
    name varchar (8000),
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS fl_location (
    id uuid not null,
    name varchar (8000),
    code varchar(500) NOT NULL,
    id_country uuid,
    PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS fl_search_industry (
    id uuid not null,
    id_industry uuid,
    id_search uuid,
    positive boolean,
    PRIMARY KEY (id),
    FOREIGN KEY (id_industry) REFERENCES fl_industry(id),
    FOREIGN KEY (id_search) REFERENCES fl_search(id)
);

CREATE TABLE IF NOT EXISTS fl_search_location (
    id uuid not null,
    id_location uuid,
    id_search uuid,
    positive boolean,
    PRIMARY KEY (id),
    FOREIGN KEY (id_location) REFERENCES fl_location(id),
    FOREIGN KEY (id_search) REFERENCES fl_search(id)
);

CREATE TABLE IF NOT EXISTS fl_search_position (
    id uuid not null,
    id_search uuid,
    positive boolean,
    value varchar (8000) not null,
    PRIMARY KEY (id),
    FOREIGN KEY (id_search) REFERENCES fl_search(id)
);

CREATE TABLE IF NOT EXISTS fl_invite (
    id uuid not null,
    id_user uuid,
    first_name varchar (8000) not null,
    last_name varchar (8000) not null,
    email varchar (8000) not null,
    creation_time timestamp not null,
    PRIMARY KEY (id),
    FOREIGN KEY (id_user) REFERENCES "user"(id)
);

CREATE TABLE IF NOT EXISTS fl_export (
    id uuid not null,
    id_user uuid,
    id_search uuid,
    creation_time timestamp not null,
    PRIMARY KEY (id),
    FOREIGN KEY (id_search) REFERENCES fl_search(id),
    FOREIGN KEY (id_user) REFERENCES "user"(id)
);

CREATE TABLE IF NOT EXISTS fl_company (
    id uuid not null,
    name varchar (8000) null,
    PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS fl_lead (
    id uuid not null,
    name varchar (8000) not null,
    position varchar (8000),
    id_company uuid,
    id_industry uuid,
    id_location uuid,
    stat_has_email boolean null,
    stat_has_phone boolean null,
    stat_company_name varchar(8000) null,
    stat_industry_name varchar(8000) null,
    stat_location_name varchar(8000) null,
    PRIMARY KEY (id),
    FOREIGN KEY (id_company) REFERENCES fl_company(id),
    FOREIGN KEY (id_location) REFERENCES fl_location(id),
    FOREIGN KEY (id_industry) REFERENCES fl_industry(id)
);

CREATE TABLE IF NOT EXISTS fl_export_lead (
    id uuid not null,
    id_export uuid,
    id_lead uuid,
    PRIMARY KEY (id),
    FOREIGN KEY (id_export) REFERENCES fl_export(id),
    FOREIGN KEY (id_lead) REFERENCES fl_lead(id)
);

CREATE TABLE IF NOT EXISTS fl_data (
    id uuid not null,
    id_lead uuid,
    type int not null,
    value varchar(8000) not null,
    PRIMARY KEY (id),
    FOREIGN KEY (id_lead) REFERENCES fl_lead(id)
);

drop table fl_search_location;

CREATE TABLE IF NOT EXISTS fl_search_location (
    id uuid not null,
    value varchar (8000) not null,
    id_search uuid,
    positive boolean,
    PRIMARY KEY (id),
    FOREIGN KEY (id_search) REFERENCES fl_search(id)
    );