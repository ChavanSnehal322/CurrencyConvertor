//
//  ExchangeRateHandler.swift
//  CurrenctConvertor
//
//  Created by Snehal Chavan on 6/22/25.
//

import Foundation


class ExchangeRateHandler{
    
    // adding delegate to set by the view which manages it, to know what error is thrown
    public var delegate: ExchangeRateDelegate? = nil
    
    // in production app we don't add the api key in code which will be a provarcy  breach
    static let apikey = "fca_live_5kOXYWi3BpykoCtw5KN4QY06nCtBRo4ssAdJE9r5"
    
    // generatigng error - Give server error
    // static let apikey = "-- fca_live_5kOXYWi3BpykoCtw5KN4QY06nCtBRo4ssAdJE9r5"

    
    // as the url will change as per the currencies selected by the user for the to conversion
    // eg. for Eur currency it would be // "https://api.freecurrencyapi.com/v1/latest?apikey=fca_live_5kOXYWi3BpykoCtw5KN4QY06nCtBRo4ssAdJE9r5&currencies=EUR "
   
    let url = "https://api.freecurrencyapi.com/v1/latest?apikey=\(ExchangeRateHandler.apikey)"
    
    // creating a error -- added extra h in link -- " Error while fetching currency rate for currency you selected
    // let url = "hhttps://api.freecurrencyapi.com/v1/latest?apikey=\(ExchangeRateHandler.apikey)"
    
    // use api request url
    
    // escaping - a function which is passed will be called when the is completed
        
    func FetchRate(for currency: String, toCurrency: String, completion: @escaping(_ exchangeRate: ExchangeRate?) -> Void ){
        
        self.delegate?.reset()
        
        // base currency url eg: "https://api.freecurrencyapi.com/v1/latest?apikey=fca_live_5kOXYWi3BpykoCtw5KN4QY06nCtBRo4ssAdJE9r5&currencies=EUR&base_currency=CAD"
        
        let url = URL(string: "\(self.url)&base_currency=\(currency)&currencies=\(toCurrency)" )!
        //let url = URL(string: "\(self.url)&currencies=\(toCurrency)&base_currency=\(currency)" )!
        
        let task = URLSession.shared.dataTask(with: url){
            data, response, error in
            
            if let err = error{
                
                // handle client error from API -- function call to the handleClientError()
                self.handleClientError(err)
                
                
                // if the task is completed without error
                DispatchQueue.main.async{
                    
                    completion(nil)
                }
                
                return
            }
            
            // check if the response value is correct else it would be a server error
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else{
                
                // handle server error from API - function call to the handleServerError()
                
                self.handleServerError(response)
                
                DispatchQueue.main.async{
                    
                    completion(nil)
                }
                return
            }
            
            // dedcoding the reponse fetched from api
            
            if let mimeType = httpResponse.mimeType, mimeType == "application/json" ,
               
                let json = data {
                
                //decoding
                let rate = self.decodeResponse(json: json, for: currency, to: toCurrency)
                
                DispatchQueue.main.async{
                    
                    completion(rate)
                }
                
            }
            else{
                
                // handle decode error
                
                self.handleDecodeError()
                
                DispatchQueue.main.async{
                    completion(nil)
                }
                
                return
            }
        }
        // end of defined task
        
        task.resume()
            
        }
        
        // accepts json and decode the response
        func decodeResponse(json: Data, for currency: String, to toCurrency: String) -> ExchangeRate?
        {
            do{
                let decoder = JSONDecoder()
                let exchangeRateResponse = try decoder.decode(ExchangeRateResponse.self, from: json)
                
                return exchangeRateResponse.toExchangeRate(from: currency, to: toCurrency)
            }
            catch{
                
                // handle the decode error -- calling the handleDecodeError
                
                self.handleDecodeError()
                return nil
            }
         
        }
    
    // handling client error
    private func handleClientError( _ error : Error)
    {
        delegate?.requestFailedWith(error: error, type: .client)
    }
    
    private func handleServerError( _ response: URLResponse?)
    {
        // self defined error
        let error = NSError(domain: "API Error ", code: 141)
        delegate?.requestFailedWith(error: error, type: .server)
    }
    
    private func handleDecodeError()
    {
        let error = NSError(domain: "Decode Error ", code: 141)
        delegate?.requestFailedWith(error: error, type: .decode)
    }
    
    
}
