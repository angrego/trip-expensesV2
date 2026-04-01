Class {
	#name : 'TripExpenseItemView',
	#superclass : 'CpView',
	#category : 'TripExpenses-Server-ExpenseItem',
	#package : 'TripExpenses-Server',
	#tag : 'ExpenseItem'
}

{ #category : 'web resources' }
TripExpenseItemView class >> style [
	<webResource: #css>
	^ ':host { display: block; }
	   .expense { display: flex; justify-content: space-between; align-items: center;
	              padding: .6rem 0; border-bottom: 1px solid #f0f0f0; }
	   .desc  { font-weight: 500; }
	   .meta  { font-size: .8rem; color: #888; }
	   .amount { font-weight: 500; color: #3c3489; white-space: nowrap; margin-left: 1rem; }'
]

{ #category : 'web resources' }
TripExpenseItemView class >> template [
	<webResource: #html>
	^ '<div class="expense">
	     <div>
	       <div class="desc" id="desc"></div>
	       <div class="meta" id="date"></div>
	     </div>
	     <div class="amount" id="amount"></div>
	   </div>'
]

{ #category : 'rendering' }
TripExpenseItemView >> renderDescription: aDesc amount: anAmount currency: aCurrency date: aDate [
	(self shadowedElementWithId: #desc)   textContent: aDesc.
	(self shadowedElementWithId: #date)   textContent: aDate.
	(self shadowedElementWithId: #amount) textContent: anAmount , ' ' , aCurrency
]
