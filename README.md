# Experimental module-creator 🚀

## Description

This is an experimental bash script that helps to create new endpoints (module) with some common resources a developer always create, with a base code. As a plus, it detects whether your project is not a Node JS app and runs `npm init` for you.

## How to start

1. Clone this repository `git clone git@github.com:amhhernandez/nodejs-scaffolder.git`.
2. Run `./module-creator.sh <module_name>` under `helpers` directory.

**Note:** if there's no configuration detected, a wizard will be triggered before creating the new endpoint (module), making you able to configure the following features:

* A basic jwt configuration and database configurations (just for fun).
* A database configuration (for now mysql is supported).

## Main functionality

It will create a new endpoint under `src/folder` with the following files:

* `module.controller.mjs`
* `module.routes.mjs`
* `module.dao.mjs`
* `module.service.mjs` (optional)

For dao files, the script will ask the name of your table name so it can create a correct file to fetch your infro from database.

## Data Access Object

I've created a very simple database layer class that helps to perform the very basic queries a developer can make, I promise I will update this section soon 🤚🏻. For now just extend your class from `BaseDao`.

## Limitations

1. The scaffolder does not create an index file for you, I'm still trying to figure out how to add the generated routes without messing your existing code.
2. It's not possible to create new routes or any other function inside the layers (Remember, I'm generating a barely base code so you can start without any effort).
3. I'm following the ES6 standards as much as possible, this means I'm using the `import {}  from '...'` convention and class-based modules. This means you'll not be able to find any `require(module)` or function-based routes/controllers/services/dao.
4. I'm using only mysql, but if you want to add support to more database management systems, you're free to go! 😎
5. Windows is definitely not supported unless you have WSL well configured in your Windows machine, sorry guys! 💔

## Disclaimer

I'm not a bash coder, I made it just for fun, so if you feel something needs to be improved, go for it! :)
