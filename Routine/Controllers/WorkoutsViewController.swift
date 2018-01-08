//
//  WorkoutsViewController.swift
//  Routine
//
//  Created by Umar Qattan on 12/26/17.
//  Copyright © 2017 Umar Qattan. All rights reserved.
//

import UIKit

class WorkoutsViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    
    var selectedWorkout:Workout!
    
    lazy var appDelegate:AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YYYY"
        appDelegate.workouts.sort(by: { dateFormatter.date(from: $0.date)! < dateFormatter.date(from: $1.date)!})
        tableView.reloadData()
        
        navigationItem.title = "Workouts"
        navigationItem.rightBarButtonItems?.append(editButtonItem)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WorkoutExercisesViewController {
            destination.workout = selectedWorkout
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YYYY"
        appDelegate.workouts.sort(by: { dateFormatter.date(from: $0.date)! < dateFormatter.date(from: $1.date)!})
        tableView.reloadData()
        
    }
    
    @IBAction func createNewWorkout(_ sender: UIBarButtonItem) {
        
    }
}

extension WorkoutsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedWorkout = appDelegate.workouts[indexPath.row]
        performSegue(withIdentifier: "workoutExerciseSegue", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if isEditing {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            appDelegate.workouts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            
            let defaults = UserDefaults.standard
            let encodedWorkouts = NSKeyedArchiver.archivedData(withRootObject: appDelegate.workouts)
            defaults.set(encodedWorkouts, forKey: "Workouts")
            defaults.synchronize()
        }
    }
    
}

extension WorkoutsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutReuseId", for: indexPath)
        let workout = appDelegate.workouts[indexPath.row]
        cell.textLabel?.text = workout.name
        cell.detailTextLabel?.text = workout.date
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    
}
