Class {
	#name : 'TripBalanceItemView',
	#superclass : 'CpView',
	#category : 'TripExpenses-Server-Balance',
	#package : 'TripExpenses-Server',
	#tag : 'Balance'
}

{ #category : 'web resources' }
TripBalanceItemView class >> style [
	<webResource: #css>
	^ ':host { display: block; }
	   .balance { display: flex; justify-content: space-between; padding: .4rem 0;
	              border-bottom: 1px solid #f0f0f0; }
	   .name   { font-weight: 500; }
	   .positive { color: #0f6e56; font-weight: 500; }
	   .negative { color: #993c1d; font-weight: 500; }
	   .zero    { color: #888; }'
]

{ #category : 'web resources' }
TripBalanceItemView class >> template [
	<webResource: #html>
	^ '<div class="balance">
	     <span class="name"   id="name"></span>
	     <span class="amount" id="amount"></span>
	   </div>'
]

{ #category : 'rendering' }
TripBalanceItemView >> renderParticipantName: aName amount: anAmount currency: aCurrency [
	| amountEl cssClass |
	(self shadowedElementWithId: #name) textContent: aName.
	amountEl := self shadowedElementWithId: #amount.
	amountEl textContent: anAmount , ' ' , aCurrency.
	cssClass := (anAmount includes: $-)
		ifTrue:  [ 'amount negative' ]
		ifFalse: [ anAmount = '0' ifTrue: [ 'amount zero' ] ifFalse: [ 'amount positive' ] ].
	amountEl className: cssClass
]
