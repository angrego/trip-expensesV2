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
TripApplicationService >> addParticipant: aParticipant toTrip: aTripId [

	| trip |
	trip := repository findById: aTripId.
	trip addParticipant: aParticipant.
	repository save: trip.
	^ aParticipant 
]

{ #category : 'accessing' }
TripApplicationService >> addParticipantByName: aName toTrip: aTripId [

	^ self addParticipant: (Participant name: aName) toTrip: aTripId
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
TripApplicationService >> removeExpense: anExpense fromTrip: aTripId [
	"Supprime la depense du voyage et persiste."

	| trip |
	trip := repository findById: aTripId.
	trip removeExpense: anExpense id.
	repository save: trip
]

{ #category : 'accessing' }
TripApplicationService >> repository: aSTONTripRepository [ 
	repository := aSTONTripRepository
]

{ #category : 'as yet unclassified' }
TripApplicationService >> settlementsForTrip: aTripId [
    "Calcule les règlements pour un voyage via le service de settlement."
    | trip |
    trip := self findTrip: aTripId.
    ^ TripSettlementService settleFor: trip balances
]
