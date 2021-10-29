## Description
Thank you for reviewing our final submission for "JS Testing Feature: Multiple return values from interaction" FLIP #30. Our solution features:
- a tuple as the return type from `sendTransaction` and `executeTransaction`, which also provides error messaging to other functions in the library that implement them.
- refactored library interal methods to facilitate the new return types, including jest helper functions
- refactored tests 
- updated all relevant documentation

Initially, our solution was a non-breaking change. We did this by adding a new section in 'flow.json' that could be set to true or false by the developer to decide on whether they wanted to use the new return types or not. There was also a way to pass a bool to the initialization for this same purpose. Internally, we then grabbed the configuration boolean and conditionally returned the old or new functions as per the user's preference. Ultimately we decided that it wasn't beneficial for the users or maintainers of the library for the following reasons:
- maintainers would have to manage either two sets of tests, or one set with conditional logic based on whether the user has chosen the new return types or the old ones. Once the old functions were finally deprecated completely the maintainer would then need to update all of the tests.
- maintainer would need to update flow.json, config() and the jest helpers as well once the change has been deprecated
- maintainer would need to update the documentation more than necessary with simply having a single breaking change
- users of the library might need to grasp more usage instructions from the documentation to understand the differences between the old and new way of using the functionality
- if maintainers chose to require it, at some point in the future, legacy users of the library would need to upgrade to the new methods anyways
- because the new approach is a relatively simple change to the codebase, we believe it's not an unreasonalbe burdon to place on users of the library. Our updates to the documentation, along with notes we've added to CHANGELOG.md. If our solution is chosen as the winner we recommend copying this to the 'Releases' section (https://github.com/onflow/flow-js-testing/releases) and/or putting it in the README.md of the library


