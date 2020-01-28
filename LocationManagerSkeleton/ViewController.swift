//
//  ViewController.swift
//  LocationManagerSkeleton
//
//  Created by gomathi saminathan on 1/28/20.
//  Copyright © 2020 Rajendran Eshwaran. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
        LocationManager.shared.start(locationInfoCallBack: {(info) in
            
            print("rajay :\(info.latitude ?? 0.0)")
            print("rajay \(info.longitude ?? 0.0)")
            print(info.address ?? " ")
            print(info.city ?? "")
            print(info.country ?? "")
            print(info.zip ?? 0)
            print(info.state ?? "")
        })
    }


}

