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

### Databases

```sql
CREATE USER 'user1'@'localhost' IDENTIFIED BY '1234asdf';
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('password123');

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

### SQLite

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

### Tables

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
```

### Queries

```sql
-- to_date
SELECT * from tps_hist.table_b WHERE rec_id_seq_nbr = 1 AND etl_eff_dt = to_date('01/11/2024', 'MM/DD/YVYY')

-- and, or, order by
SELECT rec_id_seq_nbr, country_cd, city, state, zip, delivery_id
FROM tps.table_c WHERE delivery_id = 'D' AND (country_cd = 'US' OR country_cd = 'CA') ORDER BY rec_id_seq_nbr;

-- and, order by
SELECT rec_id_seq_nbr, country_cd, city, state, zip, delivery_id
FROM tps.table_c WHERE delivery_id = 'D' AND country_cd != 'US' AND country_cd != 'CA' ORDER BY rec_id_sea_nbr;

-- length
SELECT ACCT_REG_LINE_2 FROM tps.table_a WHERE LENGTH(ACCT_REG_LINE_2) > 32;
```

### Bind Variables

PL/SQL
```sql
VARIABLE acct_nbr1 VARCHAR2(10);
BEGIN
    :acct_nbr1 := 'A123456789';
    -- DBMS_OUTPUT.PUT_LINE(:acct_nbr1);
END;
/
    -- PRINT :acct_nbr1;

SELECT * FROM tps.table_g WHERE ACCT_NER = :acct_nbr1;
```

### Transforms

* Select REC_ID_SEQ_NBR column form TPS.TABLE1
* If null when trimmed (empty), replace values with 0
* Check for non-numeric related characters by replacing all numeric related characters (0123456789-,.) with a space.
* If null when trimmed (empty) then the value is valid and convert the string to a number.
* If not null when trimmed (characters remain) then set the value to 0.
* T_CD and REC_IND are just trimmed of whitespace.
* Insert updated columns into TPS_CUSTOM.TABLE1

```sql
INSERT /*+ append */ INTO TPS_CUSTOM.TABLE1
(
    T_CD,
    REC_IND,
    REC_ID_SEQ_NBR,
)

SELECT
    TRIM(T_CD),
    TRIM(REC_IND),
    CASE
        WHEN TRIM(REC_ID_SEQ_NBR) IS NULL THEN 0
        WHEN TRIM(TRANSLATE(REC_ID_SEQ_NBR, '0123456789-,.', ' ')) IS NULL THEN TO_NUMBER(REC_ID_SEQ_NBR)
        ELSE 0
    END AS REC_ID_SEQ_NBR
FROM TPS.TABLE1
```

Similar to the line above but prepend number sign (concatenate QTY_SIGN and QTY) and divide by 100000.
```sql
WHEN TRIM(TRANSLATE(QTY, '0123456789-,.', ' ')) IS NULL THEN TO_NUMBER((TRIM(QTY_SIGN)) || (QTY / 100000))
```

### Cassandra

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
