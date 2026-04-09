Class {
	#name : 'TripParticipantInclusionChanged',
	#superclass : 'Announcement',
	#instVars : [
		'participantId',
		'included'
	],
	#category : 'TripExpenses-UI-ParticipantWeight',
	#package : 'TripExpenses-UI',
	#tag : 'ParticipantWeight'
}

{ #category : 'as yet unclassified' }
TripParticipantInclusionChanged class >> participantId: aParticipantId included:aBoolean [
^self new participantId: aParticipantId ;included:aBoolean ;yourself
]

{ #category : 'accessing' }
TripParticipantInclusionChanged >> included [

	^ included
]

{ #category : 'accessing' }
TripParticipantInclusionChanged >> included: anObject [

	included := anObject
]

{ #category : 'accessing' }
TripParticipantInclusionChanged >> participantId [

	^ participantId
]

{ #category : 'accessing' }
TripParticipantInclusionChanged >> participantId: anObject [

	participantId := anObject
]
