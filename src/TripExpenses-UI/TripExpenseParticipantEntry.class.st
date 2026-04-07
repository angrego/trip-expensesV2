Class {
	#name : 'TripExpenseParticipantEntry',
	#superclass : 'Object',
	#instVars : [
		'participantId',
		'name',
		'weight',
		'included'
	],
	#category : 'TripExpenses-UI-Expense',
	#package : 'TripExpenses-UI',
	#tag : 'Expense'
}

{ #category : 'as yet unclassified' }
TripExpenseParticipantEntry class >> forParticipant: aParticipant [
    ^ self new
        participantId: aParticipant id value;
        name: aParticipant name;
        included: true;
        weight: 1;
        yourself
]

{ #category : 'accessing' }
TripExpenseParticipantEntry >> included [
    ^ included
]

{ #category : 'accessing' }
TripExpenseParticipantEntry >> included: aBoolean [
    included := aBoolean
]

{ #category : 'accessing' }
TripExpenseParticipantEntry >> name [
    ^ name
]

{ #category : 'accessing' }
TripExpenseParticipantEntry >> name: aString [
    name := aString
]

{ #category : 'accessing' }
TripExpenseParticipantEntry >> participantId [
    ^ participantId
]

{ #category : 'accessing' }
TripExpenseParticipantEntry >> participantId: aString [
    participantId := aString
]

{ #category : 'accessing' }
TripExpenseParticipantEntry >> weight [
    ^ weight
]

{ #category : 'accessing' }
TripExpenseParticipantEntry >> weight: anInteger [
    weight := anInteger
]
