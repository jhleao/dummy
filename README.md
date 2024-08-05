# Dummy HTTP Server

Dummy HTTP server for testing purposes. Does not require any environment variables to run, and responds to /healthz health check requests. Image also includes `wget` for shell level health checks.

Additional features are ability to test HTTP reachability from application to anything else, and testing environment variable usage.

Application also logs to stdout every 10 seconds, including the current time and the message of the day.

## Environment Variables

- `PORT`: The port on which the server will listen (default: 80)
- `APP_NAME`: The name of app. Used to identify the instance.
- `MOTD`: Message of the Day, included in periodic logs. Purpose is to test environment variable usage.
- `REACH_URL_<number>`: URLs for the `/reach/:number` endpoint (e.g., `REACH_URL_1`, `REACH_URL_2`, etc.). Purpose is testing network reachability (firewall, DNS, internet connection, etc.). Responses are returned to the original request.
