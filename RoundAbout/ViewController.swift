//
//  ViewController.swift
//  RoundAbout
//
//  Created by Shannon Reardon on 6/28/19.
//  Copyright © 2019 Shannon Reardon. All rights reserved.
//

import UIKit
import NotificationCenter

class ViewController: UIViewController, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    
    var giftListItems: [GiftListItem] = []
    
    var giftItems = ["Backpack", "Backpack", "Backpack"]
    var stores = ["Kohls", "Target", "CVS"]
    var prices = ["$35", "$15", "$23"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        view.backgroundColor = .black
        
        for i in 0..<giftItems.count{
            giftListItems.append(GiftListItem(giftItem: giftItems[i], store: stores[i], price: prices[i]))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! ImageViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.giftListItem = giftListItems[selectedIndexPath.row]
        } else {
            if let selectedPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedPath, animated: true)
            }
        }
    }
    
    @IBAction func unwindFromItemtDetailViewController(segue: UIStoryboardSegue) {
        let source = segue.source as! ImageViewController
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            giftListItems[selectedIndexPath.row] = source.giftListItem
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: giftItems.count, section: 0)
            giftListItems.append((source.giftListItem))
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
    }
    
    @IBAction func editBarButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            editBarButton.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            editBarButton.title = "Done"
            addBarButton.isEnabled = false
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return giftListItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = giftListItems[indexPath.row].giftItem
        cell.detailTextLabel?.text = giftListItems[indexPath.row].store
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            giftListItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = giftListItems[sourceIndexPath.row]
        giftListItems.remove(at: sourceIndexPath.row)
        giftListItems.insert(itemToMove, at: destinationIndexPath.row)
    }
}

