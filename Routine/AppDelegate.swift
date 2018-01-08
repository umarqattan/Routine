//
//  AppDelegate.swift
//  Routine
//
//  Created by Umar Qattan on 12/24/17.
//  Copyright © 2017 Umar Qattan. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var workouts:[Workout] = []
    var exercises:[String] = []
    var muscles:[Muscle]   = []
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let decodedWorkoutObjects = UserDefaults.standard.object(forKey: "Workouts") as? Data, let decodedWorkouts = NSKeyedUnarchiver.unarchiveObject(with: decodedWorkoutObjects) as? [Workout] {
            print("Loading Workout Data from NSDefaults\n\n\n")
            for decodedWorkout in decodedWorkouts {
                self.workouts.append(decodedWorkout)
            }
            self.workouts.sort(by: {$0.date < $1.date})
        } else if let path = Bundle.main.path(forResource: "workout_data", ofType: "json") {
            print("Loading Workout Data from JSON\n\n\n\n")
            do {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url, options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [String:Any], let workouts = jsonResult["workouts"] as? [[String:Any]] {
                    for workout in workouts {
                        let t_name = workout["name"] as! String
                        let t_exercises = workout["exercises"] as! [[String:Any]]
                        let t_date = workout["date"] as! String
                        let t_muscles = workout["muscles"] as! [String]
                        var model_exercises = [Exercise]()
                        for t_exercise in t_exercises {
                            let model_exercise_name = t_exercise["name"] as! String
                            let model_exercise_weight = t_exercise["weight"] as! Float
                            let model_exercise_sets = t_exercise["sets"] as! Int
                            let model_exercise_reps = t_exercise["reps"] as! Int
                            let model_exercise_notes = t_exercise["notes"] as! String
                            let model_t_exercise = Exercise(name: model_exercise_name, weight: model_exercise_weight, sets: model_exercise_sets, reps: model_exercise_reps, notes: model_exercise_notes)
                            model_exercises.append(model_t_exercise)
                            
                        }
                        
                        let model_t_workout = Workout(name: t_name, muscles: t_muscles, exercises: model_exercises, date: t_date)
                        self.workouts.append(model_t_workout)
                        
                    }
                    let defaults = UserDefaults.standard
                    let encodedWorkouts = NSKeyedArchiver.archivedData(withRootObject: self.workouts)
                    defaults.set(encodedWorkouts, forKey: "Workouts")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        if let decodedObject = UserDefaults.standard.object(forKey: "Muscles") as? Data, let decodedMuscles = NSKeyedUnarchiver.unarchiveObject(with: decodedObject) as? [Muscle] {
            print("Loading Muscle Data from NSDefaults\n\n\n")
            for decodedMuscle in decodedMuscles {
                decodedMuscle.exercises.sort(by: {$0 < $1})
                self.muscles.append(decodedMuscle)
            }
            self.muscles.sort(by: {$0.name < $1.name})
        } else if let path = Bundle.main.path(forResource: "exercise_data", ofType: "json") {
            print("Loading Muscle Data from JSON\n\n\n\n")
            do {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url, options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [String:Any], let muscles = jsonResult["muscles"] as? [[String:Any]] {
                    for muscle in muscles {
                        let t_muscle    = muscle["name"] as! String
                        let t_exercises = muscle["exercises"] as! [String]
                        self.exercises = t_exercises
                        self.exercises.sort(by: {$0 < $1})
                        self.muscles.append(Muscle(name: t_muscle, exercises: self.exercises))
                        print("Muscle: \(t_muscle)\nExercises: \(t_exercises)\n\n")
                    }
                    
                    self.muscles.sort(by: {$0.name < $1.name})
                    // Encode objects to NSKeyedArchiver to retrieve it later on
                    let defaults = UserDefaults.standard
                    let encodedMuscles = NSKeyedArchiver.archivedData(withRootObject: self.muscles)
                    defaults.set(encodedMuscles, forKey: "Muscles")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        return true
    }

   
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Routine")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

