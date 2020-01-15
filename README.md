# iOS-MVVM
iOS Mvvm (Alomofire) Swift 5.0


Network Layer
* BaseApiRequest
```Swift  
public protocol BaseApiRequest {
    var requestMethod: RequestHttpMethod?{ get }
    var requestPath: String {get}
    func request() -> URLRequest
}
```

 *Extension
```Swift  
extension BaseApiRequest{
    var enviroment: Environment {
        return Environment.Dev
    }
    public func request() -> URLRequest {
        let url: URL! = URL(string: baseUrl+requestPath)
        var request = URLRequest(url: url)
        switch requestMethod {
        case .Get:
            request.httpMethod = "GET"
            break
        case .Post:
            request.httpMethod = "POST"
            break
        default:
            request.httpMethod = "GET"
            break
        }
        return request
    }
    
    var baseUrl: String {
        switch enviroment {
        case .Prod:
            return "https://api.myjson.com/bins"
        case .Dev:
            return "https://api.myjson.com/bins"
        default:
            return "https://api.myjson.com/"
        }
    }
}
```

 *Enums
```Swift  
public enum RequestHttpMethod{
    case Get
    case Post
}

public enum Environment{
    case Prod
    case Dev
    case UAT
}
```

* GetEventListApiRequest
* GetEventResponse

 Alamofire Generic Request 
* RestClient

```Swift   
private func sendRequest<T:Codable>(_ request:BaseApiRequest,_ type :T.Type,successHandler:@escaping(T)->(),failHandler:@escaping(Error)->()){
        AF.request(request.request()).responseDecodable { (response:AFDataResponse<T>) in
             switch response.result{
                       case .success(let responseEventList):
                           successHandler(responseEventList)
                           print("success")
                       case .failure(let error):
                           failHandler(error)
                           print("fail")
            }
        }
    }
 ```
* IServiceHandler


