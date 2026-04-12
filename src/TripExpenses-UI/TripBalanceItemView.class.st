Class {
	#name : 'TripBalanceItemView',
	#superclass : 'CpView',
	#category : 'TripExpenses-UI-Balance',
	#package : 'TripExpenses-UI',
	#tag : 'Balance'
}

{ #category : 'web resources' }
TripBalanceItemView class >> style [
    <webResource: #css>
    ^ '
    :host { display: block; margin-bottom: .5rem; }
    .balance-card {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: .75rem 1rem;
        border-radius: 10px;
        background: white;
        border: 1px solid #e8e8ff;
        box-shadow: 0 1px 3px rgba(80,70,228,.06);
    }
    .name { font-weight: 500; font-size: .95rem; color: #1a1a2e; }
    .amount { font-size: 1rem; font-weight: 700; }
    .positive { color: #0f6e56; }
    .negative { color: #c0392b; }
    .zero { color: #888; font-weight: 400; }
    '


]

{ #category : 'web resources' }
TripBalanceItemView class >> template [
    <webResource: #html>
    ^ '
    <div class="balance-card">
        <span class="name" id="name"></span>
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
		ifFalse: [ anAmount = '0'
			ifTrue:  [ 'amount zero' ]
			ifFalse: [ 'amount positive' ] ].
	amountEl propertyAt: 'class' put: cssClass
]
