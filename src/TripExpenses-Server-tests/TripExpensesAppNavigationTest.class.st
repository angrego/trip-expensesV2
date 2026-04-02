"
Je teste TripExpensesApplication APRÈS refactorisation.

Objectifs :
  1. TripExpensesApplication tient un TripApplicationService, pas un TripExpensesServerApp.
  2. La navigation navigateToTrip: / navigateToList est le SEUL chemin.
  3. applicationModel retourne toujours le même TripDetailModel (pas de recréation).
  4. preferredPresenterClass est défini sur les modèles, pas sur l application.

Note : on teste ici la logique de navigation, pas le rendu CP (qui nécessite le runtime).
Ces tests doivent être ROUGES avant refactorisation, VERTS après.
"
Class {
	#name : 'TripExpensesAppNavigationTest',
	#superclass : 'TestCase',
	#instVars : [
		'service',
		'app'
	],
	#category : 'TripExpenses-Server-tests',
	#package : 'TripExpenses-Server-tests'
}

{ #category : 'running' }
TripExpensesAppNavigationTest >> setUp [
	service := TripApplicationService withRepository: InMemoryTripRepository new.
	app     := TripExpensesApplication onService: service
]

{ #category : 'tests - navigation' }
TripExpensesAppNavigationTest >> testApplicationModelIsStableAfterNavigation [
	"applicationModel doit retourner le MÊME objet à chaque appel (pas de recréation)."
	| trip first second |
	trip   := service createTrip: 'Vacances' currency: 'EUR'.
	app navigateToTrip: trip id.
	first  := app applicationModel.
	second := app applicationModel.
	self assert: first == second
]

{ #category : 'tests - état initial' }
TripExpensesAppNavigationTest >> testInitialApplicationModelIsTripListModel [
	self assert: (app applicationModel isKindOf: TripListModel)
]

{ #category : 'tests - état initial' }
TripExpensesAppNavigationTest >> testInitialPreferredPresenterClassIsTripListPresenter [
	"Le modèle root expose son presenter — pas l application."
	self assert: (app applicationModel preferredPresenterClass = TripListPresenter)
]

{ #category : 'tests - navigation' }
TripExpensesAppNavigationTest >> testNavigateToListAnnouncesValueChanged [
	| announced trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	app navigateToTrip: trip id.
	announced := false.
	app when: ValueChanged do: [ announced := true ].
	app navigateToList.
	self assert: announced
]

{ #category : 'tests - navigation' }
TripExpensesAppNavigationTest >> testNavigateToListPreferredPresenterClassIsTripListPresenter [

| trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	app navigateToTrip: trip id.
	app navigateToList.
	self assert:
		app applicationModel preferredPresenterClass = TripListPresenter
]

{ #category : 'tests - navigation' }
TripExpensesAppNavigationTest >> testNavigateToListReloadsTrips [
	"Après navigateToList, la liste doit être fraîche."
	| trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	app navigateToTrip: trip id.
	service createTrip: 'Nouveau voyage' currency: 'EUR'.
	app navigateToList.
	self assert: app applicationModel trips size equals: 2
]

{ #category : 'tests - navigation' }
TripExpensesAppNavigationTest >> testNavigateToListRestoresTripListModel [
	| trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	app navigateToTrip: trip id.
	app navigateToList.
	self assert: (app applicationModel isKindOf: TripListModel)
]

{ #category : 'tests - navigation' }
TripExpensesAppNavigationTest >> testNavigateToTripAnnouncesValueChanged [
	| announced trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	announced := false.
	app when: ValueChanged do: [ announced := true ].
	app navigateToTrip: trip id.
	self assert: announced
]

{ #category : 'tests - navigation' }
TripExpensesAppNavigationTest >> testNavigateToTripChangesApplicationModelToTripDetailModel [
	| trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	app navigateToTrip: trip id.
	self assert: (app applicationModel isKindOf: TripDetailModel)
]

{ #category : 'tests - navigation' }
TripExpensesAppNavigationTest >> testNavigateToTripModelHasCorrectTripId [
	| trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	app navigateToTrip: trip id.
	self assert: app applicationModel tripId equals: trip id
]

{ #category : 'tests - navigation' }
TripExpensesAppNavigationTest >> testNavigateToTripPreferredPresenterClassIsTripDetailPresenter [
	| trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	app navigateToTrip: trip id.
	self assert: (app applicationModel preferredPresenterClass = TripDetailPresenter)
]

{ #category : 'tests - navigation' }
TripExpensesAppNavigationTest >> testTripListModelIsStableAcrossNavigations [
	"Le TripListModel doit être le MÊME objet avant et après un aller-retour."
	| initialModel trip |
	initialModel := app applicationModel.
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	app navigateToTrip: trip id.
	app navigateToList.
	self assert: app applicationModel == initialModel
]
