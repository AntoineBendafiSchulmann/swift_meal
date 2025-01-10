# Structure générale du projet
```
BendafiSchulmannApp/
 ├── App/
 │    └── BENDAFI_SCHULMANNApp.swift
 ├── Data/
 │    ├── DataSources/
 │    │    └── MealRemoteDataSource.swift
 │    ├── DTO/
 │    │    ├── MealSearchDTO.swift
 │    │    └── CategoryListDTO.swift
 │    ├── Repositories/
 │    │    └── MealRepository.swift
 ├── Domain/
 │    ├── Entities/
 │    │    ├── ShoppingLine.swift
 │    │    └── Meal+GroceryItems.swift
 │    └── UseCases/
 │         └── MealInteractor.swift
 ├── Models/
 │    └── CoreData/
 │         ├── DataController.swift
 │         ├── Meal+CoreDataClass.swift
 │         ├── Meal+CoreDataProperties.swift
 │         ├── Ingredient+CoreDataClass.swift
 │         ├── Ingredient+CoreDataProperties.swift
 │         ├── GroceryItem+CoreDataClass.swift
 │         ├── GroceryItem+CoreDataProperties.swift
 │         └── MealPlan+CoreData{…} (si nécessaire)
 ├── Presentation/
 │    ├── ViewModels/
 │    │    ├── HomeViewModel.swift
 │    │    ├── MealPlanViewModel.swift
 │    │    ├── GroceryViewModel.swift
 │    │    └── AddMealViewModel.swift
 │    └── Views/
 │         ├── MainTabView.swift
 │         ├── HomeView.swift
 │         ├── MealDetailView.swift
 │         ├── MealPlanView.swift
 │         ├── GroceryView.swift
 │         └── AddMealView.swift
 ├── ContentView.swift
 └── MyDatabase.xcdatamodeld/
     └── (Entités Meal, Ingredient, GroceryItem, etc.)
```

# Détails des principaux fichiers

## 1. `BENDAFI_SCHULMANNApp.swift` (App/)
- Point d’entrée de l’application.
- Instancie `DataController` et injecte le `managedObjectContext` dans l’environnement.

## 2. `DataController.swift` (Models/CoreData/)
- Gère le conteneur `NSPersistentContainer` (par exemple nommé `"MyDatabase"`).
- Charge les `PersistentStores`.
- Propose une méthode `saveContext()` pour persister les changements.

## 3. Fichiers Core Data (Models/CoreData/)
- **`Meal+CoreDataClass.swift` / `Meal+CoreDataProperties.swift`**  
  - Entité `Meal` (avec propriétés comme `title`, `category`, `area`, `isPlanned`, etc.).
  - Peut contenir une relation vers `Ingredient` (via un `NSSet`).
- **`Ingredient+CoreDataClass.swift` / `Ingredient+CoreDataProperties.swift`**  
  - Entité `Ingredient` (avec propriétés `name`, `quantity`, etc.).
  - Liée à `Meal` via l’attribut `meal: Meal?` (relation inverse `ingredients` sur `Meal`).
- **`GroceryItem+CoreDataClass.swift` / `GroceryItem+CoreDataProperties.swift`**  
  - Entité `GroceryItem` pour représenter la liste de courses (avec `name`, `quantity`, `isChecked`, etc.).
  - Permet la persistance des items dans la base.

## 4. Remote Data Source (Data/DataSources/`MealRemoteDataSource.swift`)
- Classe `MealRemoteDataSource` qui effectue des requêtes HTTP asynchrones vers l’API [themealdb.com](https://www.themealdb.com).
- Méthodes principales :  
  - `searchMeals(by: keyword)` pour chercher des recettes par mot-clé.
  - `fetchCategories()` pour récupérer la liste des catégories disponibles.

## 5. Data Transfer Objects (Data/DTO/)
- **`MealSearchDTO` + `MealItemDTO`** :  
  Structures pour décoder le JSON principal renvoyé par l’API lors d’une recherche de recettes.
- **`CategoryListDTO` + `CategoryDTO`** :  
  Structures pour décoder la liste de catégories (`strCategory`, etc.).

## 6. `MealRepository.swift` (Data/Repositories/)
- Gère l’interaction avec :
  - Le `MealRemoteDataSource` (pour la récupération des données depuis l’API).
  - Le contexte Core Data (`NSManagedObjectContext`).
- Transforme les données reçues en entités Core Data (`Meal`, `Ingredient`).
- Met à jour ou récupère les `GroceryItem` en fonction des `Meal` planifiés.
- Par exemple :
  - `searchMealsByKeyword(_:)` :
    1. Appelle le remote data source.
    2. Crée des instances `Meal` (et leurs `Ingredient`) dans Core Data.
  - `createMeal(...)` :
    1. Crée un nouvel objet `Meal`.
    2. Crée ses `Ingredient` associés.
  - `togglePlanned(_:)` :
    1. Bascule `meal.isPlanned`.
    2. Met à jour la liste de courses (`GroceryItem`).

## 7. Domaine / UseCases : `MealInteractor.swift`
- Fait office d’intermédiaire entre les ViewModels et le Repository.
- Expose des méthodes telles que :
  - `loadCategories()` pour récupérer la liste des catégories.
  - `searchMeals(keyword:)` pour lancer la recherche via le repo.
  - `createMeal(..., ingredientsData: ...)` pour créer un nouveau `Meal`.
  - `togglePlanned(_:)` pour planifier ou dé-planifier un repas.
  - `fetchPlannedMeals()` pour obtenir la liste des `Meal` planifiés.
  - `updateGroceries()` / `fetchGroceries()` pour gérer la table `GroceryItem`.
  - `toggleChecked(_:)` pour cocher/décocher un item dans la liste de courses.

## 8. Domaine / Entities
- **`ShoppingLine.swift`** (facultatif)  
  - Un `struct` Swift pur pour l’affichage (si l’on veut un type distinct de l’entité Core Data `GroceryItem`).
- **`Meal+GroceryItems.swift`** (facultatif)  
  - Une extension calculant par exemple un tableau `meal.groceryItems` en `ShoppingLine` à partir des `Ingredient`.

## 9. ViewModels (Presentation/ViewModels/)
- **`HomeViewModel.swift`**  
  - Gère la recherche de recettes (`searchMeals()`).
  - Stocke la liste `meals`, la barre de recherche `searchText`, l’état `isLoading`, etc.
  - Gère aussi le filtrage par catégories (liste de `categories`, ensemble de `selectedCategories`).
- **`MealPlanViewModel.swift`**  
  - Gère la liste des repas planifiés via `planned`.
  - Fournit des méthodes comme `loadPlanned()`, `togglePlanned(_:)`.
- **`GroceryViewModel.swift`**  
  - Gère la liste de courses (`items`), récupérées via `fetchGroceries()`, ou bien en reconstruisant à partir de `meal.ingredients`.
  - Méthode `toggleCheck(_:)` pour cocher/décocher un item.
- **`AddMealViewModel.swift`**  
  - Permet la création manuelle d’un nouveau `Meal`.
  - Gère éventuellement la saisie d’ingrédients (non obligatoire, selon le cahier des charges).

## 10. Vues (Presentation/Views/…)
- **`MainTabView.swift`**  
  - Contient la `TabView` avec différents onglets (ex. Home, MealPlan, Grocery).
  - Instancie localement un `MealInteractor` / `MealRepository` par onglet, ou partage un interactor global.
- **`HomeView.swift`**  
  - Affiche une liste de recettes (via `HomeViewModel`).
  - Gère la barre de recherche et les filtres (catégories).
  - Navigation vers `MealDetailView`.
- **`MealDetailView.swift`**  
  - Affiche le détail d’un repas.
  - Possibilité de le planifier/déplanifier via un bouton (par ex. `calendar.badge.plus`).
- **`MealPlanView.swift`**  
  - Affiche la liste des repas planifiés (via `MealPlanViewModel.planned`).
  - Possibilité de déplanifier (ex. bouton “Unplan”).
- **`GroceryView.swift`**  
  - Affiche la liste de courses, éventuellement depuis `GroceryViewModel.items`.
  - Permet de cocher/décocher un ingrédient dans la liste.
- **`AddMealView.swift`**  
  - Propose un formulaire de création manuelle de `Meal`.
  - Crée éventuellement un ou plusieurs `Ingredient`.

## 11. `ContentView.swift`
- Généralement une vue racine minimaliste, appelant `MainTabView()`.

## 12. `MyDatabase.xcdatamodeld/`
- Le fichier de configuration Core Data, contenant les entités `Meal`, `Ingredient`, `GroceryItem` (et éventuellement `MealPlan`, si vous le séparez), avec leurs attributs et relations.

---

En résumé, ce projet utilise Core Data pour la persistance, des DTO pour décoder l’API, un Repository pour gérer les accès aux données (remote + Core Data), un Interactor faisant le lien entre la couche data et les ViewModels, et enfin diverses Views SwiftUI pour la présentation (Home, MealDetail, MealPlan, GroceryList, etc.).
