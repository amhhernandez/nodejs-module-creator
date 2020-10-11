## Experimental scaffolder 🚀

This is an experimental bash script that helps to create new endpoints with some common resources a developer always create, with a code base. As a plus, it detects empty projects and helps to create a configuration file with the following features:

* A basic jwt configuration and database configurations.
* A database configuration (for now we support mysql).

Run `./module-creator.sh <module_name>` under `helpers` directory.

It will create a new endpoint under `src/folder` with the following files:

* `module.controller.mjs`
* `module.routes.mjs`
* `module.dao.mjs`
* `module.dao.mjs` (optional)

For dao files, the script will ask the name of your table name so it can create a correct file to fetch your infro from database.

**Note:** if there's no configuration detected, a wizard will be triggered before creating the new endpoint (module). You'll be able to configure jwt and database information.

## Limitations

1. The scaffolder does not create an index file for you, I'm still trying to figure out how to add the generated routes without messing your existing code.
2. It's not possible to create new routes or any other function inside the layers (Remember, I'm generating a barely base code so you can start without any effort).
3. I'm following the ES6 standards as much as possible, this means I'm using the `import {}  from '...'` convention and class-based modules. This means you'll not be able to find any `require(module)` or function-based routes/controllers/services/dao.
4. I'm using only mysql, but if you want to add support to more database management systems, you're free to go! 😎
5. Windows is definitely not supported unless you have WSL well configured in your Windows machine, sorry guys! 💔
