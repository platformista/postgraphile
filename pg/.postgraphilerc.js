const db = JSON.parse(Buffer.from(process.env.PLATFORM_RELATIONSHIPS, "base64").toString()).pg[0];

module.exports = {
  options: {
    connection: `postgres://${db.username}:${db.password}@${db.host}:${db.port}/${db.path}`,
    // Recommended to be off in production.
    disableQueryLog: process.env.PGRAPHILE_ENABLE_QUERYLOG ? ! process.env.PGRAPHILE_ENABLE_QUERYLOG : process.env.PLATFORM_BRANCH === "main",
    // Recommended to be off in production.
    disableGraphiql: process.env.PGRAPHILE_ENABLE_GRAPHIQL ? ! process.env.PGRAPHILE_ENABLE_GRAPHIQL : process.env.PLATFORM_BRANCH === "main",
    // GraphiQL enhancements.
    enhanceGraphiql: true,
    // You should enable `watch` only in development. First, the watch flag requires either
    // that the app has root access to PostgreSQL for a one-time set up of the feature
    // or the manual set up of the same. Second, the schema on the remotely
    // deployed environments should only be updated via migrations on deployment, thus changes
    // can be applied before the application starts, at which point the correct schema will be loaded.
    watch: process.env.PGRAPHILE_ENABLE_WATCH || (typeof process.env.PLATFORM_BRANCH === "undefined"),
    port: process.env.PORT,
    host: "0.0.0.0",
    simpleCollections: "both",
    graphql: process.env.PGRAPHILE_GRAPHQL_PATH || "/",
    graphiql: process.env.PGRAPHILE_GRAPHIQL_PATH || "/ide",
    legacyRelations: "omit",
    appendPlugins: [
    //   "postgraphile-plugin-connection-filter",
      "postgraphile-plugin-nested-mutations"
    ],
  },
  // The above 'options' is the only key PostGraphile will require.
  // Others are ignored, but still safe to be added. So exporting 'db'
  // here to avoid code duplication.
  db,
};
