//
//  ViewController.swift
//  CSE355 Final Project
//
//  Created by Yiff OSX on 4/11/21.
//

import UIKit
import CoreData

public struct UnitData
{
    let id : Int
    let time : String
    let incident_id : Int
    let name : String
    let lat : Double
    let lng : Double
}

extension UnitData: Decodable
{
    private enum Key: String, CodingKey
    {
        case id = "id"
        case time = "time"
        case incident_id = "fk_incident_id"
        case name = "unitName"
        case lat = "lat"
        case lng = "lng"
    }
    
    public init (from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: Key.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.time = try container.decode(String.self, forKey: .time)
        self.incident_id = try container.decode(Int.self, forKey: .incident_id)
        self.name = try container.decode(String.self, forKey: .name)
        self.lat = try container.decode(Double.self, forKey: .lat)
        self.lng = try container.decode(Double.self, forKey: .lng)
    }
}

public struct DetailsData
{
    let id : Int
    let time : String
    let incident_id : Int
    let unit_id : Int
    let message : String?
    let image : String?
}

extension DetailsData: Decodable
{
    private enum Key: String, CodingKey
    {
        case id = "id"
        case time = "time"
        case incident_id = "fk_incident_id"
        case unit_id = "fk_unit_id"
        case message = "message"
        case image = "image"
    }
    
    public init (from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: Key.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.time = try container.decode(String.self, forKey: .time)
        self.incident_id = try container.decode(Int.self, forKey: .incident_id)
        self.unit_id = try container.decode(Int.self, forKey: .unit_id)
        self.message = try container.decode(String?.self, forKey: .message)
        self.image = try container.decode(String?.self, forKey: .image)
    }
}

public struct IncidentData
{
    let id : Int
    let time : String
    let description : String
    let lat : Double
    let lng : Double
    let Units : [UnitData?]
    let Details : [DetailsData?]
}

extension IncidentData: Decodable
{
    private enum Key: String, CodingKey
    {
        case id = "id"
        case time = "time"
        case description = "description"
        case lat = "lat"
        case lng = "lng"
        case Units = "Units"
        case Details = "Details"
    }
    
    public init (from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: Key.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.time = try container.decode(String.self, forKey: .time)
        self.description = try container.decode(String.self, forKey: .description)
        self.lat = try container.decode(Double.self, forKey: .lat)
        self.lng = try container.decode(Double.self, forKey: .lng)
        self.Units = try container.decode([UnitData?].self, forKey: .Units)
        self.Details = try container.decode([DetailsData?].self, forKey: .Details)
    }
}


public struct IncidentArr
{
    init()
    {
        incidents = []
    }
    
    let incidents : [IncidentData?]
}

class ApplicationSaveState : NSManagedObject
{
    
}

extension ApplicationSaveState
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ApplicationSaveState> {
        return NSFetchRequest<ApplicationSaveState>(entityName: "ApplicationSaveState")
    }
    
    @NSManaged var myUnitName : String
}

struct ApplicationState
{
    init()
    {
        currentSelectedCall = nil
        
        myUnitName = "E62"
        
        mapLat = 45.523413
        mapLng = -122.989118
        
        CallRecords = IncidentArr()
        ProfilePic = UIImage()
    }
    
    var myUnitName : String
    var currentSelectedCall : IncidentData?
    var mapLat : Double
    var mapLng : Double
    var CallRecords : IncidentArr
    var ProfilePic : UIImage
}

extension IncidentArr: Decodable
{
    private enum Key: String, CodingKey
    {
        case incidents = "Incidents"
    }
    
    public init (from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: Key.self)
        
        self.incidents = try container.decode([IncidentData?].self, forKey: .incidents)
    }
}

class CallListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var MainHeader: UINavigationBar!
    
    static var MyState : ApplicationState  = ApplicationState()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let context = (UIApplication.shared.delegate as! AppDelegate).persistantContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ApplicationSaveState", in: context)

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ApplicationSaveState")
        request.returnsObjectsAsFaults = false
        
        do
        {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]
            {
                var myUnitName = data.value(forKey: "myUnitName") as! String
                CallListController.MyState.myUnitName = myUnitName
            }
        } catch
        {
            
        }
        
        CallListController.loadCallData(callback: nil)
        setupTableView()
    }
    
    static func loadCallData(callback: ( () -> Void )?)
    {
        // Wipe Data
        MyState.CallRecords = IncidentArr()
        
        let get_api_url  = "https://brandanlasley.com/CSE335/api/1.0/get/call/"
        let url = URL(string: get_api_url)!
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        session.dataTask(with: request)
        {
            data, response, error  in
            guard let data = data else { return }
        
            do
            {
                let cr = try JSONDecoder().decode(IncidentArr.self, from: data)
                
                DispatchQueue.main.async
                {
                    CallListController.MyState.CallRecords = cr
                    
                    if (MyState.currentSelectedCall != nil && MyState.CallRecords.incidents.count > 0)
                    {
                        for incident in CallListController.MyState.CallRecords.incidents
                        {
                            var found = false
                            if (incident!.id == MyState.currentSelectedCall?.id ?? -1)
                            {
                                MyState.currentSelectedCall = incident
                                found = true
                                break
                            }
                            
                            if (!found)
                            {
                                MyState.currentSelectedCall = nil
                            }
                        }
                    }
                    else
                    {
                        MyState.currentSelectedCall = nil
                    }
                    
                    CallListController.tableview.reloadData()
                    
                    callback?()
                }
            } catch
            {
                print (error)
            }
        }.resume()
    }
    
    func setupTableView()
    {
        CallListController.tableview.delegate = self
        CallListController.tableview.dataSource = self
        CallListController.tableview.register(KinkyCells.self, forCellReuseIdentifier: "cellId");
        view.addSubview(CallListController.tableview);
        NSLayoutConstraint.activate([
            CallListController.tableview.topAnchor.constraint(equalTo: MainHeader.bottomAnchor),
            CallListController.tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            CallListController.tableview.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            CallListController.tableview.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ]);
    }
    
    static let tableview : UITableView = {
        let tv = UITableView();
        tv.backgroundColor = UIColor.white;
        tv.translatesAutoresizingMaskIntoConstraints =  false;
        return tv;
    }();
    
    class KinkyCells : UITableViewCell
    {
        public let cellView : UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.gray
            view.layer.cornerRadius = 10
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        public var IncidentNumber : UILabel = {
            let label = UILabel()
            label.textColor = UIColor.orange
            return label
        }()
        
        public var Description : UILabel = {
            let label = UILabel()
            label.textColor = UIColor.orange
            return label
        }()
        
        public var Lat : UILabel = {
            let label = UILabel()
            label.textColor = UIColor.blue
            return label
        }()
        
        public var Lng : UILabel = {
            let label = UILabel()
            label.textColor = UIColor.green
            return label
        }()
    
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
        {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            addSubview(cellView)
            addSubview(IncidentNumber)
            addSubview(Description)
            addSubview(Lat)
            addSubview(Lng)
            self.selectionStyle = .none
            
            NSLayoutConstraint.activate([
                cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: -10),
                cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
                cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
                cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
            
            Description.translatesAutoresizingMaskIntoConstraints = false
            Description.heightAnchor.constraint(equalToConstant: 200).isActive = true
            Description.widthAnchor.constraint(equalToConstant: 200).isActive = true
            Description.centerYAnchor.constraint(equalTo: cellView.centerYAnchor, constant: 5).isActive = true
            Description.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 50).isActive = true
            
            
            IncidentNumber.translatesAutoresizingMaskIntoConstraints = false
            IncidentNumber.heightAnchor.constraint(equalToConstant: 250).isActive = true
            IncidentNumber.widthAnchor.constraint(equalToConstant: 200).isActive = true
            IncidentNumber.centerYAnchor.constraint(equalTo: cellView.centerYAnchor, constant: -15).isActive = true
            IncidentNumber.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 50).isActive = true
            
            Lat.translatesAutoresizingMaskIntoConstraints = false
            Lat.heightAnchor.constraint(equalToConstant: 200).isActive = true
            Lat.widthAnchor.constraint(equalToConstant: 200).isActive = true
            Lat.centerYAnchor.constraint(equalTo: cellView.centerYAnchor, constant: 25).isActive = true
            Lat.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 50).isActive = true

            Lng.translatesAutoresizingMaskIntoConstraints = false
            Lng.heightAnchor.constraint(equalToConstant: 250).isActive = true
            Lng.widthAnchor.constraint(equalToConstant: 200).isActive = true
            Lng.centerYAnchor.constraint(equalTo: cellView.centerYAnchor, constant: 25).isActive = true
            Lng.leftAnchor.constraint(equalTo: cellView.rightAnchor, constant: -150).isActive = true
        }
        
        required init?(coder aDEcoder: NSCoder)
        {
            fatalError("rofl");
        }
    }

    internal func tableView(_ tableview: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 65
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return CallListController.MyState.CallRecords.incidents.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = CallListController.tableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! KinkyCells
        
        cell.IncidentNumber.text = String(CallListController.MyState.CallRecords.incidents[indexPath.row]!.id)
        cell.Description.text = CallListController.MyState.CallRecords.incidents[indexPath.row]!.description
        cell.Lat.text = String(CallListController.MyState.CallRecords.incidents[indexPath.row]!.lat)
        cell.Lng.text = String(CallListController.MyState.CallRecords.incidents[indexPath.row]!.lng)
        
        cell.backgroundColor = UIColor.blue
        return cell
    }

}

