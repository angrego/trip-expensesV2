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
	^ self new
		setName:     (aDict at: 'participantName')
		amount:      (aDict at: 'amount')
		currency:    (aDict at: 'currency');
		yourself
]

{ #category : 'accessing' }
TripBalanceItemModel >> amount [ ^ amount
]

{ #category : 'accessing' }
TripBalanceItemModel >> currency [ ^ currency
]

{ #category : 'accessing' }
TripBalanceItemModel >> participantName [ ^ participantName
]

{ #category : 'testing' }
TripBalanceItemModel >> preferredPresenterClass [ ^ TripBalanceItemPresenter
]

{ #category : 'initialization' }
TripBalanceItemModel >> setName: aName amount: anAmount currency: aCurrency [
	participantName := aName.
	amount          := anAmount printString.
	currency        := aCurrency
]
