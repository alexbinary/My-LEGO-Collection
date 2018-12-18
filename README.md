#  My LEGO Collection

> ⚠️ Work in progress


## Ultimate goal

An iPhone and iPad app where you can browse LEGO sets and parts and manage sets and parts lists, just like [Rebrickable](https://rebrickable.com/) but with more features, and really fast thanks to an embedded SQLite database.

The database is seeded with data from Rebrickable and other sources, and maintained up to date with regular over-the-air updates.

A built-in, super easy to use 3D designer lets you explore and manipulate parts and create virtual LEGO builds.


## Current situation

A simple app where you can browse a list of LEGO part colors, using an embedded database seeded with data from Rebrickable.

A command line tool retrieves data from the [Rebrickable API](https://rebrickable.com/api/v3/docs/) and creates a SQLite database file that then gets embedded into the app as a bundle resource.


## Current objective

Add parts. The list should show the picture of the part provided by rebrickable.


## TODO

- [x] update [specs for the command line tool](specs/cli.md)
- [x] update [specs for the app](specs/app.md)
- [ ] update the command line tool
- [ ] update the app
