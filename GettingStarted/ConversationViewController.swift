//
//  ConversationViewController.swift
//  GettingStarted
//
//  Created by Paul Ardeleanu on 20/11/2019.
//  Copyright © 2019 Nexmo. All rights reserved.
//

import UIKit
import NexmoClient
import CryptoSwift
class ConversationViewController: UIViewController {

    var user: User!
    var error: Error?
    var conversation: NXMConversation?
    var events: [NXMEvent]?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var inputTextFieldBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var conversationTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(self.logout))
        inputTextField.delegate = self
        conversationTextView.text = ""
        updateInterface()
        getConversation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Conversation with \(user.interlocutor.rawValue)"
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func logout() {
        NXMClient.shared.logout()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        if let kbSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.size {
            inputTextFieldBottomConstraint.constant = kbSize.height + 10
        }
    }

    func updateInterface() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // default interface - loading screen
            self.activityIndicator.startAnimating()
            self.statusLabel.alpha = 1.0
            self.statusLabel.text = "Loading..."
            self.conversationTextView.alpha = 0
            self.inputTextField.alpha = 0
            
            // if error found, show it
            if let error = self.error {
                self.activityIndicator.stopAnimating()
                self.statusLabel.text = error.localizedDescription
                return
            }
            
            // the conversation is being retrieved
            guard self.conversation != nil else {
                self.statusLabel.text = "Loading conversation..."
                return
            }
            
            // the conversation events are being retrieved
            guard let events = self.events else {
                self.statusLabel.text = "Loading events..."
                return
            }
            
            // ready to display events
            self.activityIndicator.stopAnimating()
            self.statusLabel.alpha = 0.0
            self.conversationTextView.alpha = 1
            self.inputTextField.alpha = 1
            
            // no events found
            if events.count == 0 {
                self.conversationTextView.text = "No messages yet"
                return
            }
            
            self.conversationTextView.text = ""
            
            // events found - show them based on their type
            events.forEach { (event) in
                if let memberEvent = event as? NXMMemberEvent {
                    self.showMemberEvent(event: memberEvent)
                }
                if let textEvent = event as? NXMTextEvent {
                    self.showTextEvent(event: textEvent)
                }
            }
            
        }
    }
    
    //MARK: Show events
    
    func showMemberEvent(event: NXMMemberEvent) {
        switch event.state {
        case .invited:
            addConversationLine("\(event.member.user.name) was invited.")
        case .joined:
            addConversationLine("\(event.member.user.name) joined.")
        case .left:
            addConversationLine("\(event.member.user.name) left.")
        @unknown default:
            fatalError("Unknown member event state.")
        }
    }
    func showTextEvent(event: NXMTextEvent) {
        if let message = event.text {
            let formattedMessage = message.replacingOccurrences(of: "[\\[\\] ]", with: "", options: .regularExpression)
            let array = formattedMessage.components(separatedBy: ",")
            let intAr = array.map {  UInt8($0) ?? 0 }
            let decrypteddMessage = self.decrypt(data: intAr) ?? message
            addConversationLine("\(event.fromMember?.user.name ?? "A user") said: '\(decrypteddMessage)'")
        }
    }

    func addConversationLine(_ line: String) {
        if let text = conversationTextView.text, text.lengthOfBytes(using: .utf8) > 0 {
            conversationTextView.text = "\(text)\n\(line)"
        } else {
            conversationTextView.text = line
        }
    }
    
    
    //MARK: Fetch Conversation
    
    func getConversation() {
        NXMClient.shared.getConversationWithUuid(User.conversationId) { [weak self] (error, conversation) in
               self?.error = error
               self?.conversation = conversation
               self?.updateInterface()
               if conversation != nil {
                   self?.getEvents()
               }
            conversation?.delegate = self  // set self as delegate
           }
    }
    
    func getEvents() {
        guard let conversation = self.conversation else {
            return
        }
        conversation.getEvents { [weak self] (error, events) in
            self?.error = error
            self?.events = events
            self?.updateInterface()
        }
    }
    
    
    //MARK: Send a message
    
    func send(message: Array<UInt8>?) {
        inputTextField.resignFirstResponder()
        inputTextField.isEnabled = false
        activityIndicator.startAnimating()
        if let bytes = message {
            conversation?.sendText("\(bytes)", completionHandler: { [weak self] (error) in
                 DispatchQueue.main.async { [weak self] in
                     self?.inputTextField.isEnabled = true
                     self?.activityIndicator.stopAnimating()
                 }
             })
        } else {
            print("Error message was nil")
        }

    }
    
    // Encrypt
    
    func encrypt(message: String) -> Array<UInt8>? {
        if let aes = try? AES(key: "1234567890123456", iv: "abdefdsrfjdirogf"),
            let aesE = try? aes.encrypt(Array(message.utf8)) {
            return aesE
        }
        return nil
    }
    
    // Decrypt
    
    func decrypt(data: Array<UInt8>) -> String? {
        if let aes = try? AES(key: "1234567890123456", iv: "abdefdsrfjdirogf") {
            if let aesD = try? aes.decrypt(data) {
                let decrypted = String(bytes: aesD, encoding: .utf8)
                return decrypted
            }
            return nil
            
        }
        return nil
    }
}


extension ConversationViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        inputTextFieldBottomConstraint.constant = 10
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            let encryptedMessage = self.encrypt(message: text)
            send(message: encryptedMessage)
        }
        textField.text = ""
        textField.resignFirstResponder()
        return true
    }
    
}


//MARK: Conversation Delegate


//MARK: Conversation Delegate

extension ConversationViewController: NXMConversationDelegate {
    func conversation(_ conversation: NXMConversation, didReceive error: Error) {
        NSLog("Conversation error: \(error.localizedDescription)")
    }
    func conversation(_ conversation: NXMConversation, didReceive event: NXMTextEvent) {
        self.events?.append(event)
        DispatchQueue.main.async { [weak self] in
            self?.updateInterface()
        }
    }
}
