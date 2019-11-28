//
//  RecordViewController.swift
//  HeartRate_DBTest01
//
//  Created by Roger Eduardo Vazquez Tuz on 11/25/19.
//  Copyright © 2019 Roger Eduardo Vazquez Tuz. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {

    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var sistSiast: UILabel!
    
    @IBOutlet weak var sistDiast: UILabel!
    
    @IBOutlet weak var manSist: UILabel!
    
    @IBOutlet weak var manDiast: UILabel!
    
     var recordAux : Registro!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timestampLabel.text = recordAux.dateReg
        sistSiast.text = recordAux.devSist
        sistDiast.text = recordAux.devDiast
        manSist.text = recordAux.customSist
        manDiast.text = recordAux.customDiast
        
        
    }
    

}
