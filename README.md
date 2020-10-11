## Experimental scaffolder

This is an experimental bash script that helps to create new endpoints with some common resources a developer always create, with a code base. As a plus, it detects empty projects and helps to create a configuration file with the following features:

* A basic jwt configuration and database configurations.
* A database configuration (for now we support mysql)



Run `./module-creator.sh <module_name>` under `helpers` directory (without hyphens).

It will create a new endpoint under `src/folder` with the following files:

* `module.controller.mjs`
* `module.routes.mjs`
* `module.dao.mjs`
* `module.dao.mjs` (optional)

For dao files, the script will ask the name of your table name so it can create a correct file to fetch your infro from database.

**Note:** if there's no configuration detected, a wizard will be triggered before creating the new endpoint (module). You'll be able to configure jwt and database information.

**Note #2:** hyphened-modules are not supported yet on MacOS versions. Windows is definitely not supported, sorry guys, be cooler!
