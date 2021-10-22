# hichana submission for milestone #3, FLIP issue #20

Thank you for reviewing my submission for FLIP issue #29 milestone: "3. Add support for new features on both the frontend and backend.". Before providing instructions and a screenshot-walkthrough, some notes:

- I have chosen to submit this final milestone as early as possible and using remaining time to continue soliciting feedback and iteratively improving my solition wherever possible right up until the deadline of the flip fest.
- I did minor refactoring and updates where needed to ensure new features function as expected
- I attempted to align all code style, element styling, etc. with what exists in the codebase currently. Most importantly I did my best to build the feature set, yet do so within the existing look and feel of the playground.
- did not introduce any unecessary third-party libraries. For example, when creating the toast feature, I could have npm-installed a pre-built library for a quick solution, however it likely would have been difficlut to enforce styling continuity, it would have increased the bundle size, and might have posed a numbe of other problems. Instead, I used framer-motion (which we already use) to build a simple yet well-functioning toast. Below are some examples of libraries which I investigated but chose not to use.
    https://www.npmjs.com/package/react-toastify
    https://www.npmjs.com/package/react-simple-toasts- 


### Screenshot walkthrough