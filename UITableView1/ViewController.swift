//
//  ViewController.swift
//  UITableView1
//
//  Created by Damir Chalkarov on 03.08.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var contacts = Source.makeContactsWithGroup()
    
    let tableView: UITableView = .init(frame: .zero, style: .insetGrouped)
    let editButton = UIButton()
    let reloadButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupButton()
        
        tableView.register(ContactCell.self, forCellReuseIdentifier: "ContactCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorColor = .red
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
    case 0: return "Group 1"
    case 1: return "Group 2"
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactCell else { fatalError() }
        
//        cell.configure(contact: contacts[indexPath.row])
        cell.configure(contact: contacts[indexPath.section][indexPath.row])
        
         return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        contacts[indexPath.section].remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .bottom)
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let contact = contacts[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        contacts[destinationIndexPath.section].insert(contact, at: destinationIndexPath.row)
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ac = UIAlertController(
            title: contacts[indexPath.section][indexPath.row].name,
            message: contacts[indexPath.section][indexPath.row].description,
            preferredStyle: .alert
        )
        ac.addAction(.init(title: "Ok", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
}

extension ViewController {
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ViewController {
    func setupButton() {
        view.addSubview(editButton)
        view.addSubview(reloadButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.setTitleColor(.black, for: .normal)
        editButton.setTitleColor(.gray, for: .highlighted)
        NSLayoutConstraint.activate([
            editButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            editButton.trailingAnchor.constraint(equalTo: reloadButton.trailingAnchor, constant: 10),
            editButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
//            editButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -26)
        ])
        
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        reloadButton.setTitleColor(.black, for: .normal)
        reloadButton.setTitleColor(.gray, for: .highlighted)
        NSLayoutConstraint.activate([
            reloadButton.leadingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: 10),
            reloadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            reloadButton.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 8),
            reloadButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -26)
        ])
    
        editButton.setTitle("Edit", for: .normal)
        reloadButton.setTitle("Reload", for: .normal)
        editButton.addTarget(self, action: #selector(edit(sender: )), for: .touchUpInside)
        reloadButton.addTarget(self, action: #selector(reload(sender: )), for: .touchUpInside)
        
        editButton.layer.cornerRadius = 15
        editButton.layer.borderColor = UIColor.black.cgColor
        editButton.layer.borderWidth = 1
        
        reloadButton.layer.cornerRadius = 15
        reloadButton.layer.borderColor = UIColor.black.cgColor
        reloadButton.layer.borderWidth = 1
    }
    
    @objc func reload(sender: UIButton) {
        contacts = Source.makeContactsWithGroup()
        tableView.reloadData()
        
//        tableView.isEditing.toggle()
//        editButton.setTitle(tableView.isEditing ? "End editing" : "Edit", for: .normal)
    }
    
    @objc func edit(sender: UIButton) {
        tableView.isEditing.toggle()
        editButton.setTitle(tableView.isEditing ? "End editing" : "Edit", for: .normal)
    }
}

