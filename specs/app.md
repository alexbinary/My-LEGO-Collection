
# Application


## Specification

The app embeds a SQLite database file that contains all the LEGO colors and parts from the Rebrickable API as a bundle resource.

The app loads all colors and parts from the database and presents them in two lists accessible with a tab bar.


## Technical specifications

Features are broken into three main areas:

- use an embedded database from the bundle resources
- show a list of LEGO colors
- coordinate database management and data presentation

A database controller offers the following features:

- manage a connection to the database
- read data from the database

A UI layer offers the following features:

- present a list of LEGO colors and a list of LEGO parts
- present a tab bar to switch between the lists

An app-level controller offers the following features:

- locate the database file in the bundle resources
- load data from the database file
- present the user interface
- inject data from the database into the user interface


## TODO

- [x] update the database to include parts
- [x] create data models for parts
- [x] update the database controller to retrieve parts
- [ ] update the UI layer to show a tab bar and add a list of parts
- [ ] update the app controller to load and present the parts
