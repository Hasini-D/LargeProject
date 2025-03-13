export function buildPath(route: string): string {
    // Since Nginx proxies /api to the backend, you don't include the port here.
    return `http://fitjourneyhome.com/api/${route}`;
  }
  