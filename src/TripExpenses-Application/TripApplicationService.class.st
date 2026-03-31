Class {
	#name : 'TripApplicationService',
	#superclass : 'Object',
	#instVars : [
		'repository'
	],
	#category : 'TripExpenses-Application',
	#package : 'TripExpenses-Application'
}

{ #category : 'as yet unclassified' }
TripApplicationService class >> default [ 
    ^ self withRepository: STONTripRepository default
]

{ #category : 'as yet unclassified' }
TripApplicationService class >> withRepository: aRepository [ 
    ^ self new repository: aRepository; yourself
]

{ #category : 'adding' }
TripApplicationService >> addExpense: anExpense toTrip: aTripId [ 
 | trip |
    trip := repository findById: aTripId.
    trip addExpense: anExpense.
    repository save: trip.
    ^ anExpense
]

{ #category : 'accessing' }
TripApplicationService >> addParticipant: aName toTrip: aTripId [ 
    | trip participant |
    trip := repository findById: aTripId.
    participant := Participant name: aName.
    trip addParticipant: participant.
    repository save: trip.
    ^ participant
]

{ #category : 'as yet unclassified' }
TripApplicationService >> allTrips [
	 ^ repository findAll
]

{ #category : 'as yet unclassified' }
TripApplicationService >> createTrip: aName currency: aCurrency [
    | trip |
    trip := Trip name: aName currency: aCurrency.
    repository save: trip.
    ^ trip
]

{ #category : 'as yet unclassified' }
TripApplicationService >> findTrip: aTripId [
	^ repository findById: aTripId
]

{ #category : 'accessing' }
TripApplicationService >> repository: aSTONTripRepository [ 
	repository := aSTONTripRepository
]
