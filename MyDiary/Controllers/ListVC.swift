//
//  ArticlesVC.swift
//  MyDiary
//
//  Created by Ruslan NAUMENKO on 1/25/19.
//  Copyright © 2019 Ruslan NAUMENKO. All rights reserved.
//

import UIKit
import rnaumenk2019

class ListVC: UIViewController {
    
    @IBOutlet weak var showLangButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.estimatedRowHeight = 300
            tableView.rowHeight = UITableView.automaticDimension
        }
    }
    
    private var isAllLangs = false
    
    let articleManager = ArticleManager()
    var articles: [Article]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let deviceLanguage = NSLocale.current.languageCode {
            articles = articleManager.getArticles(withLang: deviceLanguage)
        }
        else {
            articles = articleManager.getAllArticles()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isAllLangs {
            articles = articleManager.getAllArticles()
        }
        else {
            if let deviceLanguage = NSLocale.current.languageCode {
                articles = articleManager.getArticles(withLang: deviceLanguage)
            }
            else {
                showAlertController(NSLocalizedString("Device language cannot be identified", comment: "Set in code"))
            }
        }
    
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditVC" {
            let editVC = segue.destination as! EditVC
            if let article = sender as? Article {
                editVC.article = article
            }
        }
    }
    
    @IBAction func addButton(_ sender: Any) {
        performSegue(withIdentifier: "toEditVC", sender: self)
    }
    
    @IBAction func showAllButton(_ sender: Any) {
        let button = sender as! UIBarButtonItem
        
        button.isEnabled = false
        defer {
            button.isEnabled = true
        }
        
        if !isAllLangs {
            articles = articleManager.getAllArticles()
            button.title = NSLocalizedString("My lang", comment: "Set in code")
            isAllLangs = true
        }
        else {
            if let deviceLanguage = NSLocale.current.languageCode {
                articles = articleManager.getArticles(withLang: deviceLanguage)
                button.title = NSLocalizedString("All lang", comment: "Set in code")
                isAllLangs = false
            }
            else {
                showAlertController(NSLocalizedString("Device language cannot be identified", comment: "Set in code"))
            }
        }
        tableView.reloadData()
    }
}

extension ListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        
        cell.article = articles?[indexPath.row]
        
        return cell
    }
}

extension ListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "toEditVC", sender: articles?[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let delete = deleteAction(at: tableView, for: indexPath)
        
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
    
    func deleteAction(at tableView: UITableView, for indexPath: IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] (action, view, completion) in
            if let article = self.articles?[indexPath.row] {
                self.articleManager.removeArticle(article: article)
                self.articleManager.save()
                self.articles?.remove(at: indexPath.row)
            }
        
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            completion(true)
        }
        return deleteAction
    }
}
