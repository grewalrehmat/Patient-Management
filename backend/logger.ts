type ReqType = "GET" | "POST" | "OPTIONS" | "PUT" | "DELETE";

function Log(url:string, Request:ReqType, statusCode:number){
    console.log(`${Request} ${url} ${statusCode} at ${new Date().toLocaleTimeString()}\n`);
}

export default Log; 