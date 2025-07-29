import eslintPluginVue from "eslint-plugin-vue";
import typescriptEslint from "@typescript-eslint/eslint-plugin";
import tsParser from "@typescript-eslint/parser";
import vueParser from "vue-eslint-parser";

export default [
  {
    files: ["**/*.ts", "**/*.vue"],
    languageOptions: {
      ecmaVersion: 2021,
      sourceType: "module",
      parser: vueParser,
      parserOptions: {
        parser: tsParser,
        ecmaVersion: 2021,
        sourceType: "module",
      },
      globals: {
        // optional: define global variables if needed
      },
    },
    plugins: {
      "@typescript-eslint": typescriptEslint,
      vue: eslintPluginVue,
    },
    rules: {
      "@typescript-eslint/no-explicit-any": "off",
      "@typescript-eslint/ban-ts-comment": "off",
      "indent": ["error", 2],
      "linebreak-style": ["error", "unix"],
      "no-undef": "off",
      "quotes": ["error", "double"],
      "semi": ["error", "never"]
    },
  },
];
