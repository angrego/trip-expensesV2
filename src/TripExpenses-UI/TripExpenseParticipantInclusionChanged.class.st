Class {
	#name : 'TripExpenseParticipantInclusionChanged',
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
TripExpenseParticipantInclusionChanged class >> participantId: anId included: aBoolean [

	^ self new
		  participantId: anId;
		  included: aBoolean;
		  yourself
]

{ #category : 'accessing' }
TripExpenseParticipantInclusionChanged >> included [

	^ included
]

{ #category : 'accessing' }
TripExpenseParticipantInclusionChanged >> included: anObject [

	included := anObject
]

{ #category : 'accessing' }
TripExpenseParticipantInclusionChanged >> participantId [

	^ participantId
]

{ #category : 'accessing' }
TripExpenseParticipantInclusionChanged >> participantId: anObject [

	participantId := anObject
]
