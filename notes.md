### Color Schemes & Themes ###
[Official Documentation](https://www.sublimetext.com/docs/3/color_schemes.html)
[Unofficial Documentation](http://docs.sublimetext.info/en/latest/reference/color_schemes.html)

##### Examples: #####
- [Afterglow](http://yabatadesign.github.io/afterglow-theme/)
- [Boxy Theme](https://packagecontrol.io/packages/Boxy%20Theme)
- [A File Icon](https://packagecontrol.io/packages/A%20File%20Icon)



# TODO

#### ESlint/coffeelint
- wait until monorepo, when we can actually have devDependencies

resources:
https://www.npmjs.com/package/@fellow/eslint-plugin-coffee
https://github.com/SublimeLinter/SublimeLinter-eslint
https://eslint.org/docs/user-guide/configuring


SublimeLinter.sublime-settings
```json
{
  "lint_mode": "load_save",
  "linters": {
    "eslint": {
        "selector": "source.coffee, source.cjsx"
    }
  }
}
```

.eslintrc.js
```js
require('@fellow/eslint-plugin-coffee').registerCoffeeLintRule('./node_modules/chalk-linters/rules/jsx_no_comment_on_same_line_as_else.coffee')
require('@fellow/eslint-plugin-coffee').registerCoffeeLintRule('./node_modules/chalk-linters/rules/jsx_no_unnecessary_double_quotes.coffee')

module.exports = {
  "env": {
    "browser": true,
    "commonjs": true,
    "es6": true
  },
  "extends": "./node_modules/chalk-linters/config/coffeelint.config.json",
  // "extends": "eslint:recommended",
  // "globals": {
  //   "Atomics": "readonly",
  //   "SharedArrayBuffer": "readonly"
  // },
  "parser": "@fellow/eslint-plugin-coffee",
  "parserOptions": {
    "parser": "babel-eslint",
    "ecmaFeatures": {
      "jsx": true
    },
    "ecmaVersion": 6
  },
  "plugins": [
    "@fellow/eslint-plugin-coffee",
    "react"
  ],
  "rules": {
  }
};
```
