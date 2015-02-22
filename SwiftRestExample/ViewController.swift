//
//  ViewController.swift
//  SwiftRestExample
//
//  Created by Efrén Aguilar on 1/28/15.
//  Copyright (c) 2015 Baware. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var contactDictionary: NSMutableDictionary
    var tableView: UITableView
    let host = "http://192.168.1.118:3000"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Se coloca título a la vista
        self.title = "Contactos"
        
        // Se agrega un botón + a la barra de título
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: nil)
        self.contactDictionary = NSMutableDictionary()
        
        // Se genera la tabla de los contactos
        tableView = UITableView(frame: CGRectMake(0, 10.0, self.view.frame.width, self.view.frame.height))
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        // Se carga el contenido de la tabla
        loadTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return contactDictionary.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)

        cell.textLabel?.text = contactDictionary.allValues[indexPath.row] as NSString
        return cell
    }
    
    var selectedRow:NSInteger
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("detailSegue", sender: self)
    }
    
    // MARK: PrepareForSegue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "detailSegue") {
            
            var detailController = (segue.destinationViewController as DetailController)
        }
    }
    
    // MARK: Cargar contenido de la tabla
    func loadTableView(){
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: (host + "/contactos.json"))
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            if let result: NSArray! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: error) as? NSArray {
                // Eliminamos todos los elementos del diccionario
                self.contactDictionary.removeAllObjects()
                
                var id : String, title : String
                let idKey: NSString = "id", idTitle: NSString = "nombre"
                
                // Por cada elemento asignamos el valor de id y título al diccionario
                for contacts in result {
                    id = (contacts as NSDictionary).allValues[1].stringValue
                    title = contacts.allValues[2] as String
                    
                    self.contactDictionary.setValue(title, forKey: id)
                }
                
                // Recargamos la tabla en el hilo principal
                dispatch_async(dispatch_get_main_queue(), { self.tableView.reloadData() })
                
            }
            
        })
    }

    // MARK: Inits
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        tableView = UITableView()
        self.contactDictionary = NSMutableDictionary()
        self.selectedRow = NSInteger()
        super.init()
    }
    
    convenience override init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        tableView = UITableView()
        self.contactDictionary = NSMutableDictionary()
        self.selectedRow = NSInteger()
        super.init(coder:aDecoder)
    }
}

