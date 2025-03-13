export function buildPath(route: string): string {
    if (process.env.NODE_ENV === 'production') {
      return 'http://fitjourneyhome.com:5001/' + route;  // Use your domain here
    } else {
      return 'http://localhost:5001/' + route;  // Keep localhost for local development
    }
  }
  