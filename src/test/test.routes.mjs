import { Route, RouterProcessor } from 'common/router.mjs';
import { TestController } from './test.controller.mjs'

class TestRouterProcessor extends RouterProcessor {
  constructor() {
    super('test');
  }

  getRoutes() {
    const testController = new TestController();

    return [
      new Route('/', Route.GET, testController.get),
      new Route('/', Route.POST, testController.save),
      new Route('/:testId', Route.DELETE, testController.delete)
    ];
  }
}

const testRouteProcessor = new TestRouterProcessor();
const testRoutes = testRouteProcessor.router;

export { testRoutes };
