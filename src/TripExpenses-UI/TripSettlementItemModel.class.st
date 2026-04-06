Class {
	#name : 'TripSettlementItemModel',
	#superclass : 'CpModel',
	#instVars : [
		'fromName',
		'toName',
		'amount',
		'currency'
	],
	#category : 'TripExpenses-UI-TripDetail',
	#package : 'TripExpenses-UI',
	#tag : 'TripDetail'
}

{ #category : 'instance creation' }
TripSettlementItemModel class >> fromDict: aDict [
	"Conservé pour compatibilité."
	^ self new
		setFrom:     (aDict at: 'from')
		to:          (aDict at: 'to')
		amount:      (aDict at: 'amount')
		currency:    (aDict at: 'currency');
		yourself
]

{ #category : 'instance creation' }
TripSettlementItemModel class >> fromSettlement: aSettlement [
	"Construit depuis un objet Settlement du domaine.
	 Settlement expose #from (Participant), #to (Participant), #amount (Money)."
	^ self new
		setFrom:     aSettlement from name
		to:          aSettlement to name
		amount:      aSettlement amount amount
		currency:    aSettlement amount currency;
		yourself
]

{ #category : 'accessing' }
TripSettlementItemModel >> amount [
	^ amount
]

{ #category : 'accessing' }
TripSettlementItemModel >> currency [
	^ currency
]

{ #category : 'accessing' }
TripSettlementItemModel >> fromName [
	^ fromName
]

{ #category : 'testing' }
TripSettlementItemModel >> preferredPresenterClass [
	^ TripSettlementItemPresenter
]

{ #category : 'private - setting' }
TripSettlementItemModel >> setFrom: aFromName to: aToName amount: anAmount currency: aCurrency [
	fromName := aFromName.
	toName := aToName.
	amount := anAmount printString.
	currency := aCurrency
]

{ #category : 'accessing' }
TripSettlementItemModel >> toName [
	^ toName
]
