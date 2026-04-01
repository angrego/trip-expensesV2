Class {
	#name : 'TripSettlementItemModel',
	#superclass : 'CpModel',
	#instVars : [
		'fromName',
		'toName',
		'amount',
		'currency'
	],
	#category : 'TripExpenses-Server-TripSettlement',
	#package : 'TripExpenses-Server',
	#tag : 'TripSettlement'
}

{ #category : 'instance creation' }
TripSettlementItemModel class >> fromDict: aDict [
	^ self new
		setFrom:     (aDict at: 'from')
		to:          (aDict at: 'to')
		amount:      (aDict at: 'amount')
		currency:    (aDict at: 'currency');
		yourself
]

{ #category : 'accessing' }
TripSettlementItemModel >> amount [ ^ amount
]

{ #category : 'accessing' }
TripSettlementItemModel >> currency [ ^ currency
]

{ #category : 'accessing' }
TripSettlementItemModel >> fromName [ ^ fromName
]

{ #category : 'testing' }
TripSettlementItemModel >> preferredPresenterClass [ ^ TripSettlementItemPresenter
]

{ #category : 'initialization' }
TripSettlementItemModel >> setFrom: aFromName to: aToName amount: anAmount currency: aCurrency [
	fromName := aFromName.
	toName   := aToName.
	amount   := anAmount printString.
	currency := aCurrency
]

{ #category : 'accessing' }
TripSettlementItemModel >> toName [ ^ toName
]
