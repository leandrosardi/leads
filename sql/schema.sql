CREATE TABLE IF NOT EXISTS fl_search (
    id int not null,
    id_users int,
    name varchar (8000),
    creation_time timestamp not null,
    no_of_results int,
    no_of_companies int,
    description varchar (8000),
    saved bit not null,
    temp bit null,
    PRIMARY KEY (id),
    FOREIGN KEY (id_users) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS fl_industry (
    id int not null,
    name varchar (8000),
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS fl_location (
    id int not null,
    name varchar (8000),
    PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS fl_search_industry (
    id int not null,
    id_industry int,
    id_search int,
    positive bit,
    PRIMARY KEY (id),
    FOREIGN KEY (id_industry) REFERENCES fl_industry(id),
    FOREIGN KEY (id_search) REFERENCES fl_search(id)
);

CREATE TABLE IF NOT EXISTS fl_search_location (
    id int not null,
    id_location int,
    id_search int,
    positive bit,
    PRIMARY KEY (id),
    FOREIGN KEY (id_location) REFERENCES fl_location(id),
    FOREIGN KEY (id_search) REFERENCES fl_search(id)
);

CREATE TABLE IF NOT EXISTS fl_search_position (
    id int not null,
    id_search int,
    positive bit,
    value varchar (8000) not null,
    PRIMARY KEY (id),
    FOREIGN KEY (id_search) REFERENCES fl_search(id)
);

CREATE TABLE IF NOT EXISTS fl_invite (
    id int not null,
    id_users int,
    first_name varchar (8000) not null,
    last_name varchar (8000) not null,
    email varchar (8000) not null,
    creation_time timestamp not null,
    PRIMARY KEY (id),
    FOREIGN KEY (id_users) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS fl_export (
    id int not null,
    id_users int,
    id_search int,
    creation_time timestamp not null,
    PRIMARY KEY (id),
    FOREIGN KEY (id_search) REFERENCES fl_search(id),
    FOREIGN KEY (id_users) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS fl_company (
    id int not null,
    name varchar (8000) null,
    PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS fl_lead (
     id int not null,
     position varchar (8000),
     id_company int,
     id_industry int,
     id_location int,
     stat_has_email bit null,
     stat_has_phone bit null,
     stat_company_name varchar(8000) null,
     stat_industry_name varchar(8000) null,
     stat_location_name varchar(8000) null,
     PRIMARY KEY (id),
     FOREIGN KEY (id_company) REFERENCES fl_company(id),
     FOREIGN KEY (id_location) REFERENCES fl_location(id),
     FOREIGN KEY (id_industry) REFERENCES fl_industry(id)
);

CREATE TABLE IF NOT EXISTS fl_export_lead (
    id int not null,
    id_export int,
    id_lead int,
    PRIMARY KEY (id),
    FOREIGN KEY (id_export) REFERENCES fl_export(id),
    FOREIGN KEY (id_lead) REFERENCES fl_lead(id)
);

CREATE TABLE IF NOT EXISTS fl_data (
    id int not null,
    id_lead int,
    type int not null,
    value varchar(8000) not null,
    PRIMARY KEY (id),
    FOREIGN KEY (id_lead) REFERENCES fl_lead(id)
)
