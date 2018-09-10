import UIKit

protocol PTakeNoteView{
    func getPhoto(_ option: UIHelper.photoOptionSelected)
    func updateView()
    func updateImageView()
    func showAlert(message: String)
    func presentDashboardView()
    func pinAction()
    func archiveAction()
}

class TakeNoteViewController: BaseViewController,UITextViewDelegate,PColorDelegate {

    @IBOutlet var noteView: NoteView!
    @IBOutlet var noteViewHeightC: NSLayoutConstraint!
    @IBOutlet var showOptionConstrains: NSLayoutConstraint!
    @IBOutlet var optionMenuHeight: NSLayoutConstraint!
    @IBOutlet var optionMenuTableView: UITableView!
    @IBOutlet var optionView: UIView!
    @IBOutlet var colourOptionconstraint: NSLayoutConstraint!
    @IBOutlet var colourOptionView: ColourOptions!
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var btnPin: UIBarButtonItem!
    @IBOutlet var btnArchive: UIBarButtonItem!
    
    var image:UIImage?
    var note:NoteModel?
    var isOptionsEnabled = false
    var isColourOptionEnabled = false
    var isPinned = false
    var isArchived = false
    let optionsMenu = ["Open Gallery","Open Camera","Delete"]
    var presenter:TakeNotePresenter?
    override func viewDidLoad() {
        super.viewDidLoad()
        initialseView()
        
        
    }
    override func initialseView() {
        btnPin.target = self
        btnPin.action = #selector(onPinPressed)
        btnArchive.target = self
        btnArchive.action = #selector(onArchivePressed)
        presenter = TakeNotePresenter(pTakeNoteView: self, presenterService: TakeNotePresenterService())
        noteView.noteTextView.delegate = self
        noteView.titleTextView.delegate = self
        optionMenuTableView.delegate = self
        optionMenuTableView.dataSource = self
        optionMenuTableView.reloadData()
        optionMenuTableView.layoutIfNeeded()
        optionMenuHeight.constant = optionMenuTableView.contentSize.height
        showOptionConstrains.constant = -(optionMenuTableView.contentSize.height - 40)
        UIHelper.shared.setShadow(view: optionView)
        UIHelper.shared.setShadow(view: colourOptionView)
        colourOptionView.delegate = self
        if let recievedNote = note{
            noteView.titleTextView.insertText(recievedNote.title)
            noteView.noteTextView.insertText(recievedNote.note)
            self.view.backgroundColor = UIColor(hexString: recievedNote.colour)
            self.navigationBar.barTintColor = UIColor(hexString: recievedNote.colour)
            if let noteImage = recievedNote.image{
                noteView.imageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: (self.view.bounds.width / noteImage.getAspectRatio()))
                noteView.imageView.image = noteImage
                noteView.imageViewHeightC.constant = noteView.imageView.frame.height
                presenter?.updateImageView()
            }
            if recievedNote.is_pinned{
                btnPin.tintColor = UIColor.blue
                isPinned = true
            }
            if recievedNote.is_archived{
                btnArchive.image = UIImage(named: "unarchive")
                isArchived = true
            }
            presenter?.updateImageView()
            presenter?.updateView()
        }
    }
    
    func onChangeColor(color: String) {
        self.view.backgroundColor = UIColor(hexString: color)
        self.navigationBar.barTintColor = UIColor(hexString: color)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame
        presenter?.updateView()
    }

    
    
    @IBAction func backAction(_ sender: Any) {
        let date = Date()
        print("\(date)")
        if let receivedNote = self.note{
            presenter?.deleteNote(noteToDelete: receivedNote, completion: { (status, message) in
            })
        }
        let note = NoteModel(title: noteView.titleTextView.text, note: noteView.noteTextView.text, image:image, is_archived: isArchived, is_remidered: false, is_deleted: false, creadted_date: "\(date)", colour: (self.view.backgroundColor?.toHexString())! , note_id: "1", is_pinned: isPinned)
        if (note.image != nil || note.note != "" || note.title != ""){
            print(note.title)
            print(note.note)
            presenter?.saveNote(note: note)
             print("Saved")
        }
        presenter?.presentDashboardView()
    }
    
    @IBAction func showColourOption(_ sender: Any) {
        if isOptionsEnabled{
            showOptionConstrains.constant = -(optionMenuTableView.contentSize.height-44)
            UIView.animate(withDuration: 0.3){
                self.view.layoutIfNeeded()
            }
            isOptionsEnabled = false
        }
        if isColourOptionEnabled == false{
            colourOptionView.isHidden = false
            colourOptionconstraint.constant = -50
            UIView.animate(withDuration: 0.3){
                self.view.layoutIfNeeded()
            }
            isColourOptionEnabled = true
        }else{
            colourOptionconstraint.constant = 0
            UIView.animate(withDuration: 0.3){
                self.view.layoutIfNeeded()
            }
            isColourOptionEnabled = false
        }
        
    }
    @IBAction func showOptions(_ sender: Any) {
        if isColourOptionEnabled{
            colourOptionconstraint.constant = 0
            UIView.animate(withDuration: 0.3){
                self.view.layoutIfNeeded()
            }
            isColourOptionEnabled = false
        }
        if isOptionsEnabled == false{
            colourOptionView.isHidden = true
            showOptionConstrains.constant = 44
            UIView.animate(withDuration: 0.3){
                self.view.layoutIfNeeded()
            }
            isOptionsEnabled = true
        }else{
            showOptionConstrains.constant = -(optionMenuTableView.contentSize.height-44)
            UIView.animate(withDuration: 0.3){
                self.view.layoutIfNeeded()
            }
            isOptionsEnabled = false
        }
        
    }
    
    @IBAction func setReminder(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SetReminderView")
        present(vc, animated: true, completion: nil)
//        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
//        popOverVC.modalPresentationStyle = .overCurrentContext
//        present(popOverVC, animated: true, completion: nil)
        //self.addChildViewController(popOverVC)
        //popOverVC.view.frame = self.view.frame
        //self.view.addSubview(popOverVC.view)
        //popOverVC.didMove(toParentViewController: self)
    }
   @objc func onPinPressed() {
        presenter?.performPinAction()
    }

    @objc func onArchivePressed() {
        presenter?.performArchiveAction()
    }
}

extension TakeNoteViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsMenu.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! OptionCell
        cell.optionLabel(label: optionsMenu[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            presenter?.getPhoto(.gallary)
            break
        case 1:
            presenter?.getPhoto(.camera)
            break
        case 2:
            presenter?.deleteNote(noteToDelete: self.note!, completion: { (status, message) in
                showAlert(message: message)
            })
            break
        default:
            break
        }
    }
    
    
    
}

extension TakeNoteViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Cant find the image.")
        }
        image = selectedImage
        noteView.imageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: (self.view.bounds.width / selectedImage.getAspectRatio()))
        noteView.imageView.image = selectedImage
        noteView.imageViewHeightC.constant = noteView.imageView.frame.height
        presenter?.updateImageView()
        dismiss(animated: true, completion: nil)
    }
}


extension UIImage{
    func getAspectRatio()->CGFloat{
        return CGFloat(self.size.width/self.size.height)
    }
}


extension TakeNoteViewController:PTakeNoteView {
    func getPhoto(_ option: UIHelper.photoOptionSelected){
        switch option{
        case .camera:
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
            break
        case .gallary:
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
            break
        }
    }
    
    
    func updateView(){
        var height:CGFloat = 24
        let titleHeight = noteView.titleTextView.frame.size.height
        let noteHeight = noteView.noteTextView.frame.size.height
        let imageViewHeight = noteView.imageView.frame.height
        
        if titleHeight >= 30{
            noteView.titleHeightContraint.constant = titleHeight
            height = height + titleHeight
        }else{
            noteView.titleHeightContraint.constant = 30
            height = height + 30
        }
        if noteHeight >= 30{
            height = height + noteHeight
            noteView.noteHeightConstraint.constant = noteHeight
        }else{
            height = height + 30
            noteView.noteHeightConstraint.constant = 30
        }
        if image != nil{
            height = height + imageViewHeight
        }else{
            noteView.imageViewHeightC.constant = 0
        }
        noteViewHeightC.constant = height
    }
    
    func updateImageView(){
        let imageViewHeight = noteView.imageView.frame.height
        var height = noteViewHeightC.constant
        if image != nil{
            height = height + imageViewHeight
        }else{
            noteView.imageViewHeightC.constant = 0
        }
        noteViewHeightC.constant = height
    }
    func showAlert(message: String) {
        let alert = UIAlertController(title: message, message: nil , preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            if message == "Deleted"{
                self.presenter?.presentDashboardView()
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func presentDashboardView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func pinAction(){
        if isPinned{
            btnPin.tintColor = UIColor(hexString: "#919191")
            isPinned = false
        }
        else{
            btnPin.tintColor = UIColor.blue
            isPinned = true
        }
    }
    func archiveAction(){
        if isArchived{
            btnArchive.image = UIImage(named: "archive")
            isArchived = false
        }else{
            btnArchive.image = UIImage(named: "unarchive")
            isArchived = true
        }
    }
}



