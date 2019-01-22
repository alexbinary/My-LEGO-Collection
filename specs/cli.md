
# Database command line tool


## Specifications

The program takes no arguments and performs the following tasks:

- create an empty SQLite database file in the current directory, fail if file exists
- create tables for colors and parts
- retrieve colors and parts from the Rebrickable API
- insert colors and parts into the table

The database data model should not be tied to the Rebrickable data model.


## Technical specifications

Features are broken into three main areas:

- manage and interreact with a database file
- retrieve data from the Rebrickable API
- coordinate database management, data retrieval and database insertions

A database controller offers the following features:

- check for the existence of a database file
- manage a connection to a new database file
- create a table in the database
- insert multiple rows in the database

A client for the Rebrickable API offers the following features:

- manage an API key
- make requests to the appropriate endpoints
- decode the data into a usable form

An app-level controller offers the following features:

- determine where on the disk the database file should be
- manage configurations
- coordinate database management, data retrieval and database insertions


## TODO

- [x] update the Rebrickable API client to support retrieval of parts
- [x] update the database controller to support the insertion of parts
- [x] update the app controller to retrieve parts and insert the data in the database
