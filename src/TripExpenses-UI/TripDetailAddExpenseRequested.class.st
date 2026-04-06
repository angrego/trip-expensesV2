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
		'payerId',
		'weightsString'
	],
	#category : 'TripExpenses-UI-TripDetail',
	#package : 'TripExpenses-UI',
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

{ #category : 'as yet unclassified' }
TripDetailAddExpenseRequested class >> description: aDesc amountString: anAmount payerId: aPayerId weightsString: aWeightsCollection [
    ^ self new
        description:   aDesc;
        amountString:  anAmount;
        payerId:       aPayerId;
        weightsString: aWeightsCollection;
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

{ #category : 'accessing' }
TripDetailAddExpenseRequested >> weightsString [
    ^ weightsString
]

{ #category : 'accessing' }
TripDetailAddExpenseRequested >> weightsString: aCollection [
    weightsString := aCollection
]
