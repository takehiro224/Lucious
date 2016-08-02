//
//  MyData.swift
//  SaveMoney
//
//  Created by 渡邊丈洋 on 2016/07/24.
//  Copyright © 2016年 takehiro. All rights reserved.
//

import Foundation
class MyData: NSObject, NSCoding {

    //履歴に表示するタイトル
    var title: String?
    //金額
    var money: Int?
    //内容
    var memo: String?
    
    //コンストラクタ
    override init() {
    }
    
    //NSCodingプロトコルに宣言されているデシリアライズ処理。デコード処理とも呼びます。
    required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObjectForKey("title") as? String
        money = aDecoder.decodeObjectForKey("money") as? Int
        memo = aDecoder.decodeObjectForKey("memo") as? String
    }
    
    //NSCodingプロトコルに宣言されているシリアライズ処理。エンコード処理とも呼びます。
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: "todoTitle")
        aCoder.encodeObject(money, forKey: "money")
        aCoder.encodeObject(memo, forKey: "memo")
        
    }
}