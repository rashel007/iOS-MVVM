# iOS-MVVM
iOS Mvvm (Alomofire) Swift 5.0

# Mvvm Layer 

* BaseViewController

```Swift 
import UIKit

protocol BaseViewControllerProtocol {    
    func bindViewModel()
    func setupUI()
}

public class BaseViewController: UIViewController {
    var viewModel: BaseViewModel?
    var loading : UIView?
      
    public func showSpinner(onView : UIView) {
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = onView.center
             
        DispatchQueue.main.async {
            onView.addSubview(ai)
        }
        loading = ai
    }
    
    override public func viewDidLayoutSubviews() {
        self.loading?.center = self.view.center
    }
    
    public func removeSpinner() {
        DispatchQueue.main.async {
            self.loading?.removeFromSuperview()
            self.loading = nil
        }
    }
    
}

```

* BaseViewModel
```Swift  
protocol BaseViewModel {
    func startSynching()
    var changeHandler: ((BaseViewModelChange) -> Void)? {get set}
    func emit(_ change: BaseViewModelChange)
}
```
* BaseViewModel
    * Extension
```Swift  
extension BaseViewModel{
    var baseData :BaseData? {
        return BaseData.sharedInstance
    }
    var restClient :RestClient? {
        return RestClient.sharedInstance
    }
}
```

* BaseViewModel
    * Enum    
```Swift  
enum BaseViewModelChange {
    case loaderStart
    case loaderEnd
    case updateDataModel
    case error(message: String)
}
```

    
# Network Layer

* BaseApiRequest
```Swift  
public protocol BaseApiRequest {
    var requestMethod: RequestHttpMethod?{ get }
    var requestPath: String {get}
    func request() -> URLRequest
}
```
* BaseApiRequest
    * Extension
    
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
* BaseApiRequest
     * Enums
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
    * Protocol

```Swift   
public protocol IServiceHandler {
    func getEventList(successHandler:@escaping(GetEventResponse)->(),
                      failHandler:@escaping(Error)->())

}
 ```

