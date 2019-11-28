//
// AnadirPAciente
//  HeartRate_DBTest01
//
//  Created by Alumno on 11/20/19.
//  Copyright © 2019 Roger Eduardo Vazquez Tuz. All rights reserved.
//

import UIKit
import TextFieldEffects
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth




class AnadirViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var tfNombre: AkiraTextField!
    
    @IBOutlet weak var tfApellidos: AkiraTextField!
    
    @IBOutlet weak var tfEstatura: AkiraTextField!
    
    
    @IBOutlet weak var tfPeso: AkiraTextField!
    
    @IBOutlet weak var pickerGenero: UIPickerView!
    
    @IBAction func removeKey(_ sender: Any) {
             view.endEditing(true)
    }
     var db: Firestore!
    var userID : String!
    
    var pickerData : [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        title = "Agregar Paciente"
        pickerGenero.delegate = self
        pickerGenero.dataSource = self
        pickerData = ["Hombre", "Mujer"]
        userID = Auth.auth().currentUser!.uid
        
        let settings = FirestoreSettings()

            Firestore.firestore().settings = settings
            db = Firestore.firestore()
        
        // Do any additional setup after loading the view.
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
    
    
    @IBAction func guardar(_ sender: Any) {
        
        let patAux = Patient(nombre: tfNombre.text!, apellido: tfApellidos.text!, estatura: tfEstatura.text!, doctor: userID, genero: pickerData[pickerGenero.selectedRow(inComponent: 0)], peso: tfPeso.text!)
           
        saveRecords(pat: patAux)

            navigationController?.popViewController(animated: true)
        
        
    }
    
    private func saveRecords(pat: Patient) {
        var ref: DocumentReference? = nil
        ref = db.collection("pacientes").addDocument(data: ["apellido": pat.apellido,
                                                            "estatura": pat.estatura,
                                                            "genero": pat.genero,
                                                            "nombre": pat.nombre,
                                                            "peso": pat.peso,
                                                            "doctor": self.userID!]) {
                                                                   err in
                                                                   if let err = err {
                                                                       print("Error al subir el documento: \(err)")
                                                                   } else {
                                                                       print("Insertado con id: \(ref!.documentID)")
                                                                   }
           }
        
        
    }
    

        
    
    
    

    


}
