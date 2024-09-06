# PostGraphile template for Platform.sh

<p align="center">
<a href="https://console.platform.sh/projects/create-project?template=https://raw.githubusercontent.com/platformista/postgraphile/main/template-definition.yaml&utm_content=strapi&utm_source=github&utm_medium=button&utm_campaign=deploy_on_platform">
    <img src="https://platform.sh/images/deploy/lg-blue.svg" alt="Deploy on Platform.sh" width="180px" />
</a>
</p>

PostGraphile (formerly PostGraphQL) builds a powerful, extensible and performant GraphQL API from a PostgreSQL schema in seconds.

## Features

- [Node.js 20](https://nodejs.org/en/)
- [PostGraphile 4](https://www.graphile.org/postgraphile)
- [PostgreSQL 16](https://www.postgresql.org/)

## Interacting with the database

Once PostGraphile is deployed on platform.sh, it will be running off an empty database (`public.main`). You can interact with this database in different ways, which all assume that you have installed and configured the [platform.sh CLI](https://docs.platform.sh/administration/cli.html), and that you have checked out the project locally via `platform get`. 

### Populate the database

```shell
$ platform sql < /path/to/dump.sql
```

NOTE: make sure the dump does not create the database in a schema other than `public`.

### SSH into the project

From your local checkout of the newly created project:
```shell
$ platform ssh
``` 

Once in, you can use `psql` to access the database. The database credentials can be retrieved from the environment, like so: 

```shell
$ echo $PLATFORM_RELATIONSHIPS | base64 -d | jq ".pg"
```

### Open a local tunnel to the database

Please, see the [documentation](https://docs.platform.sh/development/local/tethered.html) for this.

## Enhanced GraphiQL available

[GraphiQL](https://github.com/graphql/graphiql/tree/main/packages/graphiql) is a graphical interactive in-browser GraphQL IDE. It is bundled with PostGraphile, and this template makes it available at `/ide`. This path can be modified by setting the environment variable `PGRAPHILE_GRAPHIQL_PATH`.

GraphiQL is enabled automatically on all non-production environment, and disabled by default on the production environment. You can enable/disable it by setting the environment variable `PGRAPHILE_ENABLE_GRAPHIQL`.

The version of GraphiQL bundled with PostGraphile comes with some optional enhancements that are enabled by default in this template.

## Environment-controlled configuration

We have chosen to use `.postgraphilerc.js` to store PostGraphile configuration. We have also chosen to expose some of this configuration to environment variables, so that some changes could be made without changing the codebase. These are the environment variables supported so far: 

| Variable                    | Type   | Default value | Other values                           | Description                                                                                                                        |
|-----------------------------|--------|---------------|----------------------------------------|------------------------------------------------------------------------------------------------------------------------------------|
| `PGRAPHILE_ENABLE_QUERYLOG` | `String` | `null`        | `true` or `false`                      | Enable/disable the query log. Disabled in production by default; controlled by the environment variable on all other envs.         |
| `PGRAPHILE_ENABLE_GRAPHIQL` | `String` | `false`       | `true` or `false`                      | Enable/disable GraphiQL. Disabled in production by default; enabled by default on non-prod; tweakable by the environment variable. |
| `PGRAPHILE_ENABLE_WATCH`    | `String` | `false`       | `true` or `false`                      | Enable/disable watch mode. Disabled by default everywhere; controlled by the environment variable.                                 |
| `PGRAPHILE_GRAPHQL_PATH`    | `String` | `/`           | A string representing a valid URI path | The path of the GraphQL service.                                                                                                   |
| `PGRAPHILE_GRAPHIQL_PATH`   | `String` | `/ide`        | A string representing a valid URI path | The path of the GraphiQL IDE.                                                                                                      |

With platform.sh, you can set variables both at the project level and at the environment level. For instance, 

```shell
$ platform variable:create --level project --name foo --value bar --prefix env # The prefix 'env' is necessary so that the variable is set like a standard environment variable. 
```

For further details on how to set environment variables on a platform.sh project, please refer to the [documentation](https://docs.platform.sh/development/variables/set-variables.html). 
