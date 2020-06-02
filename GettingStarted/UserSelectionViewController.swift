//
//  UserSelectionViewController.swift
//  GettingStarted
//
//  Created by Paul Ardeleanu on 19/11/2019.
//  Copyright © 2019 Nexmo. All rights reserved.
//

import UIKit
import NexmoClient

class UserSelectionViewController: UIViewController {

    @IBOutlet weak var loginJaneButton: UIButton!
    @IBOutlet weak var loginJoeButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    
    let client = NXMClient.shared
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateInterface()
        
        // test fetch convo list
        WebManager.fetchConversations()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func loginAsTom(_ sender: Any) {
        loginAs(user: User.tom)
    }
    
    @IBAction func loginAsApurva(_ sender: Any) {
        loginAs(user: User.apurva)
    }
    
    //MARK: Setup Nexmo Client
    func loginAs(user: User) {
        self.user = user
        client.setDelegate(self)
        client.login(withAuthToken: user.jwt)
        
        client.getConversationWithUuid(self.user!.uuid) { (error, response) in
            
            print(response)
        }
    }
    
    func updateInterface() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // blank state
            self.loginJaneButton.alpha = 1
            self.loginJoeButton.alpha = 1
            self.activityIndicator.stopAnimating()
            self.statusLabel.alpha = 0
            
            guard let user = self.user else {
                return
            }
            switch self.client.connectionStatus {
            case .disconnected:
                self.statusLabel.text = "Disconnected"
                self.statusLabel.alpha = 1
            case .connecting:
                self.loginJaneButton.alpha = 0
                self.loginJoeButton.alpha = 0
                self.activityIndicator.startAnimating()
                self.statusLabel.text = "Connecting as \(user.rawValue)..."
                self.statusLabel.alpha = 1
            case .connected:
                self.loginJaneButton.alpha = 0
                self.loginJoeButton.alpha = 0
                self.statusLabel.text = "Connected as \(user.rawValue)."
                self.statusLabel.alpha = 1
            @unknown default:
                self.statusLabel.text = ""
                self.statusLabel.alpha = 0
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMessages", let user = sender as? User, let destination = segue.destination as? ConversationViewController {
            destination.user = user
        }
    }
}

//MARK:- NXMClientDelegate

extension UserSelectionViewController: NXMClientDelegate {

    func client(_ client: NXMClient, didChange status: NXMConnectionStatus,
            reason: NXMConnectionStatusReason) {
        print("connectionStatusChanged\n    - status: \(status.description())")
        print("    - reason: \(reason.description())")
        updateInterface()
        if status == .connected, let user = self.user {
            performSegue(withIdentifier: "showMessages", sender: user)
        }
    }

    func client(_ client: NXMClient, didReceiveError error: Error) {
        print("✆  ‼️ connection error: \(error.localizedDescription)")
        updateInterface()
    }

}
