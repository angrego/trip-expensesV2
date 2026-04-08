Class {
	#name : 'TripExpenseParticipantWeightChanged',
	#superclass : 'Announcement',
	#instVars : [
		'participantId',
		'weight'
	],
	#category : 'TripExpenses-UI-Expense',
	#package : 'TripExpenses-UI',
	#tag : 'Expense'
}

{ #category : 'as yet unclassified' }
TripExpenseParticipantWeightChanged class >> participantId: anId weight: aWeight [

	^ self new
		  participantId: anId;
		  weight: aWeight;
		  yourself
]

{ #category : 'accessing' }
TripExpenseParticipantWeightChanged >> participantId [

	^ participantId
]

{ #category : 'accessing' }
TripExpenseParticipantWeightChanged >> participantId: anObject [

	participantId := anObject
]

{ #category : 'accessing' }
TripExpenseParticipantWeightChanged >> weight [

	^ weight
]

{ #category : 'accessing' }
TripExpenseParticipantWeightChanged >> weight: anObject [

	weight := anObject
]
