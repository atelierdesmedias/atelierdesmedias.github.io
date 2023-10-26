# How to contribute

This site is using [Jekyll](https://jekyllrb.com/docs).

## Install

```
bundle install
npm install
```

## Serve

```
bundle exec jekyll serve --livereload --incremental
```

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
