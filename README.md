# Sample data of my presentation at Rails Developers Meetup 2018

## ER Diagram

![ER Diagram](ER_diagram.svg)

## Prerequisites

Set the following environment variables:

Name | Default
-----|----------
MYSQL_DATABASE | railsdm2018
MYSQL_USER | root
MYSQL_PASSWORD |
MYSQL_HOST | localhost
MYSQL_PORT | 3306

## Setup tables

```
./bin/setup
```

## Insert sample data

```
rake db:insert
```

## Use sample models

```
% ./bin/console
[1] pry(main)> User.count
   (0.5ms)  SET NAMES utf8mb4,  @@SESSION.sql_mode = CONCAT(CONCAT(@@sql_mode, ',STRICT_ALL_TABLES'), ',NO_AUTO_VALUE_ON_ZERO'),  @@SESSION.sql_auto_is_null = 0, @@SESSION.wait_timeout = 2147483
   (1.0ms)  SELECT COUNT(*) FROM `users`
=> 100
```
