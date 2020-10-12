import { TestDao } from './test.dao.mjs';

/**
 * Is not recommended to use the DAO layer directly in the controller.
 * We recommend to create this module with a service layer so you can handle
 * your logic plus your data access inside it.
 */
export class TestController {
  constructor() {
    this.testDao = new TestDao();
  }

  // Start your code here. Happy coding!
  async get(req, res) {
    try {
      const testList = this.testDao.all();

      res.json({
        result: testList
      });
    } catch (error) {
      res.status(500).json({
        message: 'Internal server error'
      });
    }

  }

  save(req, res) {
    try {
      const test = req.body;
      this.testDao.save(test);

      res.json({
        message: 'OK!'
      });
    } catch (error) {
      res.status(500).json({
        message: 'Internal server error'
      });
    }
  }

  async delete(req, res) {
    try {
      const testId = await this.testDao.byId(req.params.testId);
      this.testDao.delete(testId);

      res.json({
        message: 'deleted'
      });
    } catch (error) {
      res.status(500).json({
        message: 'Internal server error'
      });
    }
  }
}
