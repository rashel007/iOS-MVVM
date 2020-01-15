# iOS-MVVM
iOS Mvvm (Alomofire) Swift 5.0


Network Layer
* BaseApiRequest
* GetEventListApiRequest
* GetEventResponse

 Alamofire Generic Request 
* RestClient

**    
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
**
* IServiceHandler


