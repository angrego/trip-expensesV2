Class {
	#name : 'TripDetailGiftAmountChanged',
	#superclass : 'Announcement',
	#instVars : [
		'entryId',
		'amount'
	],
	#category : 'TripExpenses-UI-Expense',
	#package : 'TripExpenses-UI',
	#tag : 'Expense'
}

{ #category : 'nil' }
TripDetailGiftAmountChanged class >> entryId: anId amount: anAmount [
    ^ self new entryId: anId; amount: anAmount; yourself
]

{ #category : 'accessing' }
TripDetailGiftAmountChanged >> amount [

	^ amount
]

{ #category : 'accessing' }
TripDetailGiftAmountChanged >> amount: anObject [

	amount := anObject
]

{ #category : 'accessing' }
TripDetailGiftAmountChanged >> entryId [

	^ entryId
]

{ #category : 'accessing' }
TripDetailGiftAmountChanged >> entryId: anObject [

	entryId := anObject
]
