// Import the requirements
const { createAgent } = require( '@forestadmin/agent' );
const { createSqlDataSource } = require('@forestadmin/datasource-sql');

// Create your Forest Admin agent
createAgent( {
    // These process.env variables should be provided in the onboarding
    authSecret: process.env.FOREST_AUTH_SECRET,
    envSecret: process.env.FOREST_ENV_SECRET,
    isProduction: process.env.NODE_ENV === 'production',
} )
    .addDataSource(createSqlDataSource(process.env.DATABASE_URL))
    .mountOnStandaloneServer( process.env.PORT )
    .start();