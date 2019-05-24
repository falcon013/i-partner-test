//
//  ViewController.swift
//  i-partner-test
//
//  Created by Maria Paderina on 5/19/19.
//  Copyright © 2019 Maria Paderina. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    @IBOutlet weak var result: UILabel!
    let apiUrl = "https://bnet.i-partner.ru/testAPI/"
    let userToken = "6fO1Qt9-aE-WLjmcBo"
    let tokenHeaderName = "token"
    var userSession = ""
    
    enum ApiMethods: String {
        case session = "new_session"
        case get     = "get_entries"
        case add    = "add_entry"
        case edit    = "edit_entry"
        case remove  = "remove_entry"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.main.sync {
            userSession = setSession()
        }
    }


    @IBAction func getEntries(_ sender: Any) {
        let currentSession = userSession
        
        print(currentSession)
        
        var entries = getEntries(session: currentSession)
        let newId = addEntry(session: currentSession, body: "new-test-123")
        
        entries = getEntries(session: currentSession)
        
//        DispatchQueue.main.async {
//            self.result.text = newId
//            self.result.text = entries
//        }
    }
    
    
    func setSession() -> String {
        let params: [String:String] = ["a":"new_session"]
        let httpHeaders: HTTPHeaders = [tokenHeaderName : userToken]
        var newSession = ""
        
        Alamofire.request(apiUrl, method: .post, parameters: params, encoding: URLEncoding.default, headers: httpHeaders).responseJSON{ response in
            if response.result.isSuccess {
                print ("Sucess! Got new session")
                
                let sessionResponseJSON: JSON = JSON(response.result.value!)
                print(sessionResponseJSON)
                newSession = sessionResponseJSON["data"]["session"].string ?? ""
            }
            else {
                print ("Error \(String(describing: response.result.error))")
            }
        }
        return newSession
    }
    
    
    func getEntries(session: String) -> String {
        let params: [String:String] = ["a":"get_entries", "session": session]
        let httpHeaders: HTTPHeaders = [tokenHeaderName : userToken]
        var entries = ""
        
        Alamofire.request(apiUrl, method: .post, parameters: params, encoding: URLEncoding.default, headers: httpHeaders).responseJSON{
            response in
            if response.result.isSuccess {
                print ("Sucess! Got entries")
                
                let entriesJSON: JSON = JSON(response.result.value!)
                print(entriesJSON)
                entries = entriesJSON["data"]["da"].string ?? ""
                
            }
            else {
                print ("Error \(String(describing: response.result.error))")
            }
        }
        return entries
    }
    
    func addEntry(session: String, body: String) -> String {
        let params: [String:String] = ["a":"add_entry", "session": session, "body": body]
        let httpHeaders: HTTPHeaders = [tokenHeaderName : userToken]
        var entryId = ""
        
        Alamofire.request(apiUrl, method: .post, parameters: params, encoding: URLEncoding.default, headers: httpHeaders).responseJSON{
            response in
            if response.result.isSuccess {
                print ("Sucess! Got entryId")
                
                let entryJSON: JSON = JSON(response.result.value!)
                print(entryJSON)
                entryId = entryJSON["data"]["id"].string ?? ""
                
            }
            else {
                print ("Error \(String(describing: response.result.error))")
            }
        }
        return entryId
    }
    
    
}

