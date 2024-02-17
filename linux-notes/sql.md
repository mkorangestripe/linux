# SQL

Basic installation of MySQL server on RHEL
```shell script
dnf install mysql-server
systemctl start mysqld.service
systemctl enable mysqld.service
mysql_secure_installation
```

Connect to MySQL database, run query
```shell script
mysql -u root -p
mysql -u root -p -e 'use animals; select * from animalia;'
```

Databases, tables, info
```sql
CREATE USER 'user1'@'localhost' IDENTIFIED BY '1234asdf';
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('bad_password');

SHOW DATABASES;
SHOW tables;
SELECT table_name FROM all_tables;  -- Oracle

CREATE DATABASE animals;
DROP DATABASE animals;

CREATE TABLE animalia;
DROP TABLE animalia;

DESCRIBE animals;
USE animals;

QUIT
```

SQLite
```
sqlite3 test1.db

select * from sqlite_master;

.databases
.tables
.show
.help
.mode column
.headers on
.quit
```

Queries
```sql
-- Create a table
CREATE TABLE animalia (Kingdom VARCHAR(100), Phylum VARCHAR(100), Class VARCHAR(100), `Order` VARCHAR(100), Family VARCHAR(100), Genus VARCHAR(100), Species VARCHAR(100));

-- Insert rows
INSERT INTO `animalia` (`Kingdom`, `Phylum`, `Class`, `Order`, `Family`, `Genus`, `Species`)
VALUES ("animalia", "chordata", "mammalia", "carnivora", "felidae", "caracal", "caracal");

VALUES ("animalia", "chordata", "mammalia", "carnivora", "felidae", "panthera", "leo");
VALUES ("animalia", "chordata", "mammalia", "carnivora", "felidae", "panthera", "tigris");

-- Delete a row
DELETE FROM animalia WHERE Species='caracal';

-- Add/Drop a column
ALTER TABLE animalia ADD common VARCHAR(100);
ALTER TABLE animalia DROP common;

-- Rename a column
ALTER TABLE animalia CHANGE common Common VARCHAR(100);

-- Move a column
ALTER TABLE animalia MODIFY Common VARCHAR(100) AFTER Species;

-- Update information in the table
UPDATE animalia SET Common = 'lion' WHERE Species = 'leo';

-- Basic select statements
SELECT COUNT(*) FROM animalia;
SELECT * FROM animalia WHERE Common is NULL;
select Genus,Species,Common,Status from animalia where Genus = "puma"

-- to_date
SELECT * from p_tps_hist.table_b WHERE record_id_seq_nbr = 1 AND etl_eff_dt = to_date('01/11/2024', 'MM/DD/YVYY')

-- and, or, order by
SELECT record_id_seq_nbr, country_cd, country_cd2, city, city2, state, state2, zip, zip2, delivery_id, delivery_id2
FROM p_tps.table_c WHERE delivery_id = 'D' AND (country_cd = 'US' OR country_cd = 'CA') ORDER BY record_id_seq_nbr;

-- and, order by
SELECT record_id_seq_nbr, country_cd, country_cd2, city, city2, state, state2, zip, zip2, delivery_id, delivery_id2
FROM p_tps.table_c WHERE delivery_id = 'D' AND country_cd != 'US' AND country_cd != 'CA' ORDER BY record_id_sea_nbr;
```

Cassandra
```sql
-- Find peers and version of Cassandra
SELECT peer, release_version FROM system.peers;

-- Find Cassandra and CQL version
show version

-- List all tables
DESCRIBE TABLES
-- or
SELECT table_name FROM system_schema.tables;

-- Find number of tables
SELECT count(*) FROM system_schema.tables;

-- Show table info
DESCRIBE TABLE storage_account_usage

-- Set the keyspace to ‘Metrics’
USE Metrics;

-- Find count of the item in each column
SELECT count(*) FROM system_schema.tables WHERE table_name='storage_account_delta_usage_201805' ALLOW FILTERING;

-- Drop the table if it exists
DROP TABLE IF EXISTS Metrics.test_table;
```