//
//  ViewController.swift
//  Project7.1
//
//  Created by Maks Vogtman on 08/08/2022.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        let search = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(searchPetition))
        
        toolbarItems = [search]
        navigationController?.isToolbarHidden = false
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
        if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        showError()
    }
    
    
    @objc func searchPetition() {
        let ac = UIAlertController(title: "Search for the petition", message: "Type the name of the petition, you're interested in.", preferredStyle: .alert)
        ac.addTextField()
    }
    
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "This data comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        petitions.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

