//
//  Utility.swift
//  UtilityLib
//
//  Created by Amit Yadav on 02/01/21.
//  Copyright © 2021 Amit Yadav. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking
import MBProgressHUD



public var AuthToken:String! = "AuthToken"
public var No_Internet_Msg:String! = "NoInternet"
public var No_Data_Msg:String! = "<Add Your Message>"
public var ServiceTimeout:Double = 30.0
private let defaults = UserDefaults.standard
public var BaseUrl:String! = "<Add Your base URL>"



public extension Double {
    /// Rounds the double to decimal places value
    mutating func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
}


public extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}


public extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func validatedStringWithRegex(regexStr:String)->Bool{
        
        let regex = try! NSRegularExpression(pattern: regexStr, options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        
    }
    
}
public extension Date {
    func isBeforeDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedAscending
    }
    
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
    
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}



public extension UITextField{
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor =  UIColor.lightGray.withAlphaComponent(0.5).cgColor//Utility.hexStringToUIColor(hex: "3C3C43").cgColor
        
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
    func addLeftViewPadding(padding:CGFloat){
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}



public extension UIView {
    
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 2
        rotation.isCumulative = true
        rotation.repeatCount = Float.infinity
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func setRoundCorner(cornerRadious:CGFloat) {
        
        self.layer.cornerRadius = cornerRadious
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        
    }
    
    func setBorder(width:CGFloat, borderColor:UIColor, cornerRadious:CGFloat) {
        
        self.layer.cornerRadius = cornerRadious
        self.layer.borderWidth = width
        self.layer.borderColor = borderColor.cgColor
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        
    }
    
    func roundTopCorners(cornerRadious:CGFloat) {
        
        self.layer.cornerRadius = cornerRadious
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
    }
    
    
}

public class UtilityLib {
    
    public init() {}
    
    public func color(from isActive:Bool, defaultColorCode:String = "072144") -> UIColor? {
        if isActive {
            return self.hexStringToUIColor(hex: "00AFEF")
        }else{
            return self.hexStringToUIColor(hex:defaultColorCode )
        }
        
    }
    
    public func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    public func dropShadow(viewDrop:UIView!)
    {
        viewDrop.layer.masksToBounds = false
        viewDrop.layer.shadowColor = UIColor.darkGray.cgColor
        viewDrop.layer.shadowOpacity = 0.3
        viewDrop.layer.shadowOffset = CGSize(width: 0, height:0)
        viewDrop.layer.shadowRadius = 10
        viewDrop.layer.cornerRadius = 10
    }
    public func showPopup(Title:String?, Message:String?, InViewC:UIViewController?) {
        
        let popUpAlert = UIAlertController(title: Title!, message: Message!, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        popUpAlert.addAction(okAction)
        InViewC?.present(popUpAlert, animated: true, completion: nil)
    }
    
    public func showAlertWithPopAction(Title:String?, Message:String?, InViewC:UIViewController?,isPop:Bool , isPopToRoot:Bool) {
        
        let popUpAlert = UIAlertController(title: Title!, message: Message!, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler:  { (UIAlertAction) in
            
            if isPop && isPopToRoot {
                InViewC?.navigationController?.popToRootViewController(animated: true)
            }else if isPop{
                InViewC?.navigationController?.popViewController(animated: true)
            }
            
        })
        popUpAlert.addAction(okAction)
        InViewC?.present(popUpAlert, animated: true, completion: nil)
    }
    
    
    
    //MARK: Suffix String to Date
    public func dateSuffix(day:Int)->String{
        
        switch day {
        case 11...13: return "th"
        default:
            switch day % 10 {
            case 1: return "st"
            case 2: return "nd"
            case 3: return "rd"
            default: return "th"
            }
        }
    }
    //MARK: End
    
    
    
    //MARK: Custom Date
    public func getDateFromString(sourceformat:String,outputFormat:String,dateStr:String )->String?{
        let formatter = DateFormatter()
        formatter.dateFormat = sourceformat
        if let date = formatter.date(from: dateStr) {
            print(date)  // Prints:  2018-12-10 06:00:00 +0000
            formatter.dateFormat = outputFormat
            return formatter.string(from: date)
        }
        
        return nil
        
    }
    //MARK: End
    
    //MARK: WebService Call
    
    public func MultiPartServiceCall(url:String, serviceParam:[String:Any]?, parentViewC:UIViewController?, willShowLoader:Bool?,viewController:UIViewController,appendStr:String?,fileURL:URL?,mimeType:String,fileData:Data?,ServiceCompletion:@escaping (_ response:Any?, _ isDone:Bool?, _ errMessage:String?) -> Void) {
        var serviceUrl = url
        
        if appendStr != nil{
            serviceUrl = serviceUrl + (appendStr ?? "")
        }
        if AFNetworkReachabilityManager.shared().networkReachabilityStatus == .reachableViaWiFi || AFNetworkReachabilityManager.shared().networkReachabilityStatus == .reachableViaWWAN {
            
            var progressCircle:MBProgressHUD?
            if parentViewC != nil && willShowLoader == true {
                progressCircle = MBProgressHUD.showAdded(to: (parentViewC?.view)!, animated: true)
                progressCircle?.mode = .annularDeterminate
                progressCircle?.contentColor = .systemPink
                progressCircle?.label.text = "Uploading.."
                
                
            }
            
            let manager = AFHTTPSessionManager()
            var error:NSError?
            manager.requestSerializer = AFHTTPRequestSerializer()
            
            let request = manager.requestSerializer.multipartFormRequest(withMethod: "POST", urlString: serviceUrl, parameters: serviceParam, constructingBodyWith: { (formData:AFMultipartFormData) in
                
                do {
                    
                    if fileData != nil{
                       formData.appendPart(withFileData: fileData!, name: "filename", fileName:"pic.png", mimeType: mimeType)
                    }else{
                       try formData.appendPart(withFileURL: fileURL!, name: "filename", fileName: fileURL?.lastPathComponent ?? "", mimeType:mimeType ) //"video/mp4"
                    }
                    
                    
                    

                } catch {
                    print("Error in uploading")
                }
                
                
                if serviceParam != nil{
//                    for (key,value) in serviceParam!{
//                        formData.ap
//                    }
                }
                
                
            }, error:&error)
            
            
            
            
            
           
            manager.requestSerializer.timeoutInterval = ServiceTimeout
            let indexSet: IndexSet = [200,400,500,201]
            manager.responseSerializer.acceptableStatusCodes = indexSet
            //manager.securityPolicy.allowInvalidCertificates = true
            let authToken = (defaults.value(forKey: AuthToken) ?? "") as! String
            
            if !authToken.isEmpty{
                request.addValue("Bearer " + authToken, forHTTPHeaderField: "Authorization")
            }
            
            
            var headers = [String : String]()
            headers["Content-Type"] = "multipart/form-data"
            
            print("Request URL:",serviceUrl)
            print("Request Data:", serviceParam as Any)
            
            manager.uploadTask(withStreamedRequest: request as URLRequest, progress: { (progress) in
                print(progress.fractionCompleted as Any)
                if progressCircle != nil{
                    DispatchQueue.main.async{
                        progressCircle?.progress = Float(progress.fractionCompleted)
                    }
                    
                }
            }) { (response, responseData, error) in
                
                if parentViewC != nil && willShowLoader == true {
                    MBProgressHUD.hide(for: (parentViewC?.view)!, animated: true)
                }
                
                
                
                print("Response Data:",responseData as Any)
                if let response = response as? HTTPURLResponse {
                    if (response.statusCode == 200 || response.statusCode == 201) && error == nil{
                        ServiceCompletion(responseData, true,"")
                    }else{
                        ServiceCompletion(nil, false, error?.localizedDescription)
                    }
                }else{
                    ServiceCompletion(nil, false, error?.localizedDescription)
                }
                
            }.resume()
            
        }else {
            ServiceCompletion(nil, false, No_Internet_Msg)
        }
        
    }
    
    public func POSTServiceCall(url:String, serviceParam:Any, parentViewC:UIViewController?, willShowLoader:Bool?,viewController:UIViewController,appendStr:String?,isOpt:Bool = false,   ServiceCompletion:@escaping (_ response:Any?, _ isDone:Bool?, _ errMessage:String?) -> Void) {
        var serviceUrl = url
        
        if appendStr != nil{
            serviceUrl = serviceUrl + (appendStr ?? "")
        }
        if AFNetworkReachabilityManager.shared().networkReachabilityStatus == .reachableViaWiFi || AFNetworkReachabilityManager.shared().networkReachabilityStatus == .reachableViaWWAN {
            
            if parentViewC != nil && willShowLoader == true {
                MBProgressHUD.showAdded(to: (parentViewC?.view)!, animated: true)
            }
            
            let manager = AFHTTPSessionManager()
            if let param = serviceParam as? [String:Any],!param.isEmpty {
               manager.requestSerializer = AFJSONRequestSerializer(writingOptions: .prettyPrinted)
            }
            
            manager.requestSerializer.timeoutInterval = ServiceTimeout
            let indexSet: IndexSet = [200,400,500,201]
            manager.responseSerializer.acceptableStatusCodes = indexSet
            //manager.securityPolicy.allowInvalidCertificates = true
            let authToken = (defaults.value(forKey: AuthToken) ?? "") as! String
            
            if !authToken.isEmpty{
                manager.requestSerializer.setValue("Bearer " + authToken, forHTTPHeaderField: "Authorization")
            }
            
            
            var headers = [String : String]()
            headers["Content-Type"] = "application/json"
            
            print("Request URL:",serviceUrl)
            print("Request Data:", serviceParam as Any)
            
            manager.post(serviceUrl, parameters: serviceParam, headers: headers , progress: { (progress:Progress) in
                print(progress.totalUnitCount)
                
            }, success: { (sessionDataTask:URLSessionDataTask, responseData:Any?) in
                print(NSString(data: (sessionDataTask.originalRequest?.httpBody)!, encoding: String.Encoding.utf8.rawValue) as Any   )
                if parentViewC != nil && willShowLoader == true {
                    MBProgressHUD.hide(for: (parentViewC?.view)!, animated: true)
                }
                print("Response Data:",responseData as Any)
                
                
                let response = sessionDataTask.response as! HTTPURLResponse
                if responseData != nil{
                    
                    //print("responseDic = \(responseDic)")
                    if response.statusCode == 200 || response.statusCode == 201 {
                        ServiceCompletion(responseData, true,"")
                    }else{
                        ServiceCompletion(responseData, false,"")
                    }
                } else {
                    ServiceCompletion(nil, false, No_Data_Msg)
                }
            }) { (sessionDataTask:URLSessionDataTask?, error:Error) in
                if parentViewC != nil && willShowLoader == true {
                    MBProgressHUD.hide(for: (parentViewC?.view)!, animated: true)
                }
                
                if let response = sessionDataTask?.response as? HTTPURLResponse {
                    if response.statusCode == 401 {
                        ServiceCompletion(nil, true, error.localizedDescription)
                    }else{
                        ServiceCompletion(nil, false, error.localizedDescription)
                    }
                }else{
                    ServiceCompletion(nil, false, error.localizedDescription)
                }
            }
            
        }else {
            ServiceCompletion(nil, false, No_Internet_Msg)
        }
        
    }
    
    public func GETServiceCall(url:String, serviceParam:Any, parentViewC:UIViewController?, willShowLoader:Bool?,viewController:UIViewController,appendStr:String?,isOpt:Bool = false,   ServiceCompletion:@escaping (_ response:Any?, _ isDone:Bool?, _ errMessage:String?) -> Void) {
        
        var serviceUrl = url
        
        if appendStr != nil{
            serviceUrl = serviceUrl + (appendStr ?? "")
        }
        
        if AFNetworkReachabilityManager.shared().networkReachabilityStatus == .reachableViaWiFi || AFNetworkReachabilityManager.shared().networkReachabilityStatus == .reachableViaWWAN {
            
            if parentViewC != nil && willShowLoader == true {
                MBProgressHUD.showAdded(to: (parentViewC?.view)!, animated: true)
            }
            
            let manager = AFHTTPSessionManager()
            //manager.responseSerializer = AFJSONResponseSerializer()
            manager.requestSerializer.timeoutInterval = ServiceTimeout
            let indexSet: IndexSet = [200,400,500]
            manager.responseSerializer.acceptableStatusCodes = indexSet
            let contentType: Set = ["application/json","text/html"] //"text/html"
            manager.responseSerializer.acceptableContentTypes = contentType
            
            let authToken = (defaults.value(forKey: AuthToken) ?? "") as! String
            
            if !authToken.isEmpty{
                // print("Token:\(authToken)")
                manager.requestSerializer.setValue("Bearer " + authToken, forHTTPHeaderField: "Authorization")
            }
            
            var headers = [String : String]()
            headers["Content-Type"] = "application/json"
            
            print("Request URL:",serviceUrl)
            print("Request Data:", serviceParam as Any)
            
            manager.get(serviceUrl, parameters: serviceParam, headers: headers , progress: { (progress:Progress) in
                
                print(progress.totalUnitCount)
                
            }, success: { (sessionDataTask:URLSessionDataTask, responseData:Any?) in
                
                if parentViewC != nil && willShowLoader == true {
                    MBProgressHUD.hide(for: (parentViewC?.view)!, animated: true)
                }
                print("Response Data:",responseData as Any)
                
                
                let response = sessionDataTask.response as! HTTPURLResponse
                if responseData != nil{
                    
                    //print("responseDic = \(responseDic)")
                    if response.statusCode == 200 {
                        
                        ServiceCompletion(responseData, true,"")
                    }else{
                        ServiceCompletion(responseData, false,"")
                    }
                } else {
                    ServiceCompletion(nil, false, No_Data_Msg)
                }
            }) { (sessionDataTask:URLSessionDataTask?, error:Error) in
                if parentViewC != nil && willShowLoader == true {
                    MBProgressHUD.hide(for: (parentViewC?.view)!, animated: true)
                }
                
                print(error.localizedDescription)
                
                if let response = sessionDataTask?.response as? HTTPURLResponse {
                    if response.statusCode == 401 {
                        ServiceCompletion(nil, true, error.localizedDescription)
                    }else{
                        ServiceCompletion(nil, false, error.localizedDescription)
                    }
                }else{
                    ServiceCompletion(nil, false, error.localizedDescription)
                }
                
                
                
                
            }
            
        }else {
            ServiceCompletion(nil, false, No_Internet_Msg)
        }
        
    }
    
    public func DELETEServiceCall(url:String, serviceParam:Any, parentViewC:UIViewController?, willShowLoader:Bool?,viewController:UIViewController,appendStr:String?,    ServiceCompletion:@escaping (_ response:Any?, _ isDone:Bool?, _ errMessage:String?) -> Void) {
        
        var serviceUrl = url
        if appendStr != nil{
            serviceUrl = serviceUrl + (appendStr ?? "")
        }
        
        if AFNetworkReachabilityManager.shared().networkReachabilityStatus == .reachableViaWiFi || AFNetworkReachabilityManager.shared().networkReachabilityStatus == .reachableViaWWAN {
            
            if parentViewC != nil && willShowLoader == true {
                MBProgressHUD.showAdded(to: (parentViewC?.view)!, animated: true)
            }
            
            let manager = AFHTTPSessionManager()
            manager.requestSerializer.timeoutInterval = ServiceTimeout
            let indexSet: IndexSet = [200,400]
            manager.responseSerializer.acceptableStatusCodes = indexSet
            let contentType: Set = ["application/json"] //"text/html"
            manager.responseSerializer.acceptableContentTypes = contentType
            let methods: Set = ["GET","HEAD"]
            manager.requestSerializer.httpMethodsEncodingParametersInURI = methods
            
            let authToken = (defaults.value(forKey: AuthToken) ?? "") as! String
            
            if !authToken.isEmpty{
                manager.requestSerializer.setValue("Bearer " + authToken, forHTTPHeaderField: "Authorization")
            }
            
            
            
            var headers = [String : String]()
            headers["Content-Type"] = "application/json"
            
            print("Request URL:",serviceUrl)
            print("Request Data:", serviceParam as Any)
            
            
            
            manager.delete(serviceUrl, parameters: serviceParam, headers: headers , success: { (sessionDataTask:URLSessionDataTask, responseData:Any?) in
                
                if parentViewC != nil && willShowLoader == true {
                    MBProgressHUD.hide(for: (parentViewC?.view)!, animated: true)
                }
                print("Response Data:",responseData as Any)
                
                
                let response = sessionDataTask.response as! HTTPURLResponse
                if responseData != nil{
                    
                    //print("responseDic = \(responseDic)")
                    if response.statusCode == 200 {
                        ServiceCompletion(responseData, true,"")
                    }else{
                        ServiceCompletion(responseData, false,"")
                    }
                } else {
                    ServiceCompletion(nil, false, No_Data_Msg)
                }
            }) { (sessionDataTask:URLSessionDataTask?, error:Error) in
                if parentViewC != nil && willShowLoader == true {
                    MBProgressHUD.hide(for: (parentViewC?.view)!, animated: true)
                }
                
                if let response = sessionDataTask?.response as? HTTPURLResponse {
                    if response.statusCode == 401 {
                        
                    }else{
                        ServiceCompletion(nil, false, error.localizedDescription)
                    }
                }else{
                    ServiceCompletion(nil, false, error.localizedDescription)
                }
            }
            
        }else {
            ServiceCompletion(nil, false, No_Internet_Msg)
        }
        
    }
    public func PUTServiceCall(url:String, serviceParam:Any, parentViewC:UIViewController?, willShowLoader:Bool?,viewController:UIViewController,appendStr:String?,isOpt:Bool = false,   ServiceCompletion:@escaping (_ response:Any?, _ isDone:Bool?, _ errMessage:String?) -> Void) {
        var serviceUrl = url
        
        if appendStr != nil{
            serviceUrl = serviceUrl + (appendStr ?? "")
        }
        if AFNetworkReachabilityManager.shared().networkReachabilityStatus == .reachableViaWiFi || AFNetworkReachabilityManager.shared().networkReachabilityStatus == .reachableViaWWAN {
            
            if parentViewC != nil && willShowLoader == true {
                MBProgressHUD.showAdded(to: (parentViewC?.view)!, animated: true)
            }
            
            let manager = AFHTTPSessionManager()
            manager.requestSerializer.timeoutInterval = ServiceTimeout
            
            let indexSet: IndexSet = [200,400,500]
            manager.responseSerializer.acceptableStatusCodes = indexSet
            //manager.securityPolicy.allowInvalidCertificates = true
            let contentType: Set = ["application/json"] //"text/html"
            manager.responseSerializer.acceptableContentTypes = contentType
            let methods: Set = ["PUT"]
            manager.requestSerializer.httpMethodsEncodingParametersInURI = methods
            let authToken = (defaults.value(forKey: AuthToken) ?? "") as! String
            
            if !authToken.isEmpty{
                print("Token:\(authToken)")
                manager.requestSerializer.setValue("Bearer " + authToken, forHTTPHeaderField: "Authorization")
            }
            
            var headers = [String : String]()
            headers["Content-Type"] = "application/json"
            headers["accept"] = "application/json"
            
            print("Request URL:",serviceUrl)
            print("Request Data:", serviceParam as Any)
            
            manager.put(serviceUrl, parameters: serviceParam, headers: headers , success: { (sessionDataTask:URLSessionDataTask, responseData:Any?) in
                //print(NSString(data: (sessionDataTask.originalRequest?.httpBody)!, encoding: String.Encoding.utf8.rawValue) as Any   )
                if parentViewC != nil && willShowLoader == true {
                    MBProgressHUD.hide(for: (parentViewC?.view)!, animated: true)
                }
                print("Response Data:",responseData as Any)
                
                
                let response = sessionDataTask.response as! HTTPURLResponse
                if responseData != nil{
                    
                    //print("responseDic = \(responseDic)")
                    if response.statusCode == 200 {
                        ServiceCompletion(responseData, true,"")
                    }else{
                        ServiceCompletion(responseData, false,"")
                    }
                } else {
                    ServiceCompletion(nil, false, No_Data_Msg)
                }
            }) { (sessionDataTask:URLSessionDataTask?, error:Error) in
                if parentViewC != nil && willShowLoader == true {
                    MBProgressHUD.hide(for: (parentViewC?.view)!, animated: true)
                }
                
                if let response = sessionDataTask?.response as? HTTPURLResponse {
                    if response.statusCode == 401 {
                        ServiceCompletion(nil, true, error.localizedDescription)
                    }else{
                        ServiceCompletion(nil, false, error.localizedDescription)
                    }
                }else{
                    ServiceCompletion(nil, false, error.localizedDescription)
                }
            }
            
        }else {
            ServiceCompletion(nil, false, No_Internet_Msg)
        }
        
    }
    
    //MARK: End
    //MARK: UIColor From String
    public func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    //MARK: End
    
    //MARK: Save and Fetch Dictionary To Defautls
    
    public func getObjectFromDefauls(key:String) -> Any? {
        var dataDict:Any?
        if let data = defaults.object(forKey: key){
            do{
                dataDict  = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data as! Data)
            }catch{
                print("\(key) Data Not Found")
            }
        }
        return dataDict
    }
    public func saveObjectTodefaults(key:String,dataObject:Any){
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: dataObject, requiringSecureCoding: false)
            defaults.set(data, forKey: key)
        } catch {
            print("Unable to Save Dictionary")
        }
    }
    //MARK: End
    
    //MARK: Populate Mandatory Fields
    public func populateMandatoryFieldsMark(_ mandatoryLabels:[UILabel],fontFamily:String,size:CGFloat,color:UIColor){
        
        let custAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.font: UIFont(name: fontFamily, size: size)!]
        
        let custTypeAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.font: UIFont(name: fontFamily, size: size)!]
        
        
        for label in mandatoryLabels{
            
            let descText = NSMutableAttributedString(string: label.text ?? "", attributes: custAttributes)
            let starText = NSAttributedString(string: "*", attributes: custTypeAttributes)
            descText.append(starText)
            label.attributedText = descText
            
            
        }
    }
    //MARK: End
    
    //MARK: Format Numbers
    public func formatPoints(num: Double) ->String{
        var thousandNum = num/1000
        var millionNum = num/1000000
        if num >= 1000 && num < 1000000{
            if(floor(thousandNum) == thousandNum){
                return("\(Int(thousandNum))k")
            }
            return("\(thousandNum.roundToPlaces(places: 1))k")
        }
        if num > 1000000{
            if(floor(millionNum) == millionNum){
                return("\(Int(thousandNum))k")
            }
            return ("\(millionNum.roundToPlaces(places: 1))M")
        }
        else{
            if(floor(num) == num){
                return ("\(Int(num))")
            }
            return ("\(num)")
        }

    }
    //MARK: End
    //MARK: Document Directory
    public func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    public func CheckFileExistsInDocumentDirectory(fileName:String)->Bool{
        let pathComponent = self.getDocumentsDirectory().appendingPathComponent(fileName)
        let filePath = pathComponent.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            print("FILE AVAILABLE")
            return true
        } else {
            return false
        }
        
    }
    
    public func getFileLocalPath(fileName:String)->URL{
         return self.getDocumentsDirectory().appendingPathComponent(fileName)
    }
    
    public func deleteFile(_ filePath:URL) {
        guard FileManager.default.fileExists(atPath: filePath.path) else {
            return
        }
        do {
            try FileManager.default.removeItem(atPath: filePath.path)
        }catch{
            fatalError("Unable to delete file: \(error) : \(#function).")
        }
    }
    //MARK: End
}

