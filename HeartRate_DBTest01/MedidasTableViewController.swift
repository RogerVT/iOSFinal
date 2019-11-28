//
//  MedidasTableViewController.swift
//  HeartRate_DBTest01
//
//  Created by Roger Eduardo Vazquez Tuz on 11/25/19.
//  Copyright © 2019 Roger Eduardo Vazquez Tuz. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class MedidasTableViewController: UITableViewController {
    
    var db: Firestore!
    let decoder = JSONDecoder()
    var recordArray = [Registro]()
    var patID: String = ""
    var userID : String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        title = "Registros"
        let settings = FirestoreSettings()

             Firestore.firestore().settings = settings
             db = Firestore.firestore()
        
        retrieveData()
            
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recordArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "measureCell", for: indexPath)
         let rec = recordArray[indexPath.row]
        cell.textLabel?.text = rec.dateReg
        return cell
    }
    

    //MARK: Utilities
       private func retrieveData() -> Void {
        db.collection("presionMedidas").whereField("patient", isEqualTo: patID).getDocuments(){ (querySnapshot, err) in
                     if let err = err{
                         print("Error getting documents: \(err)")
                     }
                     else{
                         for document in querySnapshot!.documents{
                             do{
                               let jsonData = try? JSONSerialization.data(withJSONObject: document.data())
                                 let rec = try self.decoder.decode(Registro.self, from: jsonData!)
                                 self.recordArray.append(rec)
                               
                             }
                         
                             catch let error{
                                 print(error.localizedDescription)
                             }
                         }
            
                       self.tableView.reloadData()
                     }
                 }
           
      
       }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if(segue.identifier == "mostrarDetalle" ){
            let mostrarDetalle = segue.destination as! RecordViewController
            let index = tableView.indexPathForSelectedRow!
            mostrarDetalle.recordAux = recordArray[index.row]
       
            
        }

        // Pass the selected object to the new view controller.
    }
    
    
    
   
}
