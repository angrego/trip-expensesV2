Class {
	#name : 'TripListModel',
	#superclass : 'CpModel',
	#instVars : [
		'service',
		'trips',
		'errorMessage',
		'showingCreateForm'
	],
	#category : 'TripExpenses-Server-TripList',
	#package : 'TripExpenses-Server',
	#tag : 'TripList'
}

{ #category : 'as yet unclassified' }
TripListModel class >> onService: aTripExpensesServerApp [ 
	^ self new
		service: aTripExpensesServerApp;
		loadTrips;
		yourself
]

{ #category : 'as yet unclassified' }
TripListModel >> createTripNamed: aName currency: aCurrency [
	|response|
	(aName isNil or: [ aName trim isEmpty ])
		ifTrue: [
			errorMessage := 'Le nom du voyage ne peut pas être vide'.
			self valueChanged.
			^ self ].
	(aCurrency isNil or: [ aCurrency trim isEmpty ])
		ifTrue: [
			errorMessage := 'La devise ne peut pas être vide'.
			self valueChanged.
			^ self ].
	response := service handleMessage: (Dictionary new
		at: 'type'     put: 'createTrip';
		at: 'name'     put: aName trim;
		at: 'currency' put: aCurrency trim;
		yourself).
	(response at: 'type') = 'error'
		ifTrue: [
			errorMessage := response at: 'message'.
			self valueChanged.
			^ self ].
	showingCreateForm := false.
	self loadTrips
]

{ #category : 'accessing' }
TripListModel >> errorMessage [

	^ errorMessage
]

{ #category : 'accessing' }
TripListModel >> errorMessage: anObject [

	errorMessage := anObject
]

{ #category : 'accessing' }
TripListModel >> hideCreateForm [
	showingCreateForm := false.
	errorMessage      := nil.
	self valueChanged
]

{ #category : 'as yet unclassified' }
TripListModel >> initialize [
	super initialize.
	trips             := OrderedCollection new.
	errorMessage      := nil.
	showingCreateForm := false
]

{ #category : 'as yet unclassified' }
TripListModel >> loadTrips [

| response |
	response := service handleMessage:
		(Dictionary new at: 'type' put: 'allTrips'; yourself).
	"Convertit les Dictionary en TripItemModel"
	trips := (response at: 'trips') collect: [ :dict |
		TripItemModel fromDict: dict ].
	errorMessage := nil.
	self valueChanged
]

{ #category : 'accessing' }
TripListModel >> service: aTripExpensesServerApp [ 
	service:=aTripExpensesServerApp .
]

{ #category : 'accessing' }
TripListModel >> showCreateForm [

		showingCreateForm := true.
	errorMessage := nil.
	self valueChanged
]

{ #category : 'accessing' }
TripListModel >> showingCreateForm [

	^ showingCreateForm
]

{ #category : 'accessing' }
TripListModel >> trips [

	^ trips
]
