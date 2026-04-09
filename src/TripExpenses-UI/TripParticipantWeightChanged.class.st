Class {
	#name : 'TripParticipantWeightChanged',
	#superclass : 'Announcement',
	#instVars : [
		'participantId',
		'weight'
	],
	#category : 'TripExpenses-UI-ParticipantWeight',
	#package : 'TripExpenses-UI',
	#tag : 'ParticipantWeight'
}

{ #category : 'accessing' }
TripParticipantWeightChanged class >> participantId: aParticipantId weight:anInteger [
^self new participantId: aParticipantId ;
weight: anInteger ;yourself 
]

{ #category : 'accessing' }
TripParticipantWeightChanged >> participantId [

	^ participantId
]

{ #category : 'accessing' }
TripParticipantWeightChanged >> participantId: anObject [

	participantId := anObject
]

{ #category : 'accessing' }
TripParticipantWeightChanged >> weight [

	^ weight
]

{ #category : 'accessing' }
TripParticipantWeightChanged >> weight: anObject [

	weight := anObject
]
