Reflections
===========

# Purpose of this file

In this file I will reflect on the implementation of the challenge, and explain what I would like to improve.

# The implementation

This was the first project I did in NodeJS using Unit and E2E tests. I really liked this approach.
At the end it was really easy to make changes everywhere without worrying to much about breaking things.

I did not implement a real, persistent datastore. But I did use a TypeScript interface for the storage layer. So it should be
possible to implement one without changing any code apart from the index.ts file.

# Points I would improve if I had more time

1. Solve the real problem that causes the need for `.bind(ctrl)` where the routes are specified
2. Use a dependency injection / inversion of control library to inject the dependencies into classes instead of
initializing everything in index.ts
3. Refactor the Route configuration out of the index.ts so it can be Unit Tested 
4. Remove code duplication in the test files
