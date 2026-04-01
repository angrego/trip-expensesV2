Class {
	#name : 'TripSettlementItemView',
	#superclass : 'CpView',
	#category : 'TripExpenses-Server-TripSettlement',
	#package : 'TripExpenses-Server',
	#tag : 'TripSettlement'
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
