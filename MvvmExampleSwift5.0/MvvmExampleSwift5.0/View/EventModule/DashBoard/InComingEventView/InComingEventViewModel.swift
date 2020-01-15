//
//  InComingEventViewModel.swift
//  MvvmExampleSwift5.0
//
//  Created by Bekir on 14.01.2020.
//  Copyright © 2020 Bekir. All rights reserved.
//

import Foundation

class InComingEventViewModel: InComingEventModelProtocol{
    var events: [Event] = [] {
        didSet {
          changeHandler?(.updateDataModel)
        }
    }
    func emit(_ change: BaseViewModelChange) {
        changeHandler!(change)
    }
    
    var changeHandler: ((BaseViewModelChange) -> Void)?
       
    func startSynching() {
        emit(.loaderStart)
        self.restClient!.getEventList( successHandler: { (response) in
            self.emit(.loaderEnd)
            if(response.data != nil){
                self.events = response.data!
                self.emit(.updateDataModel)
            }

          }) { error in
            self.emit(.loaderEnd)
          }
    }
}
