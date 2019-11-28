//
//  Registro.swift
//  HeartRate_DBTest01
//
//  Created by Roger Eduardo Vazquez Tuz on 11/25/19.
//  Copyright © 2019 Roger Eduardo Vazquez Tuz. All rights reserved.
//

import UIKit

class Registro: Codable {
    var customSist: String
      var customDiast: String
      var devSist: String
      var devDiast: String
    var dateReg: String
    var patID: String
    
    init(customSist: String, customDiast: String, devSist: String, devDiast: String, dateReg: String, patID: String) {
        self.customSist = customSist
        self.customDiast = customDiast
        self.devSist = devSist
        self.devDiast = devDiast
        self.dateReg = dateReg
        self.patID = patID
    }

}
