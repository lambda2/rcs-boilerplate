#!/bin/bash

user_home=`ls -d ~ | tr -d "\n"`
ssh_attrs="-p 1993"
ssh_host="deployer@%URL"
ssh="ssh $ssh_host $ssh_attrs"
db_dev="%NAME_dev"
db_prod="%NAME_production"

$ssh "pg_dump -Oxc $db_prod > /home/deployer/apps/%NAME/$db_prod.sql"


rsync -avz -e "ssh $ssh_attrs" $ssh_host:/home/deployer/apps/%NAME/$db_prod.sql /tmp/$db_prod.sql
cat /tmp/$db_prod.sql | psql $db_dev

# echo "CREATE TABLE stalks (id integer NOT NULL, stalker_id integer, victim_id integer, created_at timestamp without time zone, updated_at timestamp without time zone);" | psql $db_dev
# echo "CREATE SEQUENCE stalks_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1; ALTER SEQUENCE stalks_id_seq OWNED BY stalks.id;" | psql $db_dev
# echo 'CREATE TABLE core_mails (id integer NOT NULL, "from" character varying(255), "to" text, cc text, bcc text, content text, subject character varying(255), kind character varying(255), created_at timestamp without time zone, updated_at timestamp without time zone, has_been_sent boolean);' | psql $db_dev
# echo 'CREATE TABLE clicks (id integer NOT NULL, link_id integer, user_id integer, resource_id integer, created_at timestamp without time zone, updated_at timestamp without time zone);' | psql $db_dev


# ls -d public/assets/uploads
# if [ $? -eq 0 ]
# then
#   rsync -avz -e "ssh $ssh_attrs" $ssh_host:app/current/public/assets/uploads/ public/assets/uploads
# fi

