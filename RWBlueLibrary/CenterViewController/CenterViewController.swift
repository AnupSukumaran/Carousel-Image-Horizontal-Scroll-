//
//  CenterViewController.swift
//  RWBlueLibrary
//
//  Created by Qaptive Technologies on 02/05/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import UIKit

class CenterViewController: UIViewController {
  
  @IBOutlet weak var horizontalScrollerView: HorizontalScrollerView!
  
  var funcs: CenterViewModel!
  
  override func viewDidLoad() {
      super.viewDidLoad()
      funcs = CenterViewModel(main: self)
      funcs.assignDelegatesForCarouselView()
      funcs.fetchData()
  }

}
