//
//  UnitProfileController.swift
//  CSE355 Final Project
//
//  Created by Yiff OSX on 4/12/21.
//

import UIKit
import CoreData

class UnitProfileController : UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    
    @IBOutlet weak var MyPFP: UIImageView!
    @IBOutlet weak var MyUnit: UITextField!
    
    var pc : UIImagePickerController = UIImagePickerController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        pc.delegate = self
        
        refreshUI()
    }
    
    func refreshUI()
    {
        MyUnit.text = CallListController.MyState.myUnitName
        MyPFP.image = CallListController.MyState.ProfilePic
        MyPFP.contentMode = .scaleAspectFit
    }
    
    @IBAction func SaveProfile(_ sender: Any) {
        CallListController.MyState.myUnitName = MyUnit.text!
        CallListController.MyState.ProfilePic = MyPFP.image!
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistantContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ApplicationSaveState", in: context)
        let newData = NSManagedObject(entity: entity!, insertInto: context)
        
        newData.setValue(CallListController.MyState.myUnitName, forKey: "myUnitName")
        
        do {
            try context.save()
        } catch  {
            // Don't give a shit tbh
        }
        
        self.performSegue(withIdentifier: "GotoCallList", sender: nil)
    }
    
    var selectedImage : UIImage? = nil
    @IBAction func ChangeProfilePicture(_ sender: Any) {
        selectedImage = nil;
        
        present(pc, animated: true, completion: nil);
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil);
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let possibleImage = info[.editedImage] as? UIImage
        {
            selectedImage = possibleImage;
        }
        else if let possibleImage = info[.originalImage] as? UIImage
        {
            selectedImage = possibleImage;
        }
        else
        {
            return;
        }

        MyPFP.image = selectedImage!
        MyPFP.contentMode = .scaleAspectFit
        
        dismiss(animated: true, completion: nil);
    }
}
