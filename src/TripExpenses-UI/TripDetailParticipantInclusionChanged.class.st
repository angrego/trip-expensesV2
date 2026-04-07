Class {
	#name : 'TripDetailParticipantInclusionChanged',
	#superclass : 'Announcement',
	#instVars : [
		'participantId',
		'included'
	],
	#category : 'TripExpenses-UI-Expense',
	#package : 'TripExpenses-UI',
	#tag : 'Expense'
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
