"
I am announced when the user submits the add expense form.
I carry description and amountString (String) and payerId (String).
The presenter converts amountString to Number and resolves all participantIds.
"
Class {
	#name : 'TripDetailAddExpenseRequested',
	#superclass : 'Announcement',
	#instVars : [
		'description',
		'amountString',
		'payerId'
	],
	#category : 'TripExpenses-Server-TripDetail',
	#package : 'TripExpenses-Server',
	#tag : 'TripDetail'
}

{ #category : 'as yet unclassified' }
TripDetailAddExpenseRequested class >> description: aDesc amountString: anAmount payerId: aPayerId [
	^ self new
		description:  aDesc;
		amountString: anAmount;
		payerId:      aPayerId;
		yourself
]

{ #category : 'accessing' }
TripDetailAddExpenseRequested >> amountString [

	^ amountString
]

{ #category : 'accessing' }
TripDetailAddExpenseRequested >> amountString: anObject [

	amountString := anObject
]

{ #category : 'accessing' }
TripDetailAddExpenseRequested >> description [

	^ description
]

{ #category : 'accessing' }
TripDetailAddExpenseRequested >> description: anObject [

	description := anObject
]

{ #category : 'accessing' }
TripDetailAddExpenseRequested >> payerId [

	^ payerId
]

{ #category : 'accessing' }
TripDetailAddExpenseRequested >> payerId: anObject [

	payerId := anObject
]
