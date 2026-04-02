"
Je suis la CpMvpWebApplication pour TripExpenses.
URL: http://localhost:8080/static/app.html?app=Voyages

Pattern CP correct :
  applicationModel retourne TOUJOURS le MEME objet (appModel : TripAppModel).
  C est TripAppModel qui change d etat et annonce valueChanged.
  TripAppPresenter rerend la bonne sous-vue en consequence.
"
Class {
	#name : 'TripExpensesApplication',
	#superclass : 'CpMvpWebApplication',
	#instVars : [
		'appModel'
	],
	#category : 'TripExpenses-Server-TripExpenseApplication',
	#package : 'TripExpenses-Server',
	#tag : 'TripExpenseApplication'
}

{ #category : 'accessing' }
TripExpensesApplication class >> app [
	^ #'Voyages'
]

{ #category : 'instance creation' }
TripExpensesApplication class >> onService: aTripApplicationService [
	^ self basicNew
		initializeWithService: aTripApplicationService;
		yourself
]

{ #category : 'instance creation' }
TripExpensesApplication class >> withSampleData [
	| repo service trip alice bob charlie rule |
	repo    := InMemoryTripRepository new.
	service := TripApplicationService withRepository: repo.
	trip    := service createTrip: 'Vacances ete 2026' currency: 'EUR'.
	alice   := service addParticipant: 'Alice'   toTrip: trip id.
	bob     := service addParticipant: 'Bob'     toTrip: trip id.
	charlie := service addParticipant: 'Charlie' toTrip: trip id.
	trip    := service findTrip: trip id.
	rule    := EqualSplitRule among: {
		ParticipantWeight participant: alice.
		ParticipantWeight participant: bob.
		ParticipantWeight participant: charlie }.
	service addExpense: (Expense
		description: 'Restaurant'
		totalAmount: (Money amount: 90 currency: 'EUR')
		payments: { Payment participant: alice amount: (Money amount: 90 currency: 'EUR') }
		splitRule: rule gifts: {} date: Date today) toTrip: trip id.
	^ self onService: service
]

{ #category : 'accessing' }
TripExpensesApplication >> applicationModel [
	^ appModel
]

{ #category : 'initialization' }
TripExpensesApplication >> initialize [

	super initialize.
	self initializeWithService:
		(TripApplicationService withRepository: InMemoryTripRepository new)
]

{ #category : 'initialization' }
TripExpensesApplication >> initializeWithService: aTripApplicationService [
	appModel := TripAppModel onService: aTripApplicationService
]

{ #category : 'navigation' }
TripExpensesApplication >> navigateToList [
	appModel navigateToList
]

{ #category : 'navigation' }
TripExpensesApplication >> navigateToTrip: aTripId [
	appModel navigateToTrip: aTripId
]

{ #category : 'accessing' }
TripExpensesApplication >> preferredPresenterClass [
"Délègue au modèle courant — chaque CpModel déclare son presenter."

	^ self applicationModel preferredPresenterClass
]
