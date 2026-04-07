Class {
	#name : 'TripDetailGiftToChanged',
	#superclass : 'Announcement',
	#instVars : [
		'entryId',
		'toId'
	],
	#category : 'TripExpenses-UI-Expense',
	#package : 'TripExpenses-UI',
	#tag : 'Expense'
}

{ #category : 'as yet unclassified' }
TripDetailGiftToChanged class >> entryId: anId toId: aToId [
    ^ self new entryId: anId; toId: aToId; yourself
]

{ #category : 'accessing' }
TripDetailGiftToChanged >> entryId [

	^ entryId
]

{ #category : 'accessing' }
TripDetailGiftToChanged >> entryId: anObject [

	entryId := anObject
]

{ #category : 'accessing' }
TripDetailGiftToChanged >> toId [

	^ toId
]

{ #category : 'accessing' }
TripDetailGiftToChanged >> toId: anObject [

	toId := anObject
]
