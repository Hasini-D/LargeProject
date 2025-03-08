export function buildPath(route:string):string
{
if (process.env.NODE_ENV === 'production')
{
return 'http://138.197.91.217:5001/'+ route;
}
else
{
return 'http://localhost:5001/' + route;
}
}
