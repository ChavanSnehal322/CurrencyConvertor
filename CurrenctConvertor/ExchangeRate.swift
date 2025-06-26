//
//  ExchangeRate.swift
//  CurrenctConvertor
//
//  Created by Snehal Chavan on 6/22/25.
//

import Foundation

struct ExchangeRate: Codable{
    
    let From: String
    let To: String
    let rate: Float
}


// to hold the rate for the amount from th API request

// codeable : convertable from one form to other
struct ExchangeRateResponse: Codable{
    
    // // dictonary for data in form " USD" : 89.94
    
    let data : [String: Float]
    
    func toExchangeRate(from: String, to: String) -> ExchangeRate{
        
        return ExchangeRate(From: from, To: to, rate: data[to] ?? 0.0 )
    }
    
    
    
}

enum ExchangeRateRequestErrorType{
    
    case server
    case client
    case decode // can't pas th eresponse of API
    
}

struct ExchangeRateRequestErrorDetail{
    
    let error: Error
    let type: ExchangeRateRequestErrorType
    
}


protocol ExchangeRateResponseDelegate{
    
    func reset()

    func requestFailedWith( error: Error?, type: ExchangeRateRequestErrorType)
}


// invloves to get error delegation details
class ExchangeRateDelegate: ExchangeRateResponseDelegate, ObservableObject{
    
    
    @Published var isErrorState: Bool = false
    @Published var errorDetail: ExchangeRateRequestErrorDetail? = nil
    
    func reset() {
        DispatchQueue.main.async{
            
            self.isErrorState = false
            self.errorDetail = nil
        }
    }
    
    
    func requestFailedWith(error: Error?, type: ExchangeRateRequestErrorType) {
        
        DispatchQueue.main.async{
            
            self.isErrorState = true
            
            if let err = error {
                
                // set the error details
                self.errorDetail = ExchangeRateRequestErrorDetail(error: err, type: type)
                
            }
        }
    }
    
    
    

    
    //
    
    
}
