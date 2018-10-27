//
//  AddTodoViewController.swift
//  ToDoApp
//
//  Created by Lucas Dahl on 10/25/18.
//  Copyright © 2018 Lucas Dahl. All rights reserved.
//

import UIKit
import CoreData

class AddTodoViewController: UIViewController {
    
    // MARK: - Properties
    var managedContext: NSManagedObjectContext!
    var todo: Todo?
    
    // MARK: Outlets
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Listen for keyboard notifaction
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(with:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        textView.becomeFirstResponder()
        
        if let todo = todo {
            textView.text = todo.title // Needs to be set because of a xcode bug
            textView.text = todo.title
            segmentedControl.selectedSegmentIndex = Int(todo.priority)
        }
        
    }
    
    // MARK: Actions
    @objc func keyboardWillShow(with notification: Notification) {
        
        // Get the key for the keyboardframe
        let keyForKeyboard = "UIKeyboardFrameEndUserInfoKey"
        
        guard let keyboardFrame = notification.userInfo?[keyForKeyboard] as? NSValue else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height + 16
        
        bottomConstraint.constant = keyboardHeight
        
        // restest the constraints
        UIView.animate(withDuration: 0.3) {
            
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        
       dismissAndResign()
        
    }
    
    fileprivate func dismissAndResign() {
        // Dismisses the VC
        dismiss(animated: true)
        
        // Clears the textView
        textView.resignFirstResponder()
    }
    
    @IBAction func doneTapped(_ sender: UIButton) {
        
        // CHeck for text in the text field
        guard let title = textView.text, !title.isEmpty else {
            // TODO: add alert for putting something in the text view
            return
        }
        
        // Check if the object(todo) already exists
        if let todo = self.todo {
            todo.title = title
            todo.priority = Int16(segmentedControl.selectedSegmentIndex)
        } else {

            // Construct Todo
            let todo = Todo(context: managedContext)
            todo.title = title
            todo.priority = Int16(segmentedControl.selectedSegmentIndex)
            todo.date = Date()
        }
        // Saves the todo
        do {
            try managedContext.save()
            
            dismissAndResign()
            
        } catch {
            print("Error saving todo: \(error)")
        }
    }

} // End class

extension AddTodoViewController: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        
        // When the user presses any  button the done button appears
        if doneButton.isHidden {
            
            // Clear out the textView
            textView.text.removeAll()
            
            // Change the text color to solid white
            textView.textColor = .white
            
            // Unhide the button
            doneButton.isHidden = false
            
            // Animate the reapperance of the done button
            UIView.animate(withDuration: 0.3) {
                
                self.view.layoutIfNeeded()
                
            }
            
        }
        
    }
    
}
