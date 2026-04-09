Class {
	#name : 'TripGenerosityModel',
	#superclass : 'CpModel',
	#instVars : [
		'items',
		'service',
		'tripId'
	],
	#category : 'TripExpenses-UI-Balance',
	#package : 'TripExpenses-UI',
	#tag : 'Balance'
}

{ #category : 'instance creation' }
TripGenerosityModel class >> onService: aService tripId: anId [
    ^ self new
        service: aService;
        tripId:  anId;
        yourself
]

{ #category : 'initialization' }
TripGenerosityModel >> initialize [
    super initialize.
    items := OrderedCollection new
]

{ #category : 'accessing' }
TripGenerosityModel >> items [
	^ items
]

{ #category : 'accessing' }
TripGenerosityModel >> load [

	| trip report sorted |
	trip := service findTrip: tripId.
	report := trip generosityReport.
	sorted := report associations asSortedCollection: [ :a :b |
		          a value amount >= b value amount ].
	items := sorted collect: [ :assoc |
		         TripGenerosityItemModel
			         setParticipant: assoc key
			         money: assoc value ].
	self valueChanged.
	^self.
]

{ #category : 'presenter' }
TripGenerosityModel >> preferredPresenterClass [
    ^ TripGenerosityPresenter
]

{ #category : 'private - setting' }
TripGenerosityModel >> service: aService [ 
	service:=aService 
]

{ #category : 'private - setting' }
TripGenerosityModel >> tripId: aTripId [ 
	tripId:=aTripId 
]
