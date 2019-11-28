//
//  SeleccionarViewController.swift
//  HeartRate_DBTest01
//
//  Created by Roger Eduardo Vazquez Tuz on 11/25/19.
//  Copyright © 2019 Roger Eduardo Vazquez Tuz. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class SeleccionarViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    var pickerData = [String]()
        let decoder = JSONDecoder()
    var patID = [String]()
     var db: Firestore!
    var userID : String!
    var patient: String!

    @IBOutlet weak var pickerPat: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
self.navigationController?.setNavigationBarHidden(false, animated: false)
        userID = Auth.auth().currentUser!.uid
            
            let settings = FirestoreSettings()

                Firestore.firestore().settings = settings
                db = Firestore.firestore()
        
        
        pickerPat.delegate = self
        pickerPat.dataSource = self
        
        retrieveData()
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.patient = patID[row]
        print(patient)
     }

    private func retrieveData() -> Void {
        db.collection("pacientes").whereField("doctor", isEqualTo: userID!).getDocuments(){ (querySnapshot, err) in
                  if let err = err{
                      print("Error getting documents: \(err)")
                  }
                  else{
                      for document in querySnapshot!.documents{
                          do{
                            let jsonData = try? JSONSerialization.data(withJSONObject: document.data())
                              let pat = try self.decoder.decode(Patient.self, from: jsonData!)
                            self.pickerData.append(pat.nombre + " " + pat.apellido)
                            self.patID.append(document.documentID)
                          }
                      
                          catch let error{
                              print(error.localizedDescription)
                          }
                      }
                    self.pickerPat.reloadAllComponents()
                  }
              }
    }
    
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if(segue.identifier == "goMeasure" ){
            let measure = segue.destination as! MeasureViewController
            measure.pacienteID = self.patient
        }

       
    }
    
    
    
    
}
