//
//  ErrorView.swift
//  CurrenctConvertor
//
//  Created by Snehal Chavan on 6/21/25.
//

import SwiftUI

struct ErrorView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        
        // Error handling if the api is not working appropiately
        
        VStack{
            Text("Error occured .. !!").font(.title2).padding()
            
            Group(){
                //  Error 1: "Error while fetching the currency rate from api"
                Text("Error while fetching the currency rate you selected .")
                    
                
                Text(" Try again after some time")
            }.multilineTextAlignment(.center)
            
                .padding()
            
            // image for error
            Image(systemName: "dollarsign.bank.building.fill").font(.system(size: 300))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.indigo)
            
            
            Button(action: {
                
                // call to Dismiss the error view
                dismiss()
                
            }, label: {
                
                Text("Dismiss").frame(width: 250, height: 70)
                    .foregroundColor(.white)
                    .background(Color.appColor)
                    .cornerRadius(25)
                
            })
        }
        .padding(25).padding(.leading)
    }
}

#Preview {
    ErrorView()
}
