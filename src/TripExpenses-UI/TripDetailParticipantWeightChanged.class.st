Class {
	#name : 'TripDetailParticipantWeightChanged',
	#superclass : 'Announcement',
	#instVars : [
		'participantId',
		'weight'
	],
	#category : 'TripExpenses-UI-TripDetail',
	#package : 'TripExpenses-UI',
	#tag : 'TripDetail'
}

{ #category : 'as yet unclassified' }
TripDetailParticipantWeightChanged class >> participantId: anId weight: aWeight [
    ^ self new participantId: anId; weight: aWeight; 
yourself
]

{ #category : 'accessing' }
TripDetailParticipantWeightChanged >> participantId [
^participantId 
]

{ #category : 'accessing' }
TripDetailParticipantWeightChanged >> participantId: anObject [

	participantId := anObject
]

{ #category : 'accessing' }
TripDetailParticipantWeightChanged >> weight [

	^ weight 
]

{ #category : 'accessing' }
TripDetailParticipantWeightChanged >> weight: anObject [

	weight := anObject
]
