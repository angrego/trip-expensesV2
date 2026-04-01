"
I am the main CodeParadise application for TripExpenses.
I only live in the ServerEnvironment.
URL: http://localhost:8080/static/app.html?trip-expens
"
Class {
	#name : 'TripExpensesApplication',
	#superclass : 'CpMvpWebApplication',
	#instVars : [
		'tripListModel',
		'currentTripId',
		'service'
	],
	#category : 'TripExpenses-Server-TripExpenseApplication',
	#package : 'TripExpenses-Server',
	#tag : 'TripExpenseApplication'
}

{ #category : 'accessing' }
TripExpensesApplication class >> app [

	^ #'Voyages'
]

{ #category : 'accessing' }
TripExpensesApplication >> applicationModel [
	"Retourne le modèle courant selon l état de navigation.
	 CP appelle preferredPresenterClass sur ce modèle pour choisir le presenter."
	currentTripId isNil
		ifTrue:  [ ^ tripListModel ]
		ifFalse: [ ^ TripDetailModel onService: service tripId: currentTripId ]
]

{ #category : 'initialization' }
TripExpensesApplication >> initialize [

	super initialize.
	service := TripExpensesServerApp withSampleData .
	tripListModel := TripListModel onService: service
]

{ #category : 'accessing' }
TripExpensesApplication >> navigateToList [
	"Retour vers la liste — recharge les voyages."
	currentTripId := nil.
	tripListModel loadTrips.
	self announce: ValueChanged new
]

{ #category : 'accessing' }
TripExpensesApplication >> navigateToTrip: aTripId [
	"Appelé par TripListPresenter quand l utilisateur sélectionne un voyage.
	 CP ré-évalue applicationModel et preferredPresenterClass → nouveau presenter+vue."
	currentTripId := aTripId.
	self announce: ValueChanged new
]

{ #category : 'accessing' }
TripExpensesApplication >> preferredPresenterClass [
	"CP appelle cette méthode pour choisir le presenter root.
	 Elle switche selon l état de navigation."

	currentTripId
		ifNil: [ ^ TripListPresenter ]
		ifNotNil: [ ^ TripDetailPresenter ]
]
