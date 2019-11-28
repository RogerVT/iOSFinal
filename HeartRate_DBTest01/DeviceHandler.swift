//
//  DeviceHandler.swift
//  HeartRate_DBTest01
//
//  Created by Roger Eduardo Vazquez Tuz on 11/21/19.
//  Copyright © 2019 Roger Eduardo Vazquez Tuz. All rights reserved.
//


import UIKit
import CoreBluetooth

protocol deviceDataInterface {
    func dataHandler(_ s: String) -> Void
}

//MARK: Device ServiceID
let Service_CBUUID =  CBUUID(string: "FFE0")
//MARK: Device CharacteristicID (custom characteristic)
let Characteristic_CBUUID = CBUUID(string: "FFE1")


class DeviceHandler: NSObject,CBCentralManagerDelegate, CBPeripheralDelegate {
    //MARK: instances of CBCentralManager, CBPeripheral and target
    var centralManager: CBCentralManager?
    var peripheralCustom: CBPeripheral?
    var viewHandler: MeasureViewController!
    //MARK: auxiliary variables
    var peripheralName: String = ""
    var peripheralStatus: String = ""
    var centralManagerStatus: String = ""
    var deviceServices = [CBService]()
    var deviceCharacteristics = [CBCharacteristic]()
    var pressureValues = [Double]()
    var strAux = String()
    var charAux:Character!
    var commaCounter = 0
    
    
    
    //MARK: statement of DispatchQueue used to run concurrent processes
    let centralQueue: DispatchQueue = DispatchQueue(label: "com.iosbrain.centralQueueName", attributes: .concurrent)
    
    //MARK: delegate's callbacks
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            
        case .unknown:
            self.centralManagerStatus = "UNKNOWN"
        case .resetting:
            self.centralManagerStatus = "RESETTING"
        case .unsupported:
            self.centralManagerStatus = "UNSUPORTED"
        case .unauthorized:
            self.centralManagerStatus = "UNAUTHORIZED"
        case .poweredOff:
            self.centralManagerStatus = "POWERED OFF"
        case .poweredOn:
            self.centralManagerStatus = "POWERED ON"
            
            
            centralManager?.scanForPeripherals(withServices: [Service_CBUUID])
            
        @unknown default:
            self.centralManagerStatus = "FATAL ERROR IN SYSTEM"
            fatalError()
        }
        
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.peripheralName = peripheral.name!
        decodePeripheralState(peripheralState:peripheral.state)
        peripheralCustom = peripheral
        centralManager?.stopScan()
        centralManager?.connect(peripheralCustom!)
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheralCustom?.delegate = self
        peripheralCustom?.discoverServices([Service_CBUUID])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            self.deviceServices.append(service)
            peripheral.discoverCharacteristics(nil, for: service)
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            self.deviceCharacteristics.append(characteristic)
            if characteristic.uuid == Characteristic_CBUUID {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == Characteristic_CBUUID {
            streamTranslator(using: characteristic)
            
        }

    }
    
    
    
    
    //MARK: auxiliary functions
    
       func start() {
         print("Starting central...")
         self.centralManager = CBCentralManager(delegate:self, queue: centralQueue)
     }
     
     func stop() {
         self.centralManager?.cancelPeripheralConnection(peripheralCustom!)
         print("...finishing")
     }
     
    
    func decodePeripheralState(peripheralState: CBPeripheralState) {
        
        switch peripheralState {
        case .disconnected:
            self.peripheralStatus = "DISCONNECTED"
        case .connected:
            self.peripheralStatus = "CONNECTED"
        case .connecting:
            self.peripheralStatus = "CONNECTING"
        case .disconnecting:
            self.peripheralStatus = "DISCONNECTING"
        @unknown default:
            self.peripheralStatus = "FATAL ERROR IN SYSTEM"
            fatalError()
        }
        
    }
    
    
    //MARK: Stream translator
    
     
    func streamTranslator(using customMeasure: CBCharacteristic) -> Void {
        let arr = customMeasure.value!
        for i in arr {
            //var aux: Character = Character(UnicodeScalar(i))
            //print(aux)
            if(i == 59) {
                commaCounter += 1
            } else {
                if(commaCounter == 1) {
                charAux = Character(UnicodeScalar(i))
                print(charAux!)
                strAux.append(charAux)
                } else if(commaCounter  == 2) {
                    commaCounter = 0
                    translateData(str: strAux)
                    print(strAux)
                    strAux = ""
                }
        

            }
            
        }
        
    }
    
    func translateData(str: String) -> Void {
        viewHandler.dataHandler(str)
        pressureValues.append(Double(str)!)
    }
    
    
    func getPeripheralName() -> String {
        return self.peripheralName
    }
    
    func getPeripheralStatus() -> String {
        return self.peripheralStatus
    }
    
    func getCentralStatus() -> String  {
        return self.centralManagerStatus
    }
    
    func printServices() -> Void {
        for service in self.deviceServices {
            print("Service: \(service)")
        }
    }
    
    func printCharacteristics() -> Void {
        for characteristic in self.deviceCharacteristics {
            print("Characteristic: \(characteristic)")
        }
    }
    
    
    //MARK: DATA ANALYSIS FUNCTIONS
    func getSistolica() -> Double {
        return self.pressureValues.max()!
    }
    
    func getDiastolica() -> Double {
        return self.pressureValues.min()!
    }
    
    
    
}
