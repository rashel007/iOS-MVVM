//
//  BaseViewModel.swift
//  MvvmExampleSwift5.0
//
//  Created by Bekir on 14.01.2020.
//  Copyright © 2020 Bekir. All rights reserved.
//

import Foundation


protocol BaseViewModel {
    func startSynching()
    var changeHandler: ((BaseViewModelChange) -> Void)? {get set}
    func emit(_ change: BaseViewModelChange)
}

enum BaseViewModelChange {
    case loaderStart
    case loaderEnd
    case updateDataModel
    case error(message: String)
}

extension BaseViewModel{
    var baseData :BaseData? {
        return BaseData.sharedInstance
    }
    var restClient :RestClient? {
        return RestClient.sharedInstance
    }
}
