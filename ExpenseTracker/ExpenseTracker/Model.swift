//
//  Model.swift
//  ExpenseTracker
//
//  Created by Tarun Tomar on 11/05/20.
//  Copyright © 2020 Tarun Tomar. All rights reserved.
//

import Foundation



class Model {
    var categoryaArray: [String] = []{
        didSet {
            print("")
        }
    }
    var selectedCategoryaSet: Set<Int> = Set(){
        didSet {
            print("")
        }
    }
}
