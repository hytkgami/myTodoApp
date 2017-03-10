//
//  TableViewController.swift
//  TodoApp
//
//  Created by Hajime Kagami on 2017/03/10.
//  Copyright © 2017年 Hajime Kagami. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
	
	var todoList = [String]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//-----------------
		// 読み込み処理を追加
		//-----------------
		let userDefaults = UserDefaults.init()
		if let storedTodoList = userDefaults.array(forKey: "todoList") as? [String] {
			todoList.append(contentsOf: storedTodoList)
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	
	@IBAction func tapAddButton(_ sender: Any) {
		// アラートダイアログ生成
		let alertController = UIAlertController(title: "ToDoを追加",
		                                        message: "ToDoを入力してください。",
		                                        preferredStyle: UIAlertControllerStyle.alert)
		// テキストエリアを追加
		alertController.addTextField(configurationHandler: nil)
		// OKボタンを追加
		let okAction = UIAlertAction(title: "OK",
		                             style: UIAlertActionStyle.default) {
										(action: UIAlertAction) -> Void in
										// OKボタンが押されたときの処理
										if let textField = alertController.textFields?.first {
											// 前後の空白文字を削除する
											textField.text = textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
											// 空白文字かどうかを確認する処理
											if textField.text != "" {
												// todoListの配列に入力した値を先頭に挿入
												self.todoList.insert(textField.text!, at: 0)
												
												// テーブルに行が追加されたことをテーブルに通知
												self.tableView.insertRows(at: [IndexPath(row: 0,section: 0)], with: UITableViewRowAnimation.right)
												
												//--------------------
												// 保存処理を追加
												//--------------------
												let userDefaults = UserDefaults.init()
												userDefaults.set(self.todoList, forKey: "todoList")
												userDefaults.synchronize()
											}
										}
		}
		let cancelAction = UIAlertAction(title: "キャンセル",
		                                 style: UIAlertActionStyle.cancel,
		                                 handler: nil)
		alertController.addAction(okAction)
		alertController.addAction(cancelAction)
		// アラートダイアログを表示
		present(alertController, animated: true, completion: nil)
	}
	
	// テーブルの行数を返却する
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return todoList.count
	}
	
	// テーブルの行ごとのセルを返却する
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		// storyboardで指定したtodoCell識別子を利用して再利用可能なセルを取得する
		let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell")
		// 行番号に合ったToDoを取得
		let todoTitle = todoList[indexPath.row]
		// セルのラベルにToDoをセット
		cell?.textLabel!.text = todoTitle
		return cell!
	}
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		// 削除可能かどうか
		if editingStyle == .delete {
			// ToDoリストから削除
			todoList.remove(at: indexPath.row)
			// セルを削除
			tableView.deleteRows(at: [indexPath], with: .fade)
			//---------------
			// 保存処理を追加
			//---------------
			let userDefaults = UserDefaults.init()
			userDefaults.set(self.todoList, forKey: "todoList")
			userDefaults.synchronize()
		}
	}
}
