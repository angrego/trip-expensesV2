Class {
	#name : 'TripDetailGiftRemoveRequested',
	#superclass : 'Announcement',
	#instVars : [
		'entryId'
	],
	#category : 'TripExpenses-UI-Expense',
	#package : 'TripExpenses-UI',
	#tag : 'Expense'
}

{ #category : 'accessing' }
TripDetailGiftRemoveRequested class >> entryId: aString [
    ^ self new entryId: aString; yourself
]

{ #category : 'accessing' }
TripDetailGiftRemoveRequested >> entryId [

	^ entryId
]

{ #category : 'accessing' }
TripDetailGiftRemoveRequested >> entryId: anObject [

	entryId := anObject
]
