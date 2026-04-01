"
I represent a single trip summary for display in the list.
I only hold simple types (String, Number) so CP can encode me for the browser.
"
Class {
	#name : 'TripItemModel',
	#superclass : 'CpModel',
	#instVars : [
		'tripId',
		'name',
		'currency',
		'participantCount',
		'totalExpenses'
	],
	#category : 'TripExpenses-Server-TripItem',
	#package : 'TripExpenses-Server',
	#tag : 'TripItem'
}

{ #category : 'instance creation' }
TripItemModel class >> fromDict: aDict [
	^ self new
		setTripId:          (aDict at: 'id');
		setName:            (aDict at: 'name');
		setCurrency:        (aDict at: 'currency');
		setParticipantCount:(aDict at: 'participantCount');
		setTotalExpenses:   (aDict at: 'totalExpenses');
		yourself
]

{ #category : 'accessing' }
TripItemModel >> currency [

	^ currency
]

{ #category : 'accessing' }
TripItemModel >> name [

	^ name
]

{ #category : 'accessing' }
TripItemModel >> participantCount [

	^ participantCount
]

{ #category : 'accessing' }
TripItemModel >> preferredPresenterClass [
	^ TripItemPresenter
]

{ #category : 'accessing' }
TripItemModel >> setCurrency: aString [
	currency := aString
]

{ #category : 'accessing' }
TripItemModel >> setName: aString [
	name := aString
]

{ #category : 'accessing' }
TripItemModel >> setParticipantCount: aNumber [
	participantCount := aNumber
]

{ #category : 'accessing' }
TripItemModel >> setTotalExpenses: aNumber [
	totalExpenses := aNumber
]

{ #category : 'accessing' }
TripItemModel >> setTripId: aString [
	tripId := aString
]

{ #category : 'accessing' }
TripItemModel >> totalExpenses [

	^ totalExpenses
]

{ #category : 'accessing' }
TripItemModel >> tripId [

	^ tripId
]
