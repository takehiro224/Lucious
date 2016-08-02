//
//  ViewController.swift
//  SaveMoney
//
//  Created by 渡邊丈洋 on 2016/07/24.
//  Copyright © 2016年 takehiro. All rights reserved.
//

import UIKit
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    //残金
    @IBOutlet weak var amount: UILabel!
    //テーブルビュー
    @IBOutlet weak var tableView: UITableView!
    
    var historyList = [MyData]()
    
    //読み込み処理
    override func viewDidLoad() {
        super.viewDidLoad()
        // 読込処理を追加
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let myDataList = userDefaults.objectForKey("historyList") as? NSData {
            if let historyList = NSKeyedUnarchiver.unarchiveObjectWithData(myDataList) as? [MyData]{
                self.historyList = historyList
            }
        }
    }


    /**
    [+]ボタンがタップされた時の処理
    */
    @IBAction func tapAddButton(sender: AnyObject) {
        //アラートダイアログ生成
        let alertController = UIAlertController(title: "お小遣い登録", message: "支出または収入を登録してください", preferredStyle: UIAlertControllerStyle.Alert)
        
        //アラートダイアログにテキストエリアを追加
        alertController.addTextFieldWithConfigurationHandler(nil)
        
        //[+]ボタンを追加
        let addingAction = UIAlertAction(title: "+", style: UIAlertActionStyle.Default) {
            (action:UIAlertAction) -> Void in
                //[+]ボタンが押された時の処理
                if let textField = alertController.textFields?.first {
                    //TODO配列に入力した値を挿入。先頭に挿入する
                    let myData = MyData()
                    myData.title = textField.text
                    self.historyList.insert(myData, atIndex: 0)
                                            
                    //テーブルに行が追加されたことをテーブルに通知 -> UITableViewの再描画処理が行われる
                    self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Right)
                                            
                    // 保存処理を追加
                    //NSData型にシリアライズする
                    let data :NSData = NSKeyedArchiver.archivedDataWithRootObject(self.historyList)
                                            
                    //NSUserDefaultsに保存
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    userDefaults.setObject(data, forKey: "historyList")
                    userDefaults.synchronize()
                }
                                        
        }
        //[+]ボタンを追加
        alertController.addAction(addingAction)
        
        //[-]ボタンがタップされた時の処理
        let minusAction = UIAlertAction(title: "-", style: UIAlertActionStyle.Default) {
            (action:UIAlertAction) -> Void in
            //[-]ボタンが押された時の処理
            if let textField = alertController.textFields?.first {
                //TODO配列に入力した値を挿入。先頭に挿入する
                let myData = MyData()
                myData.title = textField.text
                self.historyList.insert(myData, atIndex: 0)
                
                //テーブルに行が追加されたことをテーブルに通知 -> UITableViewの再描画処理が行われる
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Right)
                
                // 保存処理を追加
                //NSData型にシリアライズする
                let data :NSData = NSKeyedArchiver.archivedDataWithRootObject(self.historyList)
                
                //NSUserDefaultsに保存
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setObject(data, forKey: "historyList")
                userDefaults.synchronize()
            }
            
        }
        //[-]ボタンを追加
        alertController.addAction(minusAction)
        
        //CANCELボタンがタップされた時の処理
        let cancelAction = UIAlertAction(title: "CANCEL",
                                         style: UIAlertActionStyle.Cancel,
                                         handler: nil)
        //CANCELボタンを追加
        alertController.addAction(cancelAction)
        
        //アラートダイアログを表示
        presentViewController(alertController, animated: true, completion: nil)

    }
    
    /**
     ------------------------------------------------------------------------------------------------------------------------------------------------------
     UITableViewに関わる処理
     */
    
    //(1)テーブルの行数を返却する[UITableViewDataSource]
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }
    
    //(2)テーブルの行ごとのセルを返却する[UITableViewDataSource]
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //storyboardで指定したhistory識別子を利用して再利用可能なセルを取得する
        let cell = tableView.dequeueReusableCellWithIdentifier("history", forIndexPath: indexPath)
        //行番号にあった履歴情報のタイトルを取得
        let history = historyList[indexPath.row]
        //セルのラベルに履歴のタイトルをセット
        cell.textLabel!.text = history.title
        return cell
    }
    
    //(3)セルをタップした時の処理[UITableViewDelegate]
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let history = historyList[indexPath.row]
        print(history.title)
        //アラートダイアログ生成
        let alertController = UIAlertController(title: history.title ?? "nodata", message: "支出または収入を登録してください", preferredStyle: UIAlertControllerStyle.Alert)
        //アラートダイアログにテキストエリアを追加
        alertController.addTextFieldWithConfigurationHandler(nil)
        //CANCELボタンがタップされた時の処理
        let cancelAction = UIAlertAction(title: "CANCEL",
                                         style: UIAlertActionStyle.Cancel,
                                         handler: nil)
        alertController.addAction(cancelAction)
        //アラートダイアログを表示
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    //(4)セルが編集できるかどうかの判定処理[UITableViewDataSource]
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //(5)セルを削除した時の処理[UITableViewDataSource]
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //削除処理かどうか
        if editingStyle == .Delete {
            //TODOリストから削除
            historyList.removeAtIndex(indexPath.row)
            //セルを削除
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            //データ保存
            //NSData型にシリアライズする
            let data :NSData = NSKeyedArchiver.archivedDataWithRootObject(historyList)
            
            //NSUserDefaultsに保存
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject(data, forKey: "historyList")
            userDefaults.synchronize()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

