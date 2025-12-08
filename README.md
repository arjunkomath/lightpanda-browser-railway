# Lightpanda Browser on Railway

Deploy [Lightpanda](https://github.com/lightpanda-io/browser) browser on Railway with one click.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/lightpanda?referralCode=techulus&utm_medium=integration&utm_source=template&utm_campaign=generic)

## About Lightpanda

Lightpanda is an open-source headless browser optimized for server-side automation with 9x less memory usage and 11x faster execution than Chrome.

For detailed information about features, use cases, and capabilities, visit the [official Lightpanda repository](https://github.com/lightpanda-io/browser).

## Deployment

This template deploys the latest nightly build of Lightpanda Browser with the CDP server exposed on port 9222.

### Connecting to Lightpanda

Once deployed, you can connect to your Lightpanda instance using Playwright, Puppeteer, or any CDP-compatible client:

#### Puppeteer Example

```javascript
const puppeteer = require('puppeteer');

const browser = await puppeteer.connect({
    browserWSEndpoint: 'ws://private-endpoint:9222'
});
const page = await browser.newPage();
await page.goto('https://example.com');
```

## Technical Details

- **Base Image**: `debian:bookworm-slim`
- **Port**: 9222 (Chrome DevTools Protocol)
- **Binary**: Latest nightly build from [Lightpanda releases](https://github.com/lightpanda-io/browser/releases)
- **Init System**: `dumb-init` for proper signal handling

## Resources

- [Lightpanda GitHub](https://github.com/lightpanda-io/browser)
