//
//  AddCommentController.swift
//  CSE355 Final Project
//
//  Created by Yiff OSX on 4/12/21.
//

import UIKit

class AddCommentController : UIViewController  {
    @IBOutlet weak var CommentBox: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    func complete()
    {
        self.performSegue(withIdentifier: "BackToDetailsFromAddComment", sender: nil)
    }
    
    @IBAction func Submit(_ sender: Any) {
        let currentIncident = CallListController.MyState.currentSelectedCall
        let get_api_url  = "https://brandanlasley.com/CSE335/api/1.0/set/createcalldetail/"
        let url = URL(string: get_api_url)!
        var request = URLRequest(url: url)
        let session = URLSession.shared
        
        // Find my ID
        // Search for unit name
        var unitID = -1
        for unit in currentIncident!.Units
        {
            if (unit!.name == CallListController.MyState.myUnitName)
            {
                unitID = unit!.id
                break
            }
        }
        
        // Invalid Unit / Not on call??
        if (unitID == -1)
        {
            return;
        }
        
        let postString = "call=" + String(currentIncident!.id) + "&unit=" + String(unitID) + "&message=" + CommentBox.text!
        
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        session.dataTask(with: request)
        {
            data, response, error  in
            
            DispatchQueue.main.async
            {
                CallListController.loadCallData(callback: self.complete)
            }
            
        }.resume()
    }
}
