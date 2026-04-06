Class {
	#name : 'TripExpenseItemView',
	#superclass : 'CpView',
	#category : 'TripExpenses-UI-TripDetail',
	#package : 'TripExpenses-UI',
	#tag : 'TripDetail'
}

{ #category : 'web resources' }
TripExpenseItemView class >> style [
	<webResource: #css>
	^ ':host { display: block; }
	   .expense { display: flex; justify-content: space-between; align-items: center;
	              padding: .6rem 0; border-bottom: 1px solid #f0f0f0; }
	   .desc    { font-weight: 500; }
	   .meta    { font-size: .8rem; color: #888; }
	   .amount  { font-weight: 500; color: #3c3489; white-space: nowrap; margin-left: 1rem; }
	   .btn-delete { background: transparent; border: none; cursor: pointer;
	                 color: #993c1d; font-size: .85rem; margin-left: .75rem;
	                 padding: .2rem .4rem; border-radius: 4px; }
	   .btn-delete:hover { background: #fee; }'
]

{ #category : 'web resources' }
TripExpenseItemView class >> template [

	<webResource: #html>
	^ '<div class="expense">
	     <div>
	       <div class="desc" id="desc"></div>
		       <div class="meta" id="payer"></div>
	       <div class="meta" id="beneficiaries"></div>
	       <div class="meta" id="date"></div>
	     </div>
	     <div style="display:flex;align-items:center">
	       <div class="amount" id="amount"></div>
	       <button id="btn-delete" class="btn-delete" title="Supprimer">&#10005;</button>
	     </div>
	   </div>'
]

{ #category : 'rendering' }
TripExpenseItemView >> handleDelete [

	| expenseId |
	expenseId :=''.
	expenseId := self attributeAt: 'data-expense-id'.
	self serverAnnounce: (TripExpenseDeleteRequested expenseId: expenseId)
]

{ #category : 'rendering' }
TripExpenseItemView >> initializeShadowRoot [
	super initializeShadowRoot.
	(self shadowedElementWithId: #'btn-delete')
		when: CpClickEvent basicPrimary
		send: #handleDelete
		to:   self
]

{ #category : 'rendering' }
TripExpenseItemView >> renderDescription: aDesc amount: anAmount currency: aCurrency date: aDate payerName: aPayerName beneficiaryNames: aBeneficiaryNames [

	(self shadowedElementWithId: #desc) textContent: aDesc.
	(self shadowedElementWithId: #date) textContent: aDate.
	(self shadowedElementWithId: #payer) textContent: 'Payé: ',aPayerName.
	(self shadowedElementWithId: #beneficiaries) textContent: 'Beneficiaires: ',
		aBeneficiaryNames.
	(self shadowedElementWithId: #amount) textContent:
		anAmount , ' ' , aCurrency
]
