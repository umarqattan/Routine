//
//  ExercisesViewController.swift
//  Routine
//
//  Created by Umar Qattan on 12/25/17.
//  Copyright © 2017 Umar Qattan. All rights reserved.
//

import UIKit

class ExercisesViewController: UIViewController {
    
    var muscle:Muscle!
    var workout:Workout!
    var selectedExercises:[String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        navigationItem.title = workout.name
        selectedExercises.sort()
    }
}

extension ExercisesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedExercises.count
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseReuseId", for: indexPath)

        cell.textLabel?.text = selectedExercises[indexPath.row]
        cell.selectionStyle = .none
    
        return cell
    }
}

extension ExercisesViewController: UITableViewDelegate {
    
  
}





