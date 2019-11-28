//
//  MostrarPacienteViewController.swift
//  HeartRate_DBTest01
//
//  Created by Roger Eduardo Vazquez Tuz on 11/21/19.
//  Copyright © 2019 Roger Eduardo Vazquez Tuz. All rights reserved.
//

import UIKit

class MostrarPacienteViewController: UIViewController {
    var pacienteAux : Patient!
    var pacienteID: String!
    
    @IBOutlet weak var lblNombreApellido: UILabel!
    
    @IBOutlet weak var lblApellido: UILabel!
    @IBOutlet weak var lblPeso: UILabel!
    
    @IBOutlet weak var lblEstatura: UILabel!
    
    @IBOutlet weak var lblGenero: UILabel!
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        lblNombreApellido.text = pacienteAux.nombre
        lblApellido.text = pacienteAux.apellido
        lblPeso.text = pacienteAux.peso
        lblEstatura.text = pacienteAux.estatura
        lblGenero.text = pacienteAux.genero
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if(segue.identifier == "calcularPresion" ){
            let calculoView = segue.destination as! MeasureViewController
            calculoView.pacienteID = pacienteID
              }
        if(segue.identifier == "mostrarHistorial") {
            let mostrarView = segue.destination as! MedidasTableViewController
            mostrarView.patID = pacienteID
        }
        
        
    }
}
