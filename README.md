# Lightpanda Browser on Railway

Deploy [Lightpanda](https://github.com/lightpanda-io/browser) browser on Railway with one click.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/lightpanda?referralCode=techulus&utm_medium=integration&utm_source=template&utm_campaign=generic)

## About Lightpanda

Lightpanda is an open-source headless browser optimized for server-side automation with 9x less memory usage and 11x faster execution than Chrome.

For detailed information about features, use cases, and capabilities, visit the [official Lightpanda repository](https://github.com/lightpanda-io/browser).

## Deployment

This template deploys the latest nightly build of Lightpanda Browser with the CDP server exposed on port 9222.

### Connecting to Lightpanda

Once deployed, you can connect to your Lightpanda instance from another service in the same project over Railway's private network, using Playwright, Puppeteer, or any CDP-compatible client. The endpoint is `ws://<private-domain>:9222`, e.g. set `LIGHTPANDA_URL=ws://${{lightpanda.RAILWAY_PRIVATE_DOMAIN}}:9222` on your app service.

#### Puppeteer Example

```javascript
const puppeteer = require('puppeteer-core');

const browser = await puppeteer.connect({
    browserWSEndpoint: process.env.LIGHTPANDA_URL
});
const page = await browser.newPage();
await page.goto('https://example.com');
```

#### Host header check

Lightpanda rejects requests (HTTP 403) whose `Host` header isn't an IP address, `localhost`, or the configured advertise host. This template advertises `RAILWAY_PRIVATE_DOMAIN` by default, so connecting via the private domain works out of the box. To connect through a public TCP proxy instead, set the `ADVERTISE_HOST` variable to that proxy's domain (only one host can be advertised at a time).

> ⚠️ The CDP endpoint has no authentication. Prefer the private network and avoid exposing it publicly.

## Technical Details

- **Base Image**: `debian:bookworm-slim`
- **Port**: 9222 (Chrome DevTools Protocol)
- **Binary**: Latest nightly build from [Lightpanda releases](https://github.com/lightpanda-io/browser/releases)
- **Init System**: `dumb-init` for proper signal handling
- **User**: runs as non-root `lightpanda` (uid 1000)
- **Variables**: `ADVERTISE_HOST` (optional, defaults to `RAILWAY_PRIVATE_DOMAIN`)

## Resources

- [Lightpanda GitHub](https://github.com/lightpanda-io/browser)
