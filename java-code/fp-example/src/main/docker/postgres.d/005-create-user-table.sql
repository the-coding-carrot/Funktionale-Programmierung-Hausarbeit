\connect fp_demo
create table users (
    id int primary key,
    username varchar,
    password varchar not null,
    age int not null
);
