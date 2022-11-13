# How to contribute

This site is using [Jekyll](https://jekyllrb.com/docs).

## Install

```
bundle install
npm install
```

## Serve

```
bundle exec jekyll serve
```

## Facebook event

- Setup page id in `.github/workflows/deploy.yml`
- Setup application: <https://stackoverflow.com/questions/17197970/facebook-permanent-page-access-token>

The facebook token has to be refresh according to this link: <https://developers.facebook.com/docs/facebook-login/access-tokens/refreshing/>

## VSCode configuration

These plugin will help writing CSS respecting the rules: <https://marketplace.visualstudio.com/items?itemName=stylelint.vscode-stylelint>

Here is the configuration:

```json
{
    "editor.codeActionsOnSave": {
        "source.fixAll.stylelint": true
    },
    "stylelint.validate": [
        "css",
        "less",
        "postcss",
        "scss"
    ]
}
```
