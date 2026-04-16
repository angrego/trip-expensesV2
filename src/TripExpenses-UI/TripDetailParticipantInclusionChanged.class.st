Class {
	#name : 'TripDetailParticipantInclusionChanged',
	#superclass : 'Announcement',
	#instVars : [
		'participantId',
		'included'
	],
	#category : 'TripExpenses-UI-TripDetail',
	#package : 'TripExpenses-UI',
	#tag : 'TripDetail'
}

{ #category : 'as yet unclassified' }
TripDetailParticipantInclusionChanged class >> participantId: anId included: aBoolean [
    ^ self new participantId: anId; included: aBoolean; yourself
]

{ #category : 'accessing' }
TripDetailParticipantInclusionChanged >> included [

	^ included 
]

{ #category : 'accessing' }
TripDetailParticipantInclusionChanged >> participantId [
^participantId 
]
