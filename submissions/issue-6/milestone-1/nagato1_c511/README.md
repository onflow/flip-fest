## CryptoDappy Feature: localization (I18n) solution - Milestone 1

## Description

This PR is for issue #6.

## Submission Links & Documents

1) Implementing minimum necessary i18n functionality based on the `gatsby-i18n` example.
- PR: https://github.com/bebner/crypto-dappy-learning-hub/pull/5
- Doc: [gatsby-i18n-example.md](gatsby-i18n-example.md)

2) Implementing some functionality to manage mdx translation files with using the `react-i18next` plugin
- PR: https://github.com/bebner/crypto-dappy-learning-hub/pull/6
- Doc: [react-i18next.md](react-i18next.md)

### Milestone Requirements

- Language-selection dropdown in navbar
- I18n solution

Screenshot:
![i18n dropdown screenshot](cryptodappy-i18n-dropdown.png)

### Software Requirements

#### Testing

We have manually verified these test cases:

- Make sure that the language selection menu links to the correct localized page.
- Make sure that the links in the localized pages are in the same language setting.
- Make sure the translated text is displayed correctly if exists.

### Other Requirements

#### Documentation of the steps taken

- Implementation of localization functions based on official gatsby samples
- Preparing the Japanese translation text
- Checking the operation of the localization functions
- Improving the localization functions

## Additional works

- Japanese translation
- Json translation with HTML tag/React component
- Translation fallback
- Integration with the react-i18next plugin

## Requirements Check

- Have have you met the milestone requirements? Yes
- Have you included tests (if applicable)? Testing manually
- Have you met the contribution guidelines of the repos you have submitted code to (if applicable)? Yes
- If this is the last milestone:
  - Demonstrate that you've met all the acceptance criteria (link to code, demos, instructions to run etc.)
  - Demonstrate that you've met all milestone requirements and highlight any extensions or additional work done.
  - Include a payout structure by percentage for each team member (ie. Bob: 20%, Alice: 80%). Yes

### Payout structure

- @knagato: 100%
- @avcdsld: 0%
- @wshino: 0%

## Other Details

### References

- [Official Gatsby i18n example](https://github.com/gatsbyjs/gatsby/tree/master/examples/using-i18n)
- [Gatsby doc: Localization and Internationalization](https://www.gatsbyjs.com/docs/how-to/adding-common-features/localization-i18n/)
- [CryptoDappy issue: Content Translations](https://github.com/bebner/crypto-dappy-learning-hub/issues/2)
- [CryptoDappy PR: Vietnamese translations](https://github.com/bebner/crypto-dappy-learning-hub/pull/4)

