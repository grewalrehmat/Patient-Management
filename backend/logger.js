function Log(url, Request, statusCode) {
    console.log(`${Request} ${url} ${statusCode} at ${new Date().toLocaleTimeString()}\n`);
}
export default Log;
