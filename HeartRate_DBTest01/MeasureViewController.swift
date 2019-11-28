//
//  MeasureViewController.swift
//  HeartRate_DBTest01
//
//  Created by Roger Eduardo Vazquez Tuz on 11/16/19.
//  Copyright © 2019 Roger Eduardo Vazquez Tuz. All rights reserved.
//

import UIKit
import TextFieldEffects
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class MeasureViewController: UIViewController, deviceDataInterface {

    var handler = DeviceHandler()
    var pacienteID: String!
    var db: Firestore!
     
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var systemSist: UILabel!
    @IBOutlet weak var systemDiast: UILabel!
    
    @IBOutlet weak var customSist: UITextField!
    @IBOutlet weak var customDiast: UITextField!
    
    @IBOutlet weak var readyLbl: UILabel!
    
    @IBAction func quitaTeclado(_ sender: Any) {
        
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        readyLbl.isHidden = true

              let settings = FirestoreSettings()

                    Firestore.firestore().settings = settings
                    db = Firestore.firestore()
        handler.viewHandler = self
        valueLabel?.text = "----"
      
        
    }
    
    @IBAction func inicioBtn(_ sender: Any) {
        handler.start()
        readyLbl.isHidden = false
    }
    
    @IBAction func stopButton(_ sender: Any) {
        handler.stop()
        systemSist.text = String(handler.getSistolica())
        systemDiast.text = String(handler.getDiastolica())
    }
    
    @IBAction func guardarButton(_ sender: Any) {
        saveRecords(customSis: Double((self.customSist?.text!)!)!, customDias: Double(self.customDiast!.text!)!, devSis: handler.getSistolica(), devDias: handler.getDiastolica(), patient: self.pacienteID)
       // dismiss(animated: true, completion: nil)
        
    }
    
    func dataHandler(_ s: String) {
           DispatchQueue.main.asyncAfter(deadline: .now() + 1){
               self.valueLabel?.text = s
           }
       }
    
    private func saveRecords(customSis: Double, customDias: Double, devSis: Double, devDias: Double, patient: String) {
         var ref: DocumentReference? = nil
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let now = df.string(from: Date())
         ref = db.collection("presionMedidas").addDocument(data: ["customSis": customSis,
                                                             "customDias": customDias,
                                                             "devSis": devSis,
                                                             "devDias": devDias,
                                                             "timeStamp" : now,
                                                             "patient": pacienteID!]) {
                                                                 err in
                                                                 if let err = err {
                                                                     print("Error al subir el documento: \(err)")
                                                                 } else {
                                                                     print("Insertado con id: \(ref!.documentID)")
                                                                 }
         }
         
     }

}
