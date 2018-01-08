//
//  WorkoutExercisesViewController.swift
//  Routine
//
//  Created by Umar Qattan on 12/26/17.
//  Copyright © 2017 Umar Qattan. All rights reserved.
//

import UIKit

class WorkoutExercisesViewController: UIViewController {
    
    var workout:Workout!
    
    @IBOutlet weak var tableView:UITableView!
    
    
    lazy var appDelegate:AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.title = workout.name
        tableView.dataSource = self
        tableView.delegate = self
        
        
        tableView.tableFooterView = UIView()
        navigationItem.rightBarButtonItem = editButtonItem
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "editWorkoutExerciseSegue", let destination = segue.destination as? EditWorkoutExercisesTableViewController, let indexPath = sender as? IndexPath {
            destination.exercise = workout.exercises[indexPath.row]
            destination.workout = workout
        }
    }
    

}

extension WorkoutExercisesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let originalWorkoutIndex = appDelegate.workouts.index(of: workout)!
            let deletedExercise = appDelegate.workouts[originalWorkoutIndex].exercises.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .left)
            let defaults = UserDefaults.standard
            let encodedWorkouts = NSKeyedArchiver.archivedData(withRootObject: appDelegate.workouts)
            defaults.set(encodedWorkouts, forKey: "Workouts")
            defaults.synchronize()
            
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if isEditing {
            return true
        } else {
            return false
        }
    }
    
}


extension WorkoutExercisesViewController: UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout.exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutExerciseReuseId", for: indexPath) as! WorkoutExerciseTableViewCell
        let exercise = workout.exercises[indexPath.row]
        cell.configure(exercise: exercise)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditing {
            return
        }
        
        performSegue(withIdentifier: "editWorkoutExerciseSegue", sender: indexPath)
        
        
    }
    
    
}


