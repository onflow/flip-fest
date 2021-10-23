## Description

This is an i18n solution & language-selection dropdown in navbar with Japanese translation sample based on [gatsby-plugin-react-i18next](https://www.gatsbyjs.com/plugins/gatsby-plugin-react-i18next/) and the [official Gatsby i18n example](https://github.com/gatsbyjs/gatsby/tree/master/examples/using-i18n).

### Language-selection dropdown in navbar

Add a select menu to the navbar using `react-select` and `react-country-flag` libraries.

### I18n solution

The major i18n features are implemented using `react-i18next` plugin.
Translation text is managed in the `src/config/locales/[LANG]/translation.json` file.

eg.)

src/config/locales/ja/translation.json:
```javascript
{
    "subtitle": "モダンな方法で<1>ブロックチェーンを学ぼう</1>",
    "Beta": "ベータ版",
    "Leave Feedback": "フィードバック",
    "Contribute": "貢献する",
    ...
}
```

You can use the <Trans> component to use the translated text.

header.js:
```javascript
import { Trans, useI18next } from 'gatsby-plugin-react-i18next';
...

export default function Header() {
  const {navigate} = useI18next();
  return (
    ...
      <Content onClick={() => navigate('/')}>
        <Title><Highlight>Crypto</Highlight>Dappy</Title>
        <SubTitle><Trans i18nKey="subtitle">The modern way to <Highlight>learn blockchain</Highlight></Trans></SubTitle>
      </Content>
      <Tag>
        <h3 style={{ margin: 0 }}><Trans>Beta</Trans></h3>
        <CTA href="https://forum.onflow.org/t/community-feedback-for-cryptodappy-beta">
          <span style={{ marginRight: ".3rem" }}>👉</span><Trans>Leave Feedback</Trans>
        </CTA>
      </Tag>
    ...
  )
}
```

##### Using mdx based i18n

Prepare a translation file in the form of `[FILENAME].[LANG].mdx` under the `src/missions` folder.

We has created additional Japanese translation files for these.

- contribute.ja.mdx
- FAQ.ja.mdx
- mission-[1-6].ja.mdx
- onboarding.ja.mdx
- overview.ja.mdx
- resources.ja.mdx

##### Translation fallback

We has added the ability to fall back to the default language (en) if there is no corresponding translation in the mdx file for each language.

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

Mapping of URL paths to mdx files:

- https://www.cryptodappy.com/missions/mission-1 -> mission-1.mdx
- https://www.cryptodappy.com/ja/missions/mission-1 -> mission-1.ja.mdx
- https://www.cryptodappy.com/privacy -> privacy.mdx
- https://www.cryptodappy.com/ja/privacy -> privacy.mdx
- https://www.cryptodappy.com/imprint -> imprint.mdx
- https://www.cryptodappy.com/ja/imprint -> imprint.mdx


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
