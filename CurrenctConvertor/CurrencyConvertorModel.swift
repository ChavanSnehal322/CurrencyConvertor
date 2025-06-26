//
//  CurrencyConvertorModel.swift
//  CurrenctConvertor
//
//  Created by Snehal Chavan on 6/22/25.
//

import Foundation


//
struct CurrencyConvertorModel: Hashable{
    
    // property
    
    let code : String
    let symbol: String
    
}

class CurrencyState{
    
    static let Currencies: [CurrencyConvertorModel] = [
        
        CurrencyConvertorModel(code: "USD", symbol: "$"),
        CurrencyConvertorModel(code: "EUR", symbol: "€"),
        CurrencyConvertorModel(code: "GBP", symbol: "£"),
        CurrencyConvertorModel(code: "CAD", symbol: "$"),
        CurrencyConvertorModel(code: "INR", symbol: "₹")
        
    ]
}
