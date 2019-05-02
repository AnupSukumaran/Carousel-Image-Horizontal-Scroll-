//
//  CenterViewModel.swift
//  RWBlueLibrary
//
//  Created by Qaptive Technologies on 02/05/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import UIKit

class CenterViewModel: NSObject {
  
  weak var main: CenterViewController!
  var allAlbums = [Album]()
  var currentAlbumIndex = 0

  init(main: CenterViewController) {
    self.main = main
  }
  
  //MARK:
  func fetchData() {
     allAlbums = LibraryAPI.shared.getAlbums()
     main.horizontalScrollerView.reload()
  }
  
  //MARK:
  func assignDelegatesForCarouselView() {
    main.horizontalScrollerView.delegate = main
    main.horizontalScrollerView.dataSource = main
  }
  
  //MARK:
  func horizontalScrollerView_Data(_ index: Int) -> UIView {
    let album = allAlbums[index]
    let albumView = AlbumView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), coverUrl: album.coverUrl)
    if currentAlbumIndex == index {
      albumView.highlightAlbum(true)
    } else {
      albumView.highlightAlbum(false)
    }
    return albumView
  }
  
  func change_Content_Upon_Scroll_Item_Selection(at index: Int) {
    
//    if (index < allAlbums.count && index > -1) {
//      
//      let album = allAlbums[index]
//      currentAlbumData = album.tableRepresentation
//    } else {
//      currentAlbumData = nil
//    }
//    
//    tableView.reloadData()
  }
  
  //MARK:
  func horizontalScrollerView_didSelect(index: Int) {
    let previousAlbumView =  main.horizontalScrollerView.view(at: currentAlbumIndex) as! AlbumView
    previousAlbumView.highlightAlbum(false)
    currentAlbumIndex = index
    let albumView =  main.horizontalScrollerView.view(at: currentAlbumIndex) as! AlbumView
    albumView.highlightAlbum(true)
    change_Content_Upon_Scroll_Item_Selection(at: index)
  }
  
}
