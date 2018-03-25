# Sample data of my presentation at Rails Developers Meetup 2018

## Prerequisites

Set the following environment variables:

Name | Default
-----|----------
MYSQL_DATABASE | railsdm2018
MYSQL_USER | root
MYSQL_PASSWORD |
MYSQL_HOST | localhost
MYSQL_PORT | 3306

## Create tables

```
rake db:create
rake db:migrate
```

## Insert sample data

```
rake db:insert
```
