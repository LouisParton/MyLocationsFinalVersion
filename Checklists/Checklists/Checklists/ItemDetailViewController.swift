//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Louis Parton on 1/25/23.
//

import UIKit
protocol AddItemViewControllerDelegate: AnyObject {
  func itemDetailViewControllerDidCancel(
    _ controller: ItemDetailViewController)
  func itemDetailViewController(
    _ controller: ItemDetailViewController,
    didFinishAdding item: ChecklistItem
  )
    func itemDetailViewController(
      _ controller: ItemDetailViewController,
      didFinishEditing item: ChecklistItem
    )

}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
      textField.resignFirstResponder()

      if switchControl.isOn {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) {_, _ in
          // do nothing
        }
      }
    }

    weak var delegate: AddItemViewControllerDelegate?
    var itemToEdit: ChecklistItem?

    // MARK: - Actions
    @IBAction func cancel() {
      delegate?.itemDetailViewControllerDidCancel(self)
    }

    @IBAction func done() {
      if let item = itemToEdit {
        item.text = textField.text!

        item.shouldRemind = shouldRemindSwitch.isOn
        item.dueDate = datePicker.date
        item.scheduleNotification()
        delegate?.itemDetailViewController(
          self,
          didFinishEditing: item)
      } else {
        let item = ChecklistItem()
        item.text = textField.text!
        item.checked = false

        item.shouldRemind = shouldRemindSwitch.isOn
        item.dueDate = datePicker.date               
        item.scheduleNotification()
        delegate?.itemDetailViewController(
          self,
          didFinishAdding: item)
      }
    }




    override func viewDidLoad() {
      super.viewDidLoad()

      if let item = itemToEdit {
        title = "Edit Item"
        textField.text = item.text
        doneBarButton.isEnabled = true
        shouldRemindSwitch.isOn = item.shouldRemind
        datePicker.date = item.dueDate
      }
    }

    // MARK: - Table View Delegates
    override func tableView(
      _ tableView: UITableView,
      willSelectRowAt indexPath: IndexPath
    ) -> IndexPath? {
      return nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      textField.becomeFirstResponder()
    }

    // MARK: - Text Field Delegates
    func textField(
      _ textField: UITextField,
      shouldChangeCharactersIn range: NSRange,
      replacementString string: String
    ) -> Bool {
      let oldText = textField.text!
      let stringRange = Range(range, in: oldText)!
      let newText = oldText.replacingCharacters(
        in: stringRange,
        with: string)
      if newText.isEmpty {
        doneBarButton.isEnabled = false
      } else {
        doneBarButton.isEnabled = true
      }
      return true
    }
    // under here optional i think
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
      doneBarButton.isEnabled = false
      return true
    }
    

}
