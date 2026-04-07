Class {
	#name : 'TripParticipantListModel',
	#superclass : 'CpModel',
	#instVars : [
		'service',
		'tripId',
		'participants'
	],
	#category : 'TripExpenses-UI-Participant',
	#package : 'TripExpenses-UI',
	#tag : 'Participant'
}

{ #category : 'instance creation' }
TripParticipantListModel class >> onService: aTripApplicationService tripId: anId [
    ^ self new
        service: aTripApplicationService;
        tripId: anId;
        yourself
]

{ #category : 'actions' }
TripParticipantListModel >> initialize [
    super initialize.
    participants := OrderedCollection new
]

{ #category : 'actions' }
TripParticipantListModel >> load [
    | trip |
    trip := service findTrip: tripId.
    participants := trip participants collect: [ :p |
        TripParticipantModel fromParticipant: p ].
    self valueChanged
]

{ #category : 'accessing' }
TripParticipantListModel >> participants [
	^ participants
]

{ #category : 'private - setting' }
TripParticipantListModel >> service: aService [
    service := aService
]

{ #category : 'private - setting' }
TripParticipantListModel >> tripId: anId [
    tripId := anId
]
