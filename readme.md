To start mysql, in the terminal, type in `mysql -u root`

To create a user that can be accessed via nodejs etc, run this:
```
mysql -e "ALTER USER 'user'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root_password';"
```

# import sakila database
mysql -u root < sakila-schema.sql
mysql -u root < sakila-data.sql

# dependencies
<!-- shell script/bash script -->
yarn add express
yarn add hbs 
yarn add wax-on
yarn add handlebars-helpers
yarn add mysql2

chmod +x init.sh --> give permission to run bash file

./init.sh

# create user
root is the superadmin user, so it is dangerous to use it -> create a new database user for every project

create user 'ahkow'@'localhost' IDENTIFIED BY 'rotiprata123';

grant all privileges on sakila.* to 'ahkow'@'localhost' with grant option;

FLUSH PRIVILEGES
when add new permissions, change does not happen immedidately -> flush to make it take place immediately (similar to a refresh)
