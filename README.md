# Experimental module-creator 🚀

## Prerequisites
* NodeJS v14 or earlier.
* A unix-based OS.

## Description

This is an experimental bash script that helps to create new endpoints (module) with some of the common resources a developer always create, with a base code. As a plus, it detects whether your project is not a Node JS app and runs `npm init` for you.

## How to start

1. Clone this repository `git clone git@github.com:amhhernandez/nodejs-module-creator.git`.
2. Run `./module-creator.sh <module_name>` under `helpers` directory.

**Note:** If there's no configuration detected, a wizard will be triggered before creating the new endpoint (module), making you able to configure the following features:

* A basic jwt configuration and database configurations (just for fun).
* A database configuration (for now only mysql is supported).

## Main functionality

It will create a new endpoint under `src/folder` with the following files:

* `module.controller.mjs`
* `module.routes.mjs`
* `module.dao.mjs`
* `module.service.mjs` (optional)
* It updates/create your `index.mjs` [new feature 🥳🎉]: This means you don't have to worry, we'll create an index file for you if not present. Also, we'll append your new routes on it.

For dao files, the script will ask the name of your table name so it can create a correct file to fetch your infro from database.

## Data Access Object

I've created a very simple database layer class that helps to perform the very basic queries: `select` (with criteria), `all()`, `byId`, `save`, `update`, `delete`.

### How to use each method:

First, if you want to create a new DAO manually, you need to import `base.dao` class, then extend it:

```javascript
import { BaseDao } from '../common/base.dao.mjs';

export class MyDao extends BaseDao {
  constructor() {
    super({ tableName: 'table_name' }); // This line is mandatory
  }
}
```

As you probably noticed, we're passing the table name through the `super` constructor, this is helpful to be able to perform any query through the BaseDao functions.

#### Data selection

The `select(criteria)` function allows to perform a basic select (no joins, no cross product) with a given criteria object. For now it only supports equality operations:

Having the following DAO implementation:

```javascript
import { BaseDao } from '../common/base.dao.mjs';

export class CompanyDao extends BaseDao {
  constructor() {
    super({ tableName: 'company' });
  }
}
```

and calling:

```javascript
const companyDao = new CompanyDao();

const company = await companyDao.select({
  city: 'New York',
  offersHomeOffice: true
});
```

This will generate the following SQL statement: `SELECT * FROM company WHERE city = 'New York' AND offersHomeOffice = true`.

#### Comparison opreations: equal to, greather than (or equal), less than (or equal).

The previous snippet showed us how to perform basic equality operations. There are some cases where we need to add a little bit more complexity to our
sql statements. Let's see the following example:

```javascript
const companyDao = new CompanyDao();

const company = await companyDao.select({
  city: 'New York',
  offersHomeOffice: true,
  greatherThan: {
    employees: 250,
    greatPlaceToWorkAverage: 8, // average > 8 out of 10
    haloTournamentsPerYear: 5
  },
  lessThan: {
    employees: 500
  }
});
```

This call will generate the following SQL statment (in order of appearance):

```sql
SELECT * FROM company
WHERE
  city = 'New york'
  AND offersHomeOffice = true
  AND employees > 250
  AND greatPlaceToWorkAverage > 8,
  AND haloTournamentsPerYear > 5
  AND employees < 500
```

You can also add `>=` and `<=` conditions with:

```javascript
const companyDao = new CompanyDao();

const company = await companyDao.select({
  greatherOrEqualTo: {
    greatPlaceToWorkAverage: 8, // average >= 8 out of 10
    employes: 100
  },
  lessOrEqualTo: {
    employees: 500
  }
});
```

### SQL Builder

If you need the SQL query instead of executing a SQL statement, you can call `getSQLQuery(criteriaObject)` function, it works with the same options as the `select` function.

## Limitations

1. ~The scaffolder does not create an index file for you, I'm still trying to figure out how to add the generated routes without messing your existing code.~
2. ~It's not possible to create new routes or any other function inside the layers (Remember, I'm generating a barely base code so you can start without any effort).~
3. I'm following the ES6 standards as much as possible, this means I'm using the `import {}  from '...'` convention and class-based modules. This means you'll not be able to find any `require(module)` or function-based routes/controllers/services/dao.
4. I'm using only mysql, but if you want to add support to more database management systems, you're free to go! 😎
5. OR operations are not implemented for now, but you can call `getSQLQuery(criteriaObject)` and add anything you want on it.
6. Windows is definitely not supported unless you have WSL well configured in your Windows machine, sorry guys! 💔

## Disclaimer

I'm not a bash coder, I made it just for fun, so if you feel something needs to be improved, go for it! :)
