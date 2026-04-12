Class {
	#name : 'TripExpenseItemView',
	#superclass : 'CpView',
	#category : 'TripExpenses-UI-Expense',
	#package : 'TripExpenses-UI',
	#tag : 'Expense'
}

{ #category : 'web resources' }
TripExpenseItemView class >> style [
    <webResource: #css>
    ^ '
    :host { display: block; margin-bottom: .75rem; }
    .expense-card {
        border: 1px solid #e8e8ff;
        border-radius: 12px;
        padding: 1rem;
        background: white;
        box-shadow: 0 1px 4px rgba(80,70,228,.08);
    }
    .expense-top {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: .4rem;
    }
    .expense-desc {
        font-weight: 600;
        font-size: 1rem;
        color: #1a1a2e;
        flex: 1;
    }
    .expense-amount {
        font-size: 1.1rem;
        font-weight: 700;
        color: #5046e4;
        margin-left: .75rem;
        white-space: nowrap;
    }
    .expense-meta {
        display: flex;
        justify-content: space-between;
        font-size: .8rem;
        color: #888;
        margin-bottom: .3rem;
    }
    .expense-beneficiaries {
        font-size: .8rem;
        color: #666;
        margin-bottom: .75rem;
    }
    .expense-actions {
        display: flex;
        gap: .5rem;
    }
    .btn-gift {
        flex: 1;
        background: #f0eeff;
        color: #5046e4;
        border: 1px solid #d0c8ff;
        border-radius: 8px;
        padding: .4rem .75rem;
        cursor: pointer;
        font-size: .85rem;
    }
    .btn-delete {
        background: #fff0f0;
        color: #c0392b;
        border: 1px solid #ffc0c0;
        border-radius: 8px;
        padding: .4rem .75rem;
        cursor: pointer;
        font-size: .85rem;
    }
    .btn-gift:hover { background: #e0d8ff; }
    .btn-delete:hover { background: #ffe0e0; }
    '
]

{ #category : 'web resources' }
TripExpenseItemView class >> template [
    <webResource: #html>
    ^ '
    <div class="expense-card">
        <div class="expense-top">
            <span class="expense-desc" id="desc"></span>
            <span class="expense-amount" id="amount"></span>
        </div>
        <div class="expense-meta">
            <span class="expense-payer" id="payer"></span>
            <span class="expense-date" id="date"></span>
        </div>
        <div class="expense-beneficiaries" id="beneficiaries"></div>
        <div class="expense-actions">
            <button id="btn-gift" class="btn-gift">🎁 Cadeau</button>
            <button id="btn-delete" class="btn-delete">✕ Supprimer</button>
        </div>
    </div>
    <slot name="giftForm"></slot>'
]

{ #category : 'event handling' }
TripExpenseItemView >> handleAddGift [
    self serverAnnounce: (TripExpenseGiftAddRequested
        expenseId: (self attributeAt: 'data-expense-id'))
]

{ #category : 'event handling' }
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
		to: self.
		(self shadowedElementWithId: #'btn-gift')
    when: CpClickEvent basicPrimary
    send: #handleAddGift
    to: self.
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
