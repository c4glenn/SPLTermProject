using HTTP
using JSON

function main()
    connectToThing()
end

function connectToThing()
    rapidApiKey = "b826a5c6c8msh64a7a1034c0079cp1d24abjsn068cab805d3d"
    rapidApiHost = "apidojo-yahoo-finance-v1.p.rapidapi.com"
    hostname = "https://apidojo-yahoo-finance-v1.p.rapidapi.com/stock/v2/get-chart?symbol=TSLA&reigon=US"
    headers = ["X-RapidAPI-Key" => rapidApiKey, "content-type" => "application/json"]
    response = HTTP.request("GET", hostname; headers)
    println(String(response.body))
end
f(x) = x^2


main()