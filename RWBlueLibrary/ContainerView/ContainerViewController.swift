//
//  ContainerViewController.swift
//  RWBlueLibrary
//
//  Created by Qaptive Technologies on 02/05/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
  
  var funcs: ContainerViewModel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        funcs = ContainerViewModel(main: self)
        funcs.addingCenterChildView()
        funcs.addPanGesture()
    }
  
}
