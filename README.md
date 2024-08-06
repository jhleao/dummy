# Dummy HTTP Server

Dummy HTTP server for testing purposes. Does not require any environment variables to run and responds to `/healthz` health check requests.

Optional features:

- `wget` is installed on image for shell level health checks.

- HTTP reachability test from application to anything else.

- Testing environment variable usage from AWS SSM using [aws-env](https://github.com/Droplr/aws-env)

- Logging to stdout every 10 seconds, including the current time and the message of the day (`MOTD` env). Useful for testing log analysis setups.

## Environment Variables

- `PORT`: The port on which the server will listen (default: 80)
- `AWS_REGION`: The AWS region to use for AWS SSM Parameter Store.
- `ENV_SLUG`: The environment slug to use for AWS SSM Parameter Store.
- `APP_NAME`: _(optional)_ The name of app. Used to identify the instance.
- `MOTD`: _(optional)_ Message of the Day, included in periodic logs. Purpose is to test environment variable usage.
- `REACH_URL_<slug>`: _(optional)_ URLs for the `/reach/:slug` endpoint (e.g., `REACH_URL_APP1`, `REACH_URL_INTERNET`, etc.). Purpose is testing network reachability (firewall, DNS, internet connection, etc.). Responses are returned to the original request.

## SSM Parameter Store testing

All of `AWS_REGION`, `ENV_SLUG` and `APP_NAME` are required for the SSM Parameter Store testing to work. SSM parameters are expected to be in the following format:

```
/<env_slug>/<app_name>/<variable_name>
```

Additionally, any parameters starting with `/<env_slug>/common/` will be loaded as well.
