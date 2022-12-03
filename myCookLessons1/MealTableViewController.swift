            //
//  MealTableViewController.swift
//  TestmultiView
//
//  Created by coder on 29.12.20.
//  Copyright © 2020 coder. All rights reserved.
//

import UIKit
import os.log

    class MealTableViewController: UITableViewController {
               
                
                
                
    
    // MARK: Properties
    
    var meals = [Meal]()
    var filteredMeal: [Meal] = []
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    var permission: Bool!
    //var webmeals = [WebMeal]()
    //var homeModel = HomeModel()
    //var savedMeals: [Meal]?
    var meal: Meal?
    var check: Bool = true
    var name: String?
    var photo: String = ""
    var lessonsLearned: String?
    var rating: Int?
    var action: Bool = false
    var delname: String = ""
    var i: Int = 0
    var newRating: Int = 0
    static var nc = NotificationCenter.default
        
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Mark: Initialization
        
        self.tableView.delegate = self
        //self.tableView.dataSource = self
      
        
        //Use the edit button item provided by the table view controller
    
        navigationItem.leftBarButtonItem = editButtonItem
        self.navigationItem.leftBarButtonItem?.title = "Delete"
        
        //Load any saved meals, otherwise load sample data.
        
        if let savedMeals = loadMeals() {
            meals += savedMeals
        } // end if
    
       
       
        // Configure SearchController
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
       
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    
    }// end override func viewdidload
        
        deinit {
            NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        }
        @objc fileprivate func willEnterForeground() {
           
            if let savedMeals = loadMeals() {
                meals += savedMeals
            } // end if
            
        }// end willEnetrForeground
        
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
               return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering { return filteredMeal.count}
        return meals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        func getDocumentsDirectory() -> URL {
            let  paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths[0]
        } // end getDocumentsDirectory
        
        //Table view cells are reused and should be dequeued using a cell identifier
        
        let  cellIdentifier = "MealTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell")
                }
        //Fetches the appropriate meal for the dat source layout.
        
        let  meal: Meal
        
        if isFiltering {
            meal = filteredMeal[indexPath.row]
        } else {
            meal = meals[indexPath.row]
        }
        
        cell.nameLabel.text = meal.name
        let  path = getDocumentsDirectory().appendingPathComponent(meal.photo)
        
        cell.photoImageView.image = UIImage(contentsOfFile: path.path)
        cell.ratingControl.rating  = meal.rating
        
        return cell
    } // end tableView(_ tableView: UITableView, cellForRowAt

    
    // Override to support conditional editing of the table view.
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
    // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        //Delete the row from the web data source
        
        if editingStyle == .delete {
     
          
          
            //remove meal from meals
            
            meals.remove(at: indexPath.row)
            
            // save meals
            
            saveMeals()
        
            // delete meal from the table view
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
    }// end of override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     //if editingStyle == .delete

  

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        
        case "AddItem": os_log("Adding a new meal.", log:OSLog.default, type: .debug)
        
        case "ShowDetail":
            
        guard let mealDetailViewController = segue.destination as? MealViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
            
           
        }
        guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
                }
        guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
                }
        if isFiltering {
            
            mealDetailViewController.meal = filteredMeal[indexPath.row]
        } else {
            
            mealDetailViewController.meal = meals[indexPath.row]
            }
        
        default:
            fatalError("Unexpected Segue Identifier: \(segue.identifier)")
            
           
        }
    
    }
    
    //MARK: Actions
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? MealViewController,
            
            let meal = sourceViewController.meal {
         
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
            
    //Update an existing meal
            
                    meals[selectedIndexPath.row] = meal
                    tableView.reloadRows(at: [selectedIndexPath], with: .none)
     
    
        
                } // end if let selected index path
        
                else {
                    // Add a new meal.
            
                    let newIndexPath = IndexPath(row: meals.count, section: 0)
            
                    name = meal.name
                    photo = meal.photo
                    rating = meal.rating
                    lessonsLearned = meal.lessonsLearned
                

                // Add the meal to meals
                
                meals.append(meal)
                    
                // Add the meal to tableView
                    
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
                } // end else
            
            //Save the meals
        
            saveMeals()
      
        }// end if let sourceViewController = sender.source as? MealViewController,let meal = sourceViewController.meal
        
    } // end @IBAction func unwindToMealList
    
    
    
    //MARK: Private Methods
    
   
    
    // save meals
    
    private func saveMeals() {
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
   
    }
  

    // load meals
    
    private func loadMeals() -> [Meal]? {
        
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    
    } // end of private func loadMeals
    
    
    func filterContentForSearchText(_searchText: String) {
        
        filteredMeal = meals.filter {
            
            (meal: Meal) -> Bool in return meal.name.lowercased().contains(_searchText.lowercased())
        }
        tableView.reloadData()
        
    } // end func filterContentForSearchText
    
  
        
    } // end of main
    
    
            
            
    extension MealTableViewController: UISearchResultsUpdating {
        
        func updateSearchResults ( for searchController: UISearchController) {
            
            //TODO
            
            let searchBar = searchController.searchBar
            filterContentForSearchText(_searchText: searchBar.text!)
            
        } // end func updateSearchResults
        
    }// end extension MealTableViewController: UISearchResultsUpdating
            
  
