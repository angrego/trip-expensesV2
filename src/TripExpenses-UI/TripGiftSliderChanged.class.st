Class {
	#name : 'TripGiftSliderChanged',
	#superclass : 'Announcement',
	#instVars : [
		'amountValue'
	],
	#category : 'TripExpenses-UI-Gift',
	#package : 'TripExpenses-UI',
	#tag : 'Gift'
}

{ #category : 'accessing' }
TripGiftSliderChanged class >> amountValue: aNumber [

	^ self new
		  amountValue: aNumber;
		  yourself
]

{ #category : 'accessing' }
TripGiftSliderChanged >> amountValue [

	^ amountValue
]

{ #category : 'accessing' }
TripGiftSliderChanged >> amountValue: anObject [

	amountValue := anObject
]
