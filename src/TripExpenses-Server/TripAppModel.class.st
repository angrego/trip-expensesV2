"
Je suis le modele racine unique de TripExpensesApplication.
CpMvpWebApplication.applicationModel retourne toujours MOI — jamais nil, jamais remplace.
C est moi qui change d etat (liste ↔ detail) et annonce ValueChanged.
Le presenter racine (TripAppPresenter) me demande mon etat courant pour savoir quoi rendre.
"
Class {
	#name : 'TripAppModel',
	#superclass : 'CpModel',
	#instVars : [
		'service',
		'tripListModel',
		'currentTripDetailModel'
	],
	#category : 'TripExpenses-Server-TripExpenseApplication',
	#package : 'TripExpenses-Server',
	#tag : 'TripExpenseApplication'
}

{ #category : 'instance creation' }
TripAppModel class >> onService: aTripApplicationService [
	^ self new
		initializeWithService: aTripApplicationService;
		yourself
]

{ #category : 'accessing' }
TripAppModel >> currentTripDetailModel [
	^ currentTripDetailModel
]

{ #category : 'initialization' }
TripAppModel >> initializeWithService: aTripApplicationService [
	service               := aTripApplicationService.
	tripListModel         := TripListModel onService: service.
	currentTripDetailModel := nil
]

{ #category : 'accessing' }
TripAppModel >> isShowingDetail [
	^ currentTripDetailModel isNotNil
]

{ #category : 'navigation' }
TripAppModel >> navigateToList [
	currentTripDetailModel := nil.
	tripListModel loadTrips.
	self valueChanged
]

{ #category : 'navigation' }
TripAppModel >> navigateToTrip: aTripId [
	currentTripDetailModel := TripDetailModel onService: service tripId: aTripId.
	self valueChanged
]

{ #category : 'testing' }
TripAppModel >> preferredPresenterClass [
	^ TripAppPresenter
]

{ #category : 'accessing' }
TripAppModel >> tripListModel [
	^ tripListModel
]
