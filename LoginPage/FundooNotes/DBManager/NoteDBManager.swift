import Foundation
import UIKit
import CoreData

class NoteDBManager{
    
    private init(){
    }
    
    static var context:NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LoginPage")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    static func saveNote(note:NoteModel){
        let DBNote = Note(context:NoteDBManager.context)
        if let noteImage = note.image{
            if let image = UIImagePNGRepresentation(noteImage) as NSData?
            {
                DBNote.image = image
            }
        }
        DBNote.colour = note.colour
        DBNote.creadted_date = note.creadted_date
        DBNote.is_archived = note.is_archived
        DBNote.is_deleted = note.is_remidered
        DBNote.is_deleted = note.is_deleted
        DBNote.note = note.note
        DBNote.note_id = note.note_id
        DBNote.title = note.title
        DBNote.is_pinned = note.is_pinned
        saveContext()
        print("Saved1")
    }
    static func getNotes(completion:([NoteModel])->Void){
        var notes = [NoteModel]()
        do{
            let fetchRequest:NSFetchRequest<Note> = Note.fetchRequest()
            let dBNotes = try self.context.fetch(fetchRequest)
            for note in dBNotes{
                if let image = note.image{
                    let noteImage = UIImage(data: image as Data)
                    notes.append(NoteModel(title: note.title!, note: note.note!, image: noteImage, is_archived: note.is_archived, is_remidered: note.is_remidered, is_deleted: note.is_deleted, creadted_date: note.creadted_date!, colour: note.colour!, note_id: note.note_id!, is_pinned: note.is_pinned))

                    
                }else{
                    notes.append(NoteModel(title: note.title!, note: note.note!, image: nil, is_archived: note.is_archived, is_remidered: note.is_remidered, is_deleted: note.is_deleted, creadted_date: note.creadted_date!, colour: note.colour!, note_id: note.note_id!, is_pinned: note.is_pinned))
                }

            }
            print("returned")
            completion(notes)
        }catch{
            
        }
    }
    
   static  func deleteNote(noteToDelete:NoteModel,completion:(Bool,String)->Void){
        do{
            let fetchRequest:NSFetchRequest<Note> = Note.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "title = %@", noteToDelete.title)
            let dBNotes = try self.context.fetch(fetchRequest)
            if let note = dBNotes.first{
                self.context.delete(note)
                saveContext()
                completion(true, "Deleted")
            }else{
                completion(false, "Note not found")
                return
            }
        }catch{
            completion(false, "Not able to delete the note. ")
        }
    }
}