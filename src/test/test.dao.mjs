import { BaseDao } from 'common/base.dao.mjs';

export class TestDao extends BaseDao {
  constructor() {
    super({
      tableName: 'test'
    });
  }
}
