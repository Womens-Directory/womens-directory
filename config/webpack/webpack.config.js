const { webpackConfig, merge } = require("shakapacker");
const vueConfig = require("./rules/vue");

module.exports = merge(vueConfig, webpackConfig);
