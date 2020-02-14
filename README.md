# iOS-MVVM (Inprogres)
iOS Mvvm (Alamofire 5.0) Swift
@Mvvm @iOS Development Architecture
@Mobile Architecture

# Requirements

* Swift 5
* Xcode 11+
* Alamofire 5.0.0 rc3 (https://github.com/Alamofire/Alamofire)

# Base Mvvm Layer 

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

 

# Mvvm Layer Example Using (Using Base Mvvm Layer)

* OnSaleEventViewModelProtocol
```Swift  
protocol OnSaleEventViewModelProtocol : BaseViewModel{
    var events : [Event] { get set }
}

```

* OnSaleEventViewModel

```Swift  
class OnSaleEventViewModel: OnSaleEventViewModelProtocol{
    
    var events: [Event] = [] {
        didSet {
          changeHandler?(.updateDataModel)
        }
    }
   
    var changeHandler: ((BaseViewModelChange) -> Void)?
    
    func startSynching() {
        emit(.loaderStart)
        self.restClient!.getEventList(successHandler: { (response) in
            if(response.data != nil){
                self.events = response.data!
                self.emit(.updateDataModel)
            }
        }) { error in
            self.emit(.error(message: error.asAFError.debugDescription))
        }
    }
    
    func emit(_ change: BaseViewModelChange) {
             changeHandler?(change)
    }

}

```

* OnSaleEventViewController

```Swift  
import UIKit

class OnSaleEventViewController:BaseViewController, BaseViewControllerProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupUI()
        // Do any additional setup after loading the view.
    }

    func bindViewModel() {
        self.viewModel = OnSaleEventViewModel()
        self.viewModel?.changeHandler = {
            [unowned self] change in
            switch change {
            case .error(let message):
               // Error Pop-Up
                break
            case .loaderEnd:
                self.removeSpinner()
                break
            case .loaderStart:
                self.showSpinner(onView: self.view)
                break
            case .updateDataModel:
                // BindData
                break
            }
        }
    }
    
    func setupUI() {
        self.viewModel?.startSynching()
    }

}

```

    
# Network Layer

* BaseApiRequest
```Swift  
import Alamofire
public protocol BaseApiRequest {
    var requestMethod: RequestHttpMethod?{ get }
    var requestBodyObject: BaseObject?{ get }
    var requestPath: String {get}
    func request() -> URLRequest
}

```
* BaseApiRequest
    * Extension
    * NOT: swift protocol default parameter value (Protocol BaseApiRequest => extension BaseApiRequest)
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
            if(requestBodyObject != nil){
                let jsonEncoder = JSONEncoder()
                do {
                    request.httpBody = try jsonEncoder.encode(requestBodyObject)
                } catch  {
                    print(error)
                }
            }
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

* PostEventApiRequest
```Swift  
public class PostEventApiRequest: BaseApiRequest {
    public var requestBodyObject: BaseObject?
    public var requestMethod: RequestHttpMethod? = RequestHttpMethod.Post
    public var requestPath: String = "/sltf6"

    func setBodyObject(bodyObject: Event) {
        self.requestBodyObject = bodyObject
    }
}
```

* GetEventListApiRequest
```Swift   
public class GetEventListApiRequest: BaseApiRequest {    
    public var requestMethod: RequestHttpMethod?
    public var requestPath: String = "/sltf6"
}
```
# Model 

* BaseObject

path = model/
```Swift   
public class BaseObject:Codable{}
```
* GetEventResponse

path = model/response
```Swift   
public class GetEventResponse:BaseObject{
    
    
    var data : [Event]?
    
    enum CodingKeys: String, CodingKey {
          case data = "Data"
    }
 }
``` 

* Event

 path = model/data

```Swift
public class Event: BaseObject {
    var categoryName:String!
    var cityName:String!
     enum CodingKeys: String, CodingKey {
        case categoryName = "CategoryName"
        case cityName = "CityName"
    }
}

``` 


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
     
    func postEvent(event:Event,successHandler: @escaping (GetEventResponse) -> (), failHandler: @escaping (Error) -> ())
}
 ```
