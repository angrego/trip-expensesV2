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
		'currentTripDetailModel',
		'loginModel',
		'currentParticipantName'
	],
	#category : 'TripExpenses-UI-App',
	#package : 'TripExpenses-UI',
	#tag : 'App'
}

{ #category : 'instance creation' }
TripAppModel class >> onService: aTripApplicationService [
	^ self new
		initializeWithService: aTripApplicationService;
		yourself
]

{ #category : 'instance creation' }
TripAppModel class >> onService: aTripApplicationService authService: aTripAuthService [
    ^ self new
        initializeWithService: aTripApplicationService
        authService: aTripAuthService;
        yourself
]

{ #category : 'accessing' }
TripAppModel >> currentParticipantName [
	^ currentParticipantName
]

{ #category : 'accessing' }
TripAppModel >> currentTripDetailModel [
	^ currentTripDetailModel
]

{ #category : 'initialization' }
TripAppModel >> initializeWithService: aTripApplicationService [

	service := aTripApplicationService.
	tripListModel := TripListModel onService: service.
	currentTripDetailModel := nil.
	currentParticipantName := nil.

]

{ #category : 'initialization' }
TripAppModel >> initializeWithService: aTripApplicationService authService: aTripAuthService [

	loginModel := TripLoginModel onAuthService: aTripAuthService.
self initializeWithService: aTripApplicationService.



]

{ #category : 'accessing' }
TripAppModel >> isShowingDetail [
	^ currentTripDetailModel isNotNil
]

{ #category : 'testing' }
TripAppModel >> isShowingLogin [
	^currentParticipantName isNil
]

{ #category : 'accessing' }
TripAppModel >> loginModel [

	^loginModel 
]

{ #category : 'navigation' }
TripAppModel >> loginName: aName password: aPassword [

	loginModel loginName: aName password: aPassword.
	loginModel isAuthenticated ifFalse: [ ^ self ].
	currentParticipantName := aName.
	self valueChanged
]

{ #category : 'navigation' }
TripAppModel >> navigateToList [
	currentTripDetailModel := nil.
	tripListModel loadTrips.
	self valueChanged
]

{ #category : 'navigation' }
TripAppModel >> navigateToTrip: aTripId [
	currentTripDetailModel := TripDetailModel
		                          onService: service
		                          tripId: aTripId.
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
