Class {
	#name : 'TripParticipantListModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'service',
		'tripId',
		'aliceId',
		'bobId',
		'model'
	],
	#category : 'TripExpenses-UI-Tests-Participant',
	#package : 'TripExpenses-UI-Tests',
	#tag : 'Participant'
}

{ #category : 'running' }
TripParticipantListModelTest >> setUp [
    | trip alice bob |
    service := TripApplicationService withRepository: InMemoryTripRepository new.
    trip  := service createTrip: 'Vacances' currency: 'EUR'.
    alice := service addParticipantByName: 'Alice' toTrip: trip id.
    bob   := service addParticipantByName: 'Bob'   toTrip: trip id.
    tripId  := trip id.
    aliceId := alice id value.
    bobId   := bob id value.
    model := TripParticipantListModel onService: service tripId: tripId
]

{ #category : 'running' }
TripParticipantListModelTest >> testLoadAnnouncesValueChanged [
    | announced |
    announced := false.
    model when: ValueChanged do: [ announced := true ].
    model load.
    self assert: announced
]

{ #category : 'running' }
TripParticipantListModelTest >> testLoadUpdatesParticipants [
    model load.
    self assert: model participants size equals: 2
]

{ #category : 'running' }
TripParticipantListModelTest >> testParticipantNamesAreCorrect [
    | names |
    model load.
    names := model participants collect: [ :p | p name ].
    self assert: (names includes: 'Alice').
    self assert: (names includes: 'Bob')
]

{ #category : 'running' }
TripParticipantListModelTest >> testParticipantsAreTripParticipantModels [
    model load.
    model participants do: [ :p |
        self assert: (p isKindOf: TripParticipantModel) ]
]

{ #category : 'running' }
TripParticipantListModelTest >> testParticipantsInitiallyEmpty [
    self assert: model participants isEmpty
]
