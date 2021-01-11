//
//  ViewController.swift
//  GarageDoorOpener
//
//  Created by Austin Bailie on 2020-12-25.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var ref: DatabaseReference! = Database.database().reference()

    var DoorStatus = ""
    var isDoorOperating = false
    var isDoorAnimating = false
    
    @IBOutlet weak var doorButton: UIButton!
    
    @IBOutlet weak var doorPieceOne: UIView!
    @IBOutlet weak var doorPieceTwo: UIView!
    @IBOutlet weak var doorPieceThree: UIView!
    
    @IBOutlet weak var doorLabel: UILabel!
    @IBOutlet weak var connectionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectionStatus()
        loadValues()
        setupUI()
        view.bringSubviewToFront(doorButton)
        
    }
    
    // Creates the loading indicator with colors and width.
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.black], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    // Door actions for when button is pressed. Makes calls to database.
    @IBAction func triggerDoor(_ sender: UIButton) {
        
        loadValues()
        
        if self.DoorStatus == "Open" { // CLOSING DOOR
            
            ref.child("DoorCommand").setValue("Close")
            self.DoorStatus = "Closed"
            isDoorOperating = true
            
            if isDoorAnimating == false {
                animateDoorClosing()
            }
            
            doorLabel.text = "Door Is Closing..."
            
            loadingIndicator.isAnimating = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                self.loadingIndicator.isAnimating = false
                self.isDoorOperating = false
            }
            
        }else if self.DoorStatus == "Closed" { // OPENING DOOR
            
            ref.child("DoorCommand").setValue("Open")
            self.DoorStatus = "Open"
            isDoorOperating = true
            
            if isDoorAnimating == false {
                animateDoorOpening()
            }
            
            doorLabel.text = "Door Is Opening.."
            
            loadingIndicator.isAnimating = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                self.loadingIndicator.isAnimating = false
                self.isDoorOperating = false
            }
            
        }
        
    }
    
    // A listener for the variable DoorStatus in the DB, updates the door icon on change.
    func loadValues() {
        
        ref.child("DoorStatus").observe(DataEventType.value, with: { (snapshot) in
            self.DoorStatus = snapshot.value as! String
            self.updateDoorStatus()
        })
    }
    
    // Animates the door opening.
    func animateDoorOpening() {
        
        isDoorAnimating = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.doorPieceThree.alpha = 0
        }, completion: {
            _ in
            self.doorPieceThree.isHidden = true
            
            UIView.animate(withDuration: 0.5, animations: {
                self.doorPieceTwo.alpha = 0
            }, completion: {
                _ in
                self.doorPieceTwo.isHidden = true
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.doorPieceOne.alpha = 0
                }, completion: {
                    _ in
                    self.doorPieceOne.isHidden = true
                    self.isDoorAnimating = false
                })
            })
        })
    }
    
    // Animates the door closing.
    func animateDoorClosing() {
        
        isDoorAnimating = true
        
        self.doorPieceOne.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.doorPieceOne.alpha = 1
        }, completion: {
            _ in
            
            self.doorPieceTwo.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.doorPieceTwo.alpha = 1
            }, completion: {
                _ in
                
                self.doorPieceThree.isHidden = false
                UIView.animate(withDuration: 0.5, animations: {
                    self.doorPieceThree.alpha = 1
                    
                },completion: {
                    _ in
                    
                    self.isDoorAnimating = false
                })
            })
        })
    }
    
    // Called by the DB listener, updates labels and door icon.
    func updateDoorStatus() {
        
        if self.DoorStatus == "Open" {
            
            if self.isDoorOperating == false && isDoorAnimating == false {
                
                animateDoorOpening()
            }
            
            doorLabel.text = "Door Is Open"
            
        }else if self.DoorStatus == "Closed" {
            
            if self.isDoorOperating == false && isDoorAnimating == false {
                
                animateDoorClosing()
            }
            
            doorLabel.text = "Door Is Closed"
        }
    }
    
    // Updates label the indicates connection to the database.
    func connectionStatus() {
        
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        
        connectedRef.observe(.value, with: { snapshot in
            
            if snapshot.value as? Bool ?? false {
            
                self.connectionLabel.text = "Connected"
                self.connectionLabel.textColor = .green
            
            } else {
            
                self.connectionLabel.text = "Connection Lost..."
                self.connectionLabel.textColor = .red
            }
        })
    }
    
    // Adds the indicator subview to the view and applies constraints.
    private func setupUI() {
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: self.view.centerXAnchor),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: self.view.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 300),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    }

    
    
}

