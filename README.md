# 📒 Realm Todo App (UIKit)

A clean, colorful, and category-based Todo List iOS application built with **UIKit**, **Realm**, and **SwipeCellKit**. The app provides persistent storage, custom navigation styling, dynamic color assignments, and intuitive swipe-to-delete gestures.

---

## 🚀 Features

- 🗂️ Create and manage categories
- ✅ Add, check, and delete todo items within categories
- 🔍 Search items by title
- 🎨 Random background colors for each category
- 🧹 Swipe to delete (via SwipeCellKit)
- 💾 Local data persistence using Realm

---

## 🛠 Technologies Used

- Swift
- UIKit
- [RealmSwift](https://realm.io)
- [SwipeCellKit](https://github.com/SwipeCellKit/SwipeCellKit)

---

## 🧱 Data Models

### `Category`
```swift
class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var cellColor: String = ""
    let items = List<Item>()
}

