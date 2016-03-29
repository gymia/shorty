Choices
=======

# Purpose of this file

In this file I will explain the rationale of choosing certain technologies/frameworks/libraries.

# Programming Language

I choose to write this url shortener in TypeScript. I am quite experienced with this language, it will help me 
structure the code in Classes and provide static type checking to prevent bugs. These advantages should outweigh the
overhead of the compile step plus the extra work of getting type definitions for all used dependencies.

# Platform

TypeScript/JavaScript leaves little choice with regards to a backend platform: NodeJS.

# API Framework

Because the challenge asks for the implementation of an HTTP API I pick the Restify NodeJS module to reduce the 
boilerplate and aid in structuring the code. I could have chosen a more low-level framework, like Express, or a more 
extensive one like Loopback. But I picked Restify because it provides just the right amount of functionality without 
getting in the way.

# Testing

- Unit tests will be written that directly test the public methods of the TypeScript classes.
- E2E tests will be written that call the HTTP endpoints of the service.

## Framework

Mocha because this is the most used testing framework for NodeJS

## Assertion Library

Chai, because with the `expect` interface this is the most similar to Jasmine, which I'm familiar with.

## Mocking Framework

Sinon, because it is widely used. And I have some experience with it.

## Test runners

- Mocha
- WallabyJS, used for development because it gives instant feedback on Unit Tests
