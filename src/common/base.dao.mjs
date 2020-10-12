import mysql from 'mysql';
import util from 'util';

import { config } from 'config/config.mjs';

class BaseDao {
  constructor(daoConfig = {}) {
    this.daoConfig = daoConfig;
    this.tableName = this.daoConfig?.tableName;
    this.enableLogs = config.enableLogs;

    if (!this.daoConfig?.tableName) {
      throw new Error('❌ tableName property is mandatory.');
    }

    this.pool = mysql.createPool({
      connectionLimit: config?.database?.connectionLimit,
      host: config?.database?.host,
      user: config?.database?.user,
      password: config?.database?.password,
      database: config?.database?.database
    });

    this.pool.query = util.promisify(this.pool.query);

    this.select = this.select.bind(this);
    this.save = this.save.bind(this);
    this.byId = this.byId.bind(this);
    this.all = this.all.bind(this);
  }

  getPool() {
    return this.pool;
  }

  all() {
    return this.pool.query('SELECT * FROM ??', [this.tableName]);
  }

  select(selectKeys) {
    if (!selectKeys) {
      throw new Error('❌ selectKeys argument is mandatory.');
    }

    let sql = `SELECT * FROM ${this.tableName} WHERE `;

    if (selectKeys) {
      const length = Object.keys(selectKeys).length;
      const pool = this.pool;

      Object.keys(selectKeys).forEach((key, index) => {

        sql += `${key} = ${this.pool.escape(selectKeys[key])}`;

        if (++index < length) {
          sql += ' AND ';
        }
      });
    }

    if (this.enableLogs) {
      console.log(sql);
    }

    return this.pool.query(sql);
  }

  save(entity) {
    let sql;

    if (entity.id) {
      sql = 'UPDATE ?? SET ? WHERE id = ?'
    } else {
      sql = 'INSERT INTO ?? SET ?';
    }

    if (this.enableLogs) {
      console.log('=> PERSISTING WITH QUERY ', sql);
    }

    return this.pool.query(sql, [this.tableName, entity, entity.id]);
  }

  byId(id) {
    const query = `SELECT * FROM ?? WHERE id = ?`;
    return this.pool.query(query, [this.tableName, id]);
  }

  delete(id) {
    const query = `DELETE FROM ?? WHERE id = ?`;
    return this.pool.query(query [id]);
  }
}

export { BaseDao };
