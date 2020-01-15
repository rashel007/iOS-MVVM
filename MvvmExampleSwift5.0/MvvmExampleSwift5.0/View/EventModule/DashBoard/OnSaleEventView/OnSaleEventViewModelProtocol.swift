//
//  OnSaleEventViewModelProtocol.swift
//  MvvmExampleSwift5.0
//
//  Created by Bekir on 15.01.2020.
//  Copyright © 2020 Bekir. All rights reserved.
//

protocol OnSaleEventViewModelProtocol : BaseViewModel{
    var events : [Event] { get set }
}
