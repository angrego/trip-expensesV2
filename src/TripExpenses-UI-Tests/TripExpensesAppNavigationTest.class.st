"
Je teste la navigation de TripExpensesApplication via TripAppModel.

Pattern CP correct :
  - applicationModel retourne toujours le MEME TripAppModel.
  - TripAppModel change d etat et annonce valueChanged (teste via CpModel).
  - TripAppPresenter rerend selon isShowingDetail.
"
Class {
	#name : 'TripExpensesAppNavigationTest',
	#superclass : 'TestCase',
	#instVars : [
		'service',
		'app'
	],
	#category : 'TripExpenses-UI-Tests-App',
	#package : 'TripExpenses-UI-Tests',
	#tag : 'App'
}

{ #category : 'running' }
TripExpensesAppNavigationTest >> setUp [

	| authService |
	service := TripApplicationService withRepository:
		           InMemoryTripRepository new.
	authService := TripAuthService new.
    authService addCredential: 'Alice' password: 'alice123'.
    app := TripExpensesApplication onService: service authService: authService
]

{ #category : 'tests - etat initial' }
TripExpensesAppNavigationTest >> testAfterLoginShowingList [
    app applicationModel loginName: 'Alice' password: 'alice123'.
    self deny: app applicationModel isShowingLogin
]

{ #category : 'tests - applicationModel' }
TripExpensesAppNavigationTest >> testApplicationModelIsStable [
"applicationModel retourne toujours le MEME objet — invariant CP fondamental."

	self assert: app applicationModel == app applicationModel
]

{ #category : 'tests - navigateToTrip' }
TripExpensesAppNavigationTest >> testApplicationModelIsStableAfterNavigation [
	"applicationModel doit retourner le MEME objet a chaque appel (pas de recréation)."
	| trip first second |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	app navigateToTrip: trip id.
	first := app applicationModel.
	second := app applicationModel.
	self assert: first == second
]

{ #category : 'tests - applicationModel' }
TripExpensesAppNavigationTest >> testApplicationModelIsTripAppModel [
	self assert: (app applicationModel isKindOf: TripAppModel)
]

{ #category : 'tests - applicationModel' }
TripExpensesAppNavigationTest >> testApplicationModelPreferredPresenterClassIsTripAppPresenter [
	self
		assert: app applicationModel preferredPresenterClass
		equals: TripAppPresenter
]

{ #category : 'tests - navigateToTrip' }
TripExpensesAppNavigationTest >> testApplicationModelStableAfterNavigateToTrip [

	| trip modelBefore modelAfter |
	modelBefore := app applicationModel.
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	app navigateToTrip: trip id.
	modelAfter := app applicationModel.
	self assert: modelBefore == modelAfter
]

{ #category : 'tests - etat initial' }
TripExpensesAppNavigationTest >> testFailedLoginStaysOnLogin [
    app applicationModel loginName: 'Alice' password: 'wrong'.
    self assert: app applicationModel isShowingLogin
]

{ #category : 'tests - etat initial' }
TripExpensesAppNavigationTest >> testInitialCurrentTripDetailModelIsNil [
	self assert: app applicationModel currentTripDetailModel isNil
]

{ #category : 'tests - etat initial' }
TripExpensesAppNavigationTest >> testInitialTripListModelIsNotNil [

	self assert: app applicationModel tripListModel isNotNil
]

{ #category : 'tests - etat initial' }
TripExpensesAppNavigationTest >> testInitiallyNotShowingDetail [
	self deny: app applicationModel isShowingDetail
]

{ #category : 'tests - etat initial' }
TripExpensesAppNavigationTest >> testInitiallyShowingLogin [
    self assert: app applicationModel isShowingLogin
]

{ #category : 'tests - etat initial' }
TripExpensesAppNavigationTest >> testLoginStoresCurrentParticipantName [
    app applicationModel loginName: 'Alice' password: 'alice123'.
    self assert: app applicationModel currentParticipantName equals: 'Alice'
]

{ #category : 'tests - navigateToList' }
TripExpensesAppNavigationTest >> testNavigateToListAnnouncesValueChanged [
	"TripAppModel est un CpModel — on peut s abonner a valueChanged."

| announced trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	app navigateToTrip: trip id.
	announced := false.
	app applicationModel when: ValueChanged do: [ announced := true ].
	app navigateToList.
	self assert: announced
]

{ #category : 'tests - navigateToList' }
TripExpensesAppNavigationTest >> testNavigateToListClearsDetailModel [

	| trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	app navigateToTrip: trip id.
	app navigateToList.
	self assert: app applicationModel currentTripDetailModel isNil
]

{ #category : 'tests - navigateToList' }
TripExpensesAppNavigationTest >> testNavigateToListClearsShowingDetail [

	| trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	app navigateToTrip: trip id.
	app navigateToList.
	self deny: app applicationModel isShowingDetail
]

{ #category : 'tests - navigateToList' }
TripExpensesAppNavigationTest >> testNavigateToListReloadsTrips [

	| trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	app navigateToTrip: trip id.
	service createTrip: 'Nouveau voyage' currency: 'EUR'.
	app navigateToList.
	self assert: app applicationModel tripListModel trips size equals: 2
]

{ #category : 'tests - navigateToTrip' }
TripExpensesAppNavigationTest >> testNavigateToTripAnnouncesValueChanged [
	"TripAppModel est un CpModel — on peut s abonner a valueChanged."

	| announced trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	announced := false.
	app applicationModel when: ValueChanged do: [ announced := true ].
	app navigateToTrip: trip id.
	self assert: announced
]

{ #category : 'tests - navigateToTrip' }
TripExpensesAppNavigationTest >> testNavigateToTripCreatesDetailModel [

| trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	app navigateToTrip: trip id.
	self assert:
		(app applicationModel currentTripDetailModel isKindOf:
			 TripDetailModel)
]

{ #category : 'tests - navigateToTrip' }
TripExpensesAppNavigationTest >> testNavigateToTripDetailModelHasCorrectTripId [

	| trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	app navigateToTrip: trip id.
	self
		assert: app applicationModel currentTripDetailModel tripId
		equals: trip id
]

{ #category : 'tests - navigateToTrip' }
TripExpensesAppNavigationTest >> testNavigateToTripSetsShowingDetail [

| trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	app navigateToTrip: trip id.
	self assert: app applicationModel isShowingDetail
]

{ #category : 'tests - navigateToList' }
TripExpensesAppNavigationTest >> testTripListModelIsStableAcrossNavigation [

| listModelBefore trip |
	listModelBefore := app applicationModel tripListModel.
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	app navigateToTrip: trip id.
	app navigateToList.
	self assert: app applicationModel tripListModel == listModelBefore
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
