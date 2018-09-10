import UIKit
import  CoreData

protocol PDashboardView {
    func setNotes(notes : [NoteModel])
    func stopLoading()
    func startLoading()
}


class DashboardViewController:BaseViewController{
    
    @IBOutlet var bottomView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var notesNavigationItem: UINavigationItem!
    @IBOutlet var btnChangeView: UIBarButtonItem!
    @IBOutlet var searchBarConstraint: NSLayoutConstraint!
    @IBOutlet var searchBar: UISearchBar!
    
    let searchController = UISearchController(searchResultsController: nil)
    var userId:String?
    var isListView:Bool = false
    var isSearchBarVisible = false
    var searchActive = false
    var presenter:DashboardPresenter?
    var notes = [NoteModel]()
    var filteredNotes = [NoteModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        initialseView()
        presenter = DashboardPresenter(pDashboardView: self, presenterService: DashboardPresenterService())
        setupData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let presenter = presenter{
            presenter.getNotes()
        }
        
    }
    override func initialseView() {
        let cell = UINib(nibName: "DashboardNoteCell", bundle: nil)
        self.collectionView.register(cell, forCellWithReuseIdentifier: "DashboardNoteCell")
        collectionView.contentInset.bottom = 5
        collectionView.contentInset.left = 5
        collectionView.contentInset.right = 5
        collectionView.contentInset.top = 5
        UIHelper.shared.setShadow(view: bottomView)
        bottomView.layer.shadowPath = UIBezierPath(roundedRect:bottomView.bounds, cornerRadius:bottomView.layer.cornerRadius).cgPath
        let  longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        
    }
    
    func setupData(){
        if let layout = collectionView.collectionViewLayout as? PinterestLayout{
            layout.delegate = self
            layout.numberOfColumns = isListView ? 1 : 2
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        self.presenter?.getNotes()
    }
    
    @IBAction func onSideMenuTapped(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    @IBAction func takeNoteAction(_ sender: Any) {
        let stroryBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = stroryBoard.instantiateViewController(withIdentifier: "TakeNoteViewController") as! TakeNoteViewController
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onChangeViewTapped(_ sender: Any) {
        if let layout = collectionView.collectionViewLayout as? PinterestLayout{
            layout.numberOfColumns = isListView ? 2 : 1
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.reloadData()
        }
        let image = isListView ? #imageLiteral(resourceName: "list_view"):#imageLiteral(resourceName: "grid_view")
        self.isListView = self.isListView ? false : true
        btnChangeView.image = image
    }

    @IBAction func onSearchBtnPressed(_ sender: Any) {
        if isSearchBarVisible{
            self.searchBarConstraint.constant = 0
            UIView.animate(withDuration:0.5){
                self.view.layoutIfNeeded()
            }
            isSearchBarVisible = false
            searchBar.resignFirstResponder()
        }else{
            self.searchBarConstraint.constant = 44
            UIView.animate(withDuration:0.5){
                self.view.layoutIfNeeded()
            }
            isSearchBarVisible = true
            searchBar.becomeFirstResponder()
        }
        
    }
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {

        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            collectionView.endInteractiveMovement()
            self.collectionView.reloadData()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
}
extension DashboardViewController:PinterestLayoutDelegate{
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        let gridWidth = ((collectionView.bounds.width-15)/2)
        let listWidth = ((collectionView.bounds.width-10))
        let width = self.isListView ? listWidth : gridWidth
        var cellHeight:CGFloat = 0
        presenter?.getCellHeight(note: notes[indexPath.item], width:width, completion: { (height) in
                    print(height)
                    cellHeight = height
        })
        return cellHeight
    }
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, sizeForSectionFooterViewForSection section: Int) -> CGSize {
        let gridWidth = ((collectionView.bounds.width-15)/2)
        let listWidth = ((collectionView.bounds.width-10)/2)
        let width = self.isListView ? listWidth : gridWidth
        return CGSize(width: width, height: 0)
    }
    
    func collectionView(collectionView: UICollectionView, sizeForSectionHeaderViewForSection section: Int) -> CGSize {
        let gridWidth = ((collectionView.bounds.width-15)/2)
        let listWidth = ((collectionView.bounds.width-10)/2)
        let width = self.isListView ? listWidth : gridWidth
        return CGSize(width: width, height: 0)
    }
    
    
}
extension DashboardViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchActive{
            return filteredNotes.count
        }
        return self.notes.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardNoteCell", for: indexPath) as! DashboardNoteCell
        let note:NoteModel
        if searchActive{
            note = filteredNotes[indexPath.item]
        }else{
            note = notes[indexPath.item]
        }
        cell.setData(note: note)
        UIHelper.shared.setCornerRadius(view: cell)
        UIHelper.shared.setCornerRadius(view: cell.contentView)
        UIHelper.shared.setShadow(view: cell)
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let stroryBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = stroryBoard.instantiateViewController(withIdentifier: "TakeNoteViewController") as! TakeNoteViewController
        if searchActive{
            vc.note = filteredNotes[indexPath.item]
        }else{
            vc.note = notes[indexPath.item]
        }
        present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
    return true
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = notes.remove(at: sourceIndexPath.item)
        notes.insert(item, at: destinationIndexPath.item)
        collectionView.reloadData()
    }
}

extension DashboardViewController:UISearchBarDelegate{
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        isSearchBarVisible = false
        searchBarConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        presenter?.getNotes()
        searchBar.resignFirstResponder()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.isEmpty)!{
           presenter?.getNotes()
        }else{
            filteredNotes = notes.filter({ (note) -> Bool in
                return note.title.lowercased().contains(searchText.lowercased())
            })
            collectionView.reloadData()
        }
    }
}
extension DashboardViewController:PDashboardView{
    func startLoading(){
        self.activityIndicatorView.isHidden = false
        self.activityIndicatorView.startAnimating()
    }
    
    func stopLoading(){
        self.activityIndicatorView.stopAnimating()
        self.activityIndicatorView.isHidden = true
    }
    
    func setNotes(notes : [NoteModel]) {
        self.notes = notes
        self.collectionView.reloadData()
    }
}


