//
//  AddIncidentController.swift
//  CSE355 Final Project
//
//  Created by Yiff OSX on 4/12/21.
//

import UIKit

class AddIncidentController : UIViewController  {
    @IBOutlet weak var DescBox: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    func complete()
    {
        self.performSegue(withIdentifier: "BackToMapFromAddIncident", sender: nil)
    }
    
    @IBAction func Submit(_ sender: Any)
    {
        let get_api_url  = "https://brandanlasley.com/CSE335/api/1.0/set/createcall/"
        let url = URL(string: get_api_url)!
        var request = URLRequest(url: url)
        let session = URLSession.shared
        
        let postString = "description=" + DescBox.text! + "&lat=" + String(CallListController.MyState.mapLat) + "&lng=" + String(CallListController.MyState.mapLng)
        
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
