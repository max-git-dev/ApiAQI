//
//  AQIModel.swift
//  ApiAQI
//
//  Created by 姚佳宏MacMiniM1 on 2022/11/6.
//

import Foundation

struct AQIData:Codable{
    var total:String
    var records:[Record]?
}

struct Record:Codable{
    let sitename:String
    let county:String
    let aqi:String
    let status:String
}
