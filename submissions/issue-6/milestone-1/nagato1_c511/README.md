## CryptoDappy Feature: localization (I18n) solution - Milestone 1

## Description

This PR is for issue #6.

## Submission Links & Documents

https://github.com/bebner/crypto-dappy-learning-hub/pull/5

### Milestone Requirements

#### Language-selection dropdown in navbar

Add a select menu to the navbar using `react-select` and `react-country-flag` libraries.

Screenshot:
![i18n dropdown screenshot](cryptodappy-i18n-dropdown.png)

#### I18n solution

Based on the [official Gatsby i18n example](https://github.com/gatsbyjs/gatsby/tree/master/examples/using-i18n), we have implemented a page-by-page translation function using mdx files and a sentence-by-sentence translation function using `[LANG].json` files.

##### Using mdx based i18n

Prepare a translation file in the form of `[FILENAME].[LANG].mdx` under the `src/missions` folder.

##### Using  json based i18n

Prepare a translation file in the form of `[LANG].json` under the `src/config/translations` folder.

eg.)

ja.json:
```javascript
{
    "subtitle": "モダンな方法で<Highlight>ブロックチェーンを学ぼう</Highlight>",
    "beta": "ベータ版",
    "feedback": "フィードバック",
    "contribute": "貢献する",
    "index_title": "CryptoDappyでブロックチェーンを学ぼう",
    ...
}
```

To use the translated text in the page, use the `useTranslations` component.

index.js:
```javascript
import * as React from "react"
import useTranslations from "../components/useTranslations"

const IndexPage = () => {
  const { index_title } = useTranslations

  return (
    ...
    <h1>{index_title}</h1>
    ...
  )
}
```

##### Localized Link & Navigate

Links in the site will be converted into pages according to the current selected language using the `LocalizedLink` and `localizedNavigate` components.

navbar.js:
```javascript
<NavLink>
  <Dappy src={`${config.ASSETS_URL}/images/Dappy${i + 1}.png`} />
  <LocalizedLink to={m.link}>{m.name}</LocalizedLink >
</NavLink>
```

```javascript
<Button onClick={() => localizedNavigate('/contribute', lang)}>Contribute</Button>
```

##### Edit i18n options

To add or change a language setting, edit `config/i18n.js`.

```javascript
module.exports = {
  defaultLang: 'en',
  langs:{
    en: {
      path: `en`,
      name: 'English',
      countryCode: 'GB',
    },
    vn: {
      path: `vn`,
      name: 'Tiếng Việt',
      countryCode: 'VN',
    },
    ja: {
      path: `ja`,
      name: '日本語',
      countryCode: 'JP',
    },
  }
}
```

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
- Improving the localization functions (see Additional works)

## Additional works

In addition to the official Gatsby sample, we have implemented the following additional features.

### Japanese translation

Our team has created additional Japanese translation files for these.

- contribute.ja.mdx
- FAQ.ja.mdx
- mission-[1-6].ja.mdx
- onboarding.ja.mdx
- overview.ja.mdx
- resources.ja.mdx
- ja.json

### Json ranslation with HTML tag/React component

Our team has implemented an additional function that allows you to use html tags and React components in the translated text in `[LANG].json`.

eg.)

en.json:
```javascript
{
    ...
    "subtitle": "The modern way to <Highlight>learn blockchain</Highlight>",
    ...
    "index_p1": "CryptoDappy is a <strong>mission-based online course</strong> directed at developers who want to get started learning blockchain development.",
}
```

index.js:
```javascript
import useTranslations from "../components/useTranslations"
import parse from 'html-react-parser';

const IndexPage = () => {
  const {index_p1} = useTranslations()
  ...
  return (
    ...
    <p>{parse(index_p1)}</p>
    ...
  )
}
```

header.js:
```javascript
import useTranslations from "./useTranslations"
import parse, { domToReact } from 'html-react-parser';

export default function Header() {
  const { subtitle } = useTranslations()
  const replace = (node) => {
    if(node.type ==="tag" && node.name === "highlight"){ return <Highlight>{ domToReact(node.children) }</Highlight> }
  }

  return (
    ...
    <SubTitle>{parse(subtitle, { replace })}</SubTitle>
    ...
  )
}

const Highlight = styled.span`
  color: yellow;
  word-break: break-all;
`
```

### Translation fallback

Our team has added the ability to fall back to the default language (en) if there is no corresponding translation in the mdx file or `[LANG].json` for each language.

#### Mdx fallback example

In case of privacy.en.mdx and imprint.en.mdx do not exist.

```
src
└── missions
    ├── mission-1.ja.mdx
    ├── mission-1.mdx
...
    ├── privacy.mdx
    └── imprint.mdx
```

Mapping of URL paths to mdx files

- https://www.cryptodappy.com/missions/mission-1 -> mission-1.mdx
- https://www.cryptodappy.com/ja/missions/mission-1 -> mission-1.ja.mdx
- https://www.cryptodappy.com/privacy -> privacy.mdx
- https://www.cryptodappy.com/ja/privacy -> privacy.mdx
- https://www.cryptodappy.com/imprint -> imprint.mdx
- https://www.cryptodappy.com/ja/imprint -> imprint.mdx

#### Json fallback example

In case of the {title} key is present in `en.json` but not in `ja.json`.

en.json:
```javascript
{
    "title": "<Highlight>Crypto</Highlight>Dappy",
    "subtitle": "The modern way to <Highlight>learn blockchain</Highlight>",
    ...
}
```

ja.json:
```javascript
{
    "subtitle": "モダンな方法で<Highlight>ブロックチェーンを学ぼう</Highlight>",
    ...
}
```

The value of the {title} key always refers to the value of title in `en.json`.

## Requirements Check

- Have have you met the milestone requirements? Yes
- Have you included tests (if applicable)? Testing manually
- Have you met the contribution guidelines of the repos you have submitted code to (if applicable)? Yes
- If this is the last milestone:
  - Demonstrate that you've met all the acceptance criteria (link to code, demos, instructions to run etc.)
  - Demonstrate that you've met all milestone requirements and highlight any extensions or additional work done.
  - Include a payout structure by percentage for each team member (ie. Bob: 20%, Alice: 80%). Yes

### Payout structure

- @knagato: 33.33%
- @avcdsld: 33.33%
- @wshino: 33.33%

## Other Details

### References

- [Official Gatsby i18n example](https://github.com/gatsbyjs/gatsby/tree/master/examples/using-i18n)
- [Gatsby doc: Localization and Internationalization](https://www.gatsbyjs.com/docs/how-to/adding-common-features/localization-i18n/)
- [CryptoDappy issue: Content Translations](https://github.com/bebner/crypto-dappy-learning-hub/issues/2)
- [CryptoDappy PR: Vietnamese translations](https://github.com/bebner/crypto-dappy-learning-hub/pull/4)

### Discussion

In this PR, we have extended the implementation of the official Gatsby sample without using the i18n framework following the description from [CryptoDappy issue #2](https://github.com/bebner/crypto-dappy-learning-hub/issues/2).

> We'll be implementing an I18n solution like this one, not using any additional I18n framework. This means only translated versions of the .mdx files have to be created.

In the official Gatsby sample, when you manage translated text using `[LANG].json`, you need to write down all keys to graphql in the useTranslations component.

useTranslations.js:
```javascript
...
const query = graphql`
  query useTranslations {
    rawData: allFile(filter: { sourceInstanceName: { eq: "translations" } }) {
      edges {
        node {
          name
          translations: childTranslationsJson {
            title
            subtitle
            beta
            feedback
            contribute
            index_title
            index_p1
            index_p2
            index_p3
            onboarding_title
            onboarding_text
            mission1_title
            mission1_text
            mission2_title
            mission2_text
            mission3_title
            mission3_text
            mission4_title
            mission4_text
            mission5_title
            mission5_text
            mission6_title
            mission6_text
          }
        }
      }
    }
  }
`
```

As the amount of translated text increases, managing these becomes more complicated, so we may want to consider introducing i18n plugins such as [gatsby-plugin-react-i18next](https://www.gatsbyjs.com/plugins/gatsby-plugin-react-i18next/) for more efficient management.
