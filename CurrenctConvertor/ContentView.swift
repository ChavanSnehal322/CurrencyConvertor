//
//  ContentView.swift
//  CurrenctConvertor
//
//  Created by Snehal Chavan on 6/21/25.
//

import SwiftUI

struct ContentView: View {
    
    // holds all the currencies of the class in model
    @State var currencies = CurrencyState.Currencies
    
    @State var amount: String = "100.0"
    @State var convertedAmt: String? = nil // storing convertedAmt string
    
    @State var fromCurrency: CurrencyConvertorModel = CurrencyState.Currencies[0]
    @State var toCurrency: CurrencyConvertorModel = CurrencyState.Currencies[1]
    
    @State var isLoading = true
    @State var showErrorScreen = false
    
    // property wrapper for errordelegate is observable
    @ObservedObject var errorDelegate = ExchangeRateDelegate()
    
    // number formatter to map to amount number type
    
    var formatter: NumberFormatter{
        
        let formatter = NumberFormatter()
        
        // customization to decimal number style with two digits after decimal
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.decimalSeparator = "."
        
        return formatter
    }
    
    
    var body: some View {
        VStack (spacing : 25){
            
            Text("Currency Convertor").font(.system(size: 25, weight: .bold)).foregroundColor(.appColor)
                .padding()
            
            Image("currencyconversion").resizable().frame(width: 150, height: 150)
            
            Text("The amount after conversion is :").font(.title3)
            
            HStack{
                
                // show progress view when the conversion is loading
                if isLoading
                {
                    ProgressView()
                }
                else{
                    
                    // text to take input from user
                    //Text("$1000.0").font(.title).foregroundColor(.white)
                    
                    // function call
                    Text(getConvertedAmtString()).font(.title).foregroundColor(.white)
                    
                }
                
                
            }.frame(width: 350, height: 80)
                .background(Color.appColor)
                .cornerRadius(15)
            
            VStack(alignment: .leading){
                Text("Convert Amount: ").font(.title3).padding()
                
                // user input is saved in amount variable
                // $ binding to state variable which changes everytime
                TextField("", text: $amount)
                    .font(.system(size: 25))
                    .padding(25)
                    .frame(width: 350, height: 50)
                    .background(.gray.opacity(0.2))
                    .cornerRadius(15)
                
            }
            
            // options to select the currencies available
            HStack{
                
                Text(" From currency: ")
                
                Spacer()
                
                Picker("From Currency",
                       selection: $fromCurrency){
                    
                    // display from list of available currencies and disply the currency along with its text
                    
                    ForEach(currencies, id: \.code) {  currency in
                        Text(currency.code).tag(currency)
                        
                    }
                }
                
            }
            // options to select the currencies available for the one which you want the conversion to be in
            
            HStack{
                
                Text(" To currency: ")
                
                Spacer()
                
                Picker("To Currency",
                       selection: $toCurrency){
                    
                    // display from list of available currencies and disply the currency along with its text
                    
                    ForEach(currencies, id: \.code) {  currency in
                        Text(currency.code).tag(currency)
                        
                    }
                }
            }
            
            // Enter button
            Button(action:{
                
                // perform conversion
                convertCurrency()
                
                
            }, label: {
                Text("Convert")
                    .frame(width: 250, height: 55)
                    .foregroundColor(.white)
                    .background(Color.appColor)
                    .cornerRadius(15)
            })
            
            
        }
        
        // struct to hold the expense rate response
        .padding(.top, 30)
        .padding(.leading, 35) // padding from left side
        .padding(.trailing, 35) // padding from right
        // ultimately the display will be aligned in center
        
        .fullScreenCover(isPresented: $showErrorScreen){
            
            // Display error view screen 
            ErrorView()
        }
        
        .onChange(of: errorDelegate.isErrorState){
            oldValue, newValue in
            if newValue{
                isLoading = false
                // show the error screen from errorView
                showErrorScreen = true
                
            }
        }
    }
    
    func getConvertedAmtString() -> String{
        
        // if no converted amount is available then just use the default from currency amount else retutrn from currency symbol and converted amount
        
        return convertedAmt ?? "\(fromCurrency.symbol) \(amount)"
    }
    
    func convertCurrency() -> Void{
        
        // not return anything just do the conversion
        // print( "From Currency", fromCurrency.code)
        // print( "To Currency", toCurrency.code)
        
        //print(" Convert this amount: ", amount)
        
        // creating a
        
        guard let floatAmount  = formatter.number(from: amount) as? Float else { return }
        
        isLoading = true
        
        
        DispatchQueue.global(qos: .background).async{
            
            let rateManager = ExchangeRateHandler()
            
            rateManager.delegate = errorDelegate
            rateManager.FetchRate(for: fromCurrency.code, toCurrency: toCurrency.code)
            {
                results in
                
                if let exchangeRate = results{
                        
                        // converting the amount
                        let convertedAmtFloat = exchangeRate.rate * floatAmount
                        
                        // converting the amount to string
                        let ConvertedAmtString = formatter.string(from: NSNumber( value: convertedAmtFloat)) ?? "0.00"
                        
                        DispatchQueue.main.async{
                            
                            // settin g false after fetching the conversion
                            isLoading = false
                            
                            // setting the converted amount from view
                            self.convertedAmt = "\(toCurrency.symbol) \(ConvertedAmtString)"
                            
                        }
                   //  print(results)
                } // exchangeRate
                
            } // rateManager
            
        } // dispatchQueue.global
        
    } // func convertCurrency
    
} // struct



#Preview {
    ContentView()
}
