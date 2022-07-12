//
//  CallDetailsController.swift
//  CSE355 Final Project
//
//  Created by Yiff OSX on 4/11/21.
//

import UIKit

class CalllDetailsController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var HeaderCallNumber: UILabel!
    @IBOutlet weak var HeaderTimeStamp: UILabel!
    @IBOutlet weak var HeaderSummaery: UILabel!
    @IBOutlet weak var HeaderUnitsAssigned: UILabel!
    @IBOutlet weak var HeaderMessageCount: UILabel!
    @IBOutlet weak var HeaderLat: UILabel!
    @IBOutlet weak var HeaderLng: UILabel!
    
    @IBOutlet weak var UnitsTableView: UITableView!
    @IBOutlet weak var CommentsTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupTableView()
        refreshUI()
    }
    
    func setupTableView()
    {
        UnitsTableView.delegate = self
        UnitsTableView.dataSource = self
        UnitsTableView.register(UnitCells.self, forCellReuseIdentifier: "UnitID");
        view.addSubview(UnitsTableView);
        
        CommentsTableView.delegate = self
        CommentsTableView.dataSource = self
        CommentsTableView.register(CommentCells.self, forCellReuseIdentifier: "CommentID");
        view.addSubview(CommentsTableView);
    }
    
    func refreshUI()
    {
        let currentIncident = CallListController.MyState.currentSelectedCall
        
        if (currentIncident != nil)
        {
            HeaderCallNumber.text = String(currentIncident!.id)
            HeaderTimeStamp.text = currentIncident!.time
            HeaderSummaery.text = currentIncident!.description
            HeaderLat.text = String(currentIncident!.lat)
            HeaderLng.text = String(currentIncident!.lng)
            
            HeaderUnitsAssigned.text = String(0)
            HeaderMessageCount.text = String(0)
            
            if (currentIncident?.Details != nil)
            {
                HeaderMessageCount.text = String(
                    currentIncident!.Details.count)
            }
            
            if (currentIncident?.Units != nil)
            {
                HeaderUnitsAssigned.text = String( currentIncident!.Units.count)
            }
        }
        
        UnitsTableView.reloadData()
        CommentsTableView.reloadData()
    }
    
    class UnitCells : UITableViewCell
    {
        public let cellView : UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.gray
            view.layer.cornerRadius = 10
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        public var UnitTime : UILabel = {
            let label = UILabel()
            label.textColor = UIColor.orange
            return label
        }()
        
        public var UnitName : UILabel = {
            let label = UILabel()
            label.textColor = UIColor.orange
            return label
        }()
        
        public var UnitLat : UILabel = {
            let label = UILabel()
            label.textColor = UIColor.blue
            return label
        }()
        
        public var UnitLng : UILabel = {
            let label = UILabel()
            label.textColor = UIColor.green
            return label
        }()
    
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
        {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            addSubview(cellView)
            addSubview(UnitTime)
            addSubview(UnitName)
            addSubview(UnitLat)
            addSubview(UnitLng)
            self.selectionStyle = .none
            
            NSLayoutConstraint.activate([
                cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: -10),
                cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
                cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
                cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
            
            UnitName.translatesAutoresizingMaskIntoConstraints = false
            UnitName.heightAnchor.constraint(equalToConstant: 200).isActive = true
            UnitName.widthAnchor.constraint(equalToConstant: 200).isActive = true
            UnitName.centerYAnchor.constraint(equalTo: cellView.centerYAnchor, constant: 5).isActive = true
            UnitName.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 10).isActive = true
            
            
            UnitTime.translatesAutoresizingMaskIntoConstraints = false
            UnitTime.heightAnchor.constraint(equalToConstant: 250).isActive = true
            UnitTime.widthAnchor.constraint(equalToConstant: 200).isActive = true
            UnitTime.centerYAnchor.constraint(equalTo: cellView.centerYAnchor, constant: -15).isActive = true
            UnitTime.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 10).isActive = true
            
            UnitLat.translatesAutoresizingMaskIntoConstraints = false
            UnitLat.heightAnchor.constraint(equalToConstant: 200).isActive = true
            UnitLat.widthAnchor.constraint(equalToConstant: 200).isActive = true
            UnitLat.centerYAnchor.constraint(equalTo: cellView.centerYAnchor, constant: 25).isActive = true
            UnitLat.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 10).isActive = true

            UnitLng.translatesAutoresizingMaskIntoConstraints = false
            UnitLng.heightAnchor.constraint(equalToConstant: 250).isActive = true
            UnitLng.widthAnchor.constraint(equalToConstant: 200).isActive = true
            UnitLng.centerYAnchor.constraint(equalTo: cellView.centerYAnchor, constant: 25).isActive = true
            UnitLng.leftAnchor.constraint(equalTo: cellView.rightAnchor, constant: -200).isActive = true
        }
        
        required init?(coder aDEcoder: NSCoder)
        {
            fatalError("rofl");
        }
    }
    
    class CommentCells : UITableViewCell
    {
        public let cellView : UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.gray
            view.layer.cornerRadius = 10
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        public var CommentTime : UILabel = {
            let label = UILabel()
            label.textColor = UIColor.orange
            return label
        }()
        
        public var CommentUnit : UILabel = {
            let label = UILabel()
            label.textColor = UIColor.green
            return label
        }()
        
        public var CommentMessage : UILabel = {
            let label = UILabel()
            label.textColor = UIColor.orange
            return label
        }()
        
        public var CommentImage : UIImageView = {
            let myimg = UIImageView()
            myimg.backgroundColor = .red
            return myimg
        }()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
        {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            addSubview(cellView)
            addSubview(CommentTime)
            addSubview(CommentUnit)
            addSubview(CommentMessage)
            addSubview(CommentImage)
            self.selectionStyle = .none
            
            NSLayoutConstraint.activate([
                cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: -10),
                cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
                cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
                cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
            
            CommentUnit.translatesAutoresizingMaskIntoConstraints = false
            CommentUnit.heightAnchor.constraint(equalToConstant: 200).isActive = true
            CommentUnit.widthAnchor.constraint(equalToConstant: 200).isActive = true
            CommentUnit.centerYAnchor.constraint(equalTo: cellView.centerYAnchor, constant: 5).isActive = true
            CommentUnit.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 10).isActive = true
            
            
            CommentTime.translatesAutoresizingMaskIntoConstraints = false
            CommentTime.heightAnchor.constraint(equalToConstant: 250).isActive = true
            CommentTime.widthAnchor.constraint(equalToConstant: 200).isActive = true
            CommentTime.centerYAnchor.constraint(equalTo: cellView.centerYAnchor, constant: -15).isActive = true
            CommentTime.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 10).isActive = true
            
            CommentMessage.translatesAutoresizingMaskIntoConstraints = false
            CommentMessage.heightAnchor.constraint(equalToConstant: 200).isActive = true
            CommentMessage.widthAnchor.constraint(equalToConstant: 200).isActive = true
            CommentMessage.centerYAnchor.constraint(equalTo: cellView.centerYAnchor, constant: 25).isActive = true
            CommentMessage.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 10).isActive = true

            /*CommentImage.translatesAutoresizingMaskIntoConstraints = false
            CommentImage.heightAnchor.constraint(equalToConstant: 250).isActive = true
            CommentImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
            CommentImage.centerYAnchor.constraint(equalTo: cellView.centerYAnchor, constant: 25).isActive = true
            CommentImage.leftAnchor.constraint(equalTo: cellView.rightAnchor, constant: -150).isActive = true*/
        }
        
        required init?(coder aDEcoder: NSCoder)
        {
            fatalError("rofl");
        }
    }
    
    
    internal func tableView(_ tableview: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 65
        /*if (UnitsTableView == tableView)
        {
            return 25
        }
        return 40*/
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let currentIncident = CallListController.MyState.currentSelectedCall
        if (UnitsTableView == tableView)
        {
            if (currentIncident?.Units != nil)
            {
                return currentIncident!.Units.count
            }
        }
        else
        {
            if (currentIncident?.Units != nil)
            {
                return currentIncident!.Details.count
            }
        }
        return 0
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let currentIncident = CallListController.MyState.currentSelectedCall
        
        if (UnitsTableView == tableView)
        {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "UnitID", for: indexPath) as? UnitCells
            {
                let unit = currentIncident!.Units[indexPath.row]!
                
                cell.UnitTime.text = unit.time
                cell.UnitName.text = unit.name
                cell.UnitLat.text = String(unit.lat)
                cell.UnitLng.text = String(unit.lng)
                
                cell.backgroundColor = UIColor.blue
                return cell
            }
        }
        else if (CommentsTableView == tableView)
        {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentID", for: indexPath) as? CommentCells
            {
                let comment = currentIncident!.Details[indexPath.row]!
                
                cell.CommentTime.text = comment.time
                
                // Search for unit name
                for unit in currentIncident!.Units
                {
                    if (unit!.id == comment.unit_id)
                    {
                        cell.CommentUnit.text = unit!.name
                        break
                    }
                }
                
                if (comment.message != nil)
                {
                    cell.CommentMessage.text = comment.message
                }
                
                if (comment.image != nil)
                {
                    // Not Impl
                }
            
                cell.backgroundColor = UIColor.blue
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func backToMap()
    {
        self.performSegue(withIdentifier: "SegToMap", sender: nil)
    }
    
    
    @IBAction func DeleteCall(_ sender: Any) {
        let get_api_url  = "https://brandanlasley.com/CSE335/api/1.0/set/deletecall/"
        let url = URL(string: get_api_url)!
        var request = URLRequest(url: url)
        let session = URLSession.shared
        let postString = "call=" + String(CallListController.MyState.currentSelectedCall!.id)
        
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        session.dataTask(with: request)
        {
            data, response, error  in
            
            DispatchQueue.main.async
            {
                CallListController.loadCallData(callback: self.backToMap)
            }
            
        }.resume()
    }
    
    func reloadData() -> Void
    {
        self.refreshUI()
    }
    
    @IBAction func addMyself(_ sender: Any) {
        let currentIncident = CallListController.MyState.currentSelectedCall
        let get_api_url  = "https://brandanlasley.com/CSE335/api/1.0/set/addcallunit/"
        let url = URL(string: get_api_url)!
        var request = URLRequest(url: url)
        let session = URLSession.shared
        
        let postString = "call=" + String(currentIncident!.id) + "&name=" + CallListController.MyState.myUnitName + "&lat=" + String(CallListController.MyState.mapLat) + "&lng=" + String(CallListController.MyState.mapLng)
        
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        session.dataTask(with: request)
        {
            data, response, error  in
            
            DispatchQueue.main.async
            {
                CallListController.loadCallData(callback: self.reloadData)
            }
            
        }.resume()
    }
    
    @IBAction func RemoveMyself(_ sender: Any) {
        let get_api_url  = "https://brandanlasley.com/CSE335/api/1.0/set/deletecallunit/"
        let url = URL(string: get_api_url)!
        var request = URLRequest(url: url)
        let session = URLSession.shared
        
        // Find my ID
        // Search for unit name
        var unitID = -1
        let currentIncident = CallListController.MyState.currentSelectedCall
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
        
        let postString = "unit=" + String(unitID)
        
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        session.dataTask(with: request)
        {
            data, response, error  in
            
            DispatchQueue.main.async
            {
                CallListController.loadCallData(callback: self.reloadData)
                self.refreshUI()
            }
            
        }.resume()
    }
    
    
    @IBAction func AddComment(_ sender: Any) {
        
    }
}
