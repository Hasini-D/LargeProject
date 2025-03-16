export function buildPath(route: string): string {
    // Since Nginx proxies /api to the backend, you don't include the port here.
    if(process.env.NODE_ENV === 'production'){
      return `http://fitjourneyhome.com/${route}`;
    }else{
      return `http://localhost:5001/${route}`;
    }
  }