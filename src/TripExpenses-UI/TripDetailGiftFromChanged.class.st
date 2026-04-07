Class {
	#name : 'TripDetailGiftFromChanged',
	#superclass : 'Announcement',
	#instVars : [
		'entryId',
		'fromId'
	],
	#category : 'TripExpenses-UI-Expense',
	#package : 'TripExpenses-UI',
	#tag : 'Expense'
}

{ #category : 'as yet unclassified' }
TripDetailGiftFromChanged class >> entryId: anId fromId: aFromId [
    ^ self new entryId: anId; fromId: aFromId; yourself
]

{ #category : 'accessing' }
TripDetailGiftFromChanged >> entryId [

	^ entryId
]

{ #category : 'accessing' }
TripDetailGiftFromChanged >> entryId: anObject [

	entryId := anObject
]

{ #category : 'accessing' }
TripDetailGiftFromChanged >> fromId [

	^ fromId
]

{ #category : 'accessing' }
TripDetailGiftFromChanged >> fromId: anObject [

	fromId := anObject
]
