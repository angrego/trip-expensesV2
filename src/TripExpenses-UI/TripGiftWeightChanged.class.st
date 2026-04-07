Class {
	#name : 'TripGiftWeightChanged',
	#superclass : 'Announcement',
	#instVars : [
		'participantId',
		'weight'
	],
	#category : 'TripExpenses-UI-Gift',
	#package : 'TripExpenses-UI',
	#tag : 'Gift'
}

{ #category : 'as yet unclassified' }
TripGiftWeightChanged class >> participantId: aString weight: anInteger [
    ^ self new participantId: aString; weight: anInteger; yourself
]

{ #category : 'accessing' }
TripGiftWeightChanged >> participantId [

	^ participantId
]

{ #category : 'accessing' }
TripGiftWeightChanged >> participantId: anObject [

	participantId := anObject
]

{ #category : 'accessing' }
TripGiftWeightChanged >> weight [

	^ weight
]

{ #category : 'accessing' }
TripGiftWeightChanged >> weight: anObject [

	weight := anObject
]
