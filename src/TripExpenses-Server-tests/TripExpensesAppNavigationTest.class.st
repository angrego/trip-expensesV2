"
Je teste TripExpensesApplication APRÈS refactorisation.

Objectifs :
  1. TripExpensesApplication tient un TripApplicationService, pas un TripExpensesServerApp.
  2. La navigation navigateToTrip: / navigateToList est le SEUL chemin.
  3. applicationModel retourne toujours le même TripDetailModel (pas de recréation).
  4. preferredPresenterClass est défini sur les modèles, pas sur l application.

Note : on ne teste PAS les annonces CP (announce: ValueChanged new) ici.
CpMvpWebApplication ne répond pas à when:do: — les annonces sont vérifiées
par le framework CP lui-même au runtime. On vérifie uniquement l état observable.
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

{ #category : 'tests - navigateToTrip' }
TripExpensesAppNavigationTest >> testApplicationModelIsStableAfterNavigation [
	"applicationModel doit retourner le MEME objet a chaque appel (pas de recréation)."
	| trip first second |
	trip   := service createTrip: 'Vacances' currency: 'EUR'.
	app navigateToTrip: trip id.
	first  := app applicationModel.
	second := app applicationModel.
	self assert: first == second
]

{ #category : 'tests - etat initial' }
TripExpensesAppNavigationTest >> testInitialApplicationModelIsTripListModel [
	self assert: (app applicationModel isKindOf: TripListModel)
]

{ #category : 'tests - etat initial' }
TripExpensesAppNavigationTest >> testInitialPreferredPresenterClassIsTripListPresenter [
	self assert: app applicationModel preferredPresenterClass equals: TripListPresenter
]

{ #category : 'tests - navigateToList' }
TripExpensesAppNavigationTest >> testNavigateToListPreferredPresenterClassIsTripListPresenter [
	| trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	app navigateToTrip: trip id.
	app navigateToList.
	self assert: app applicationModel preferredPresenterClass equals: TripListPresenter
]

{ #category : 'tests - navigateToList' }
TripExpensesAppNavigationTest >> testNavigateToListReloadsTrips [
	| trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	app navigateToTrip: trip id.
	service createTrip: 'Nouveau voyage' currency: 'EUR'.
	app navigateToList.
	self assert: app applicationModel trips size equals: 2
]

{ #category : 'tests - navigateToList' }
TripExpensesAppNavigationTest >> testNavigateToListRestoresTripListModel [
	| trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	app navigateToTrip: trip id.
	app navigateToList.
	self assert: (app applicationModel isKindOf: TripListModel)
]

{ #category : 'tests - navigateToTrip' }
TripExpensesAppNavigationTest >> testNavigateToTripChangesApplicationModelToTripDetailModel [
	| trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	app navigateToTrip: trip id.
	self assert: (app applicationModel isKindOf: TripDetailModel)
]

{ #category : 'tests - navigateToTrip' }
TripExpensesAppNavigationTest >> testNavigateToTripModelHasCorrectTripId [
	| trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	app navigateToTrip: trip id.
	self assert: app applicationModel tripId equals: trip id
]

{ #category : 'tests - navigateToTrip' }
TripExpensesAppNavigationTest >> testNavigateToTripPreferredPresenterClassIsTripDetailPresenter [
	| trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	app navigateToTrip: trip id.
	self assert: app applicationModel preferredPresenterClass equals: TripDetailPresenter
]

{ #category : 'tests - navigateToList' }
TripExpensesAppNavigationTest >> testTripListModelIsStableAcrossNavigations [
	"Le TripListModel doit etre le MEME objet avant et apres un aller-retour."
	| initialModel trip |
	initialModel := app applicationModel.
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	app navigateToTrip: trip id.
	app navigateToList.
	self assert: app applicationModel == initialModel
]
