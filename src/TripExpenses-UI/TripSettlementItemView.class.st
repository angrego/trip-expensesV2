Class {
	#name : 'TripSettlementItemView',
	#superclass : 'CpView',
	#category : 'TripExpenses-UI-Settlement',
	#package : 'TripExpenses-UI',
	#tag : 'Settlement'
}

{ #category : 'web resources' }
TripSettlementItemView class >> style [
	<webResource: #css>
	^ ':host { display: block; }
	   .settlement { padding: .5rem; background: #faeeda; border-radius: 8px; margin: .3rem 0;
	                 font-size: .9rem; }
	   .amount { font-weight: 500; }'
]

{ #category : 'web resources' }
TripSettlementItemView class >> template [

	<webResource: #html>
	^ '<div class="settlement" id="label"></div>'
]

{ #category : 'rendering' }
TripSettlementItemView >> renderFrom: aFrom to: aTo amount: anAmount currency: aCurrency [
	(self shadowedElementWithId: #label) textContent:
		aFrom , ' doit ' , anAmount , ' ' , aCurrency , ' à ' , aTo
]
