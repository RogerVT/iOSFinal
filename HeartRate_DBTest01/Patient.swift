//
//  Patient.swift
//  HeartRate_DBTest01
//
//  Created by Roger Eduardo Vazquez Tuz on 11/23/19.
//  Copyright © 2019 Roger Eduardo Vazquez Tuz. All rights reserved.
//

import UIKit

class Patient: Codable  {
        var nombre: String
        var apellido: String
        var estatura: String
        var doctor: String
        var genero: String
        var peso: String
        
    init(nombre: String, apellido: String, estatura: String, doctor: String, genero: String, peso: String) {
        self.nombre = nombre
        self.apellido =  apellido
        self.estatura = estatura
        self.doctor = doctor
        self.genero = genero
        self.peso = peso
    }
}


