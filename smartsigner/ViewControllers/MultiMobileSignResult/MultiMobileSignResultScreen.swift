//
//  MultiMobileSignResultScreen.swift
//  smartsigner
//
//  Created by Serdar Coşkun on 1.03.2024.
//  Copyright © 2024 Seneka. All rights reserved.
//

import Foundation
import SwiftUI

struct MultiMobileSignResultScreen:View{
    @State var result:MultiMobileSignResponse
    var body: some View{
        return ZStack{
            Color.white.ignoresSafeArea()
            List(result.items, id:\.documentID) { item in
                HStack{
                    VStack(alignment:.leading){
                        Text(item.documentSubject)
                            .font(.body)
                            .padding(.bottom, 8)
                        Text(item.message)
                            .font(.caption)
                    }
                    Spacer()
                    if(item.isSigned){
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                    }else{
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.red)
                    }
                }
                
            }
        }
    }
}

struct MultiMobileSignResultScreen_Previews:PreviewProvider{
    static var previews: some View{
        MultiMobileSignResultScreen(
            result: MultiMobileSignResponse.mock()
        )
    }
}
