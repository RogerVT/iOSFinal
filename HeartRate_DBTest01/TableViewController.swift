//
//  TableViewController.swift
//  HeartRate_DBTest01
//
//  Created by Roger Eduardo Vazquez Tuz on 10/24/19.
//  Copyright © 2019 Roger Eduardo Vazquez Tuz. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


class TableViewController: UITableViewController {

    
    var db: Firestore!
    let decoder = JSONDecoder()
    var patientArray = [Patient]()
    var patID = [String]()
    var patNames = [String]()
    var userID : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        title = "Pacientes"
        userID = Auth.auth().currentUser!.uid
    
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        retrieveData()
        print("here")
    }
    


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientArray.count
    }
    
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "patientCell", for: indexPath)
         let pat = patientArray[indexPath.row]
        cell.textLabel?.text = pat.nombre + " " + pat.apellido
        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if(segue.identifier == "mostrarSegue" ){
            let mostrarPaciente = segue.destination as! MostrarPacienteViewController
            let index = tableView.indexPathForSelectedRow!
            mostrarPaciente.pacienteAux = patientArray[index.row]
            mostrarPaciente.pacienteID = patID[index.row]
            
        }

        // Pass the selected object to the new view controller.
    }
    
    
    //MARK: Utilities
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
                              self.patientArray.append(pat)
                            self.patNames.append(pat.nombre)
                            self.patID.append(document.documentID)
                          }
                      
                          catch let error{
                              print(error.localizedDescription)
                          }
                      }
         
                    self.tableView.reloadData()
                  }
              }
        
   
    }
}
