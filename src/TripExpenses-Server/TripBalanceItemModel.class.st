Class {
	#name : 'TripBalanceItemModel',
	#superclass : 'CpModel',
	#instVars : [
		'participantName',
		'amount',
		'currency'
	],
	#category : 'TripExpenses-Server-Balance',
	#package : 'TripExpenses-Server',
	#tag : 'Balance'
}

{ #category : 'instance creation' }
TripBalanceItemModel class >> fromDict: aDict [
	"Conservé pour compatibilité."
	^ self new
		setName:     (aDict at: 'participantName')
		amount:      (aDict at: 'amount')
		currency:    (aDict at: 'currency');
		yourself
]

{ #category : 'instance creation' }
TripBalanceItemModel class >> fromParticipant: aParticipant money: aMoney [
	"Construit depuis un Participant et un Money du domaine."
	^ self new
		setName:     aParticipant name
		amount:      aMoney amount
		currency:    aMoney currency;
		yourself
]

{ #category : 'accessing' }
TripBalanceItemModel >> amount [
	^ amount
]

{ #category : 'accessing' }
TripBalanceItemModel >> currency [
	^ currency
]

{ #category : 'accessing' }
TripBalanceItemModel >> participantName [
	^ participantName
]

{ #category : 'testing' }
TripBalanceItemModel >> preferredPresenterClass [
	^ TripBalanceItemPresenter
]

{ #category : 'private - setting' }
TripBalanceItemModel >> setName: aName amount: anAmount currency: aCurrency [
	participantName := aName.
	amount          := anAmount printString.
	currency        := aCurrency
]
