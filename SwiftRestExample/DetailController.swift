//
//  DetailController.swift
//  SwiftRestExample
//
//  Created by Efrén Aguilar on 1/29/15.
//  Copyright (c) 2015 Baware. All rights reserved.
//

import UIKit

class DetailController: UIViewController{
    var id: NSString = NSString(string: "1")
    var nameTextField: UITextField
    var phoneTextField: UITextField
    let host = "http://192.168.1.125:3000"
    
    func setId(id:NSString){
        self.id = id
    }
    
    override func viewDidLoad() {
        nameTextField = UITextField(frame: CGRectMake(10, 0, self.view.frame.width, 40))
        self.view.addSubview(nameTextField)
        phoneTextField = UITextField(frame: CGRectMake(10, 50, self.view.frame.width, 40))
        self.view.addSubview(phoneTextField)
        if id.length > 0 {
            loadData()
        }
    }
    
    private func loadData(){
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: (NSString(format: "%s%s%d%s", host, "/contactos/", id,".json")))
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            if let result: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: error) as? NSDictionary {
                let nombre:NSString = result["nombre"] as NSString
                let telefono:NSString = result["telefono"] as NSString
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.nameTextField.text = nombre
                    self.phoneTextField.text = telefono
                })
                
            }
            
        })
    }
    
    
    
    
    // MARK: Inits
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        nameTextField = UITextField()
        phoneTextField = UITextField()
        id = NSString()
        super.init()
    }
    
    convenience override init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        nameTextField = UITextField()
        phoneTextField = UITextField()
        id = NSString()
        super.init(coder:aDecoder)
    }
}
