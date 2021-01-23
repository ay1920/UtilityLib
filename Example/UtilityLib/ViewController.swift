//
//  ViewController.swift
//  UtilityLib
//
//  Created by ay1920 on 01/10/2021.
//  Copyright (c) 2021 ay1920. All rights reserved.
//

import UIKit
import UtilityLib

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let lib = UtilityLib()
        print(lib.getDocumentsDirectory())
        
        self.view.setRoundCorner(cornerRadious: 10)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

