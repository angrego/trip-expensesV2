Class {
	#name : 'TripExpenseFormView',
	#superclass : 'CpView',
	#category : 'TripExpenses-UI-Expense',
	#package : 'TripExpenses-UI',
	#tag : 'Expense'
}

{ #category : 'web resources' }
TripExpenseFormView class >> style [

	<webResource: #css>
	^ '
    :host { display: block; }
.error-banner { background: #fee; border: 1px solid #f99; border-radius: 8px; padding: .75rem; margin-bottom: 1rem; color: #900; }

    .expense-form { border: 1px solid #e0e0e0; border-radius: 12px; padding: 1.25rem; margin-bottom: 1rem; }
    .expense-form h3 { margin: 0 0 1rem; font-size: 1rem; }
    .input  { display: block; width: 100%; box-sizing: border-box; border: 1px solid #ccc; border-radius: 8px; padding: .5rem; margin: .25rem 0 .75rem; font-size: 1rem; }
    .select { display: block; width: 100%; box-sizing: border-box; border: 1px solid #ccc; border-radius: 8px; padding: .5rem; margin: .25rem 0 .75rem; font-size: 1rem; background: #fff; }
    .btn-primary   { background: #5046e4; color: #fff; border: none; border-radius: 8px; padding: .5rem 1rem; cursor: pointer; margin-top: .5rem; }
    .btn-secondary { background: transparent; border: 1px solid #ccc; border-radius: 8px; padding: .5rem 1rem; cursor: pointer; margin-top: .5rem; }
    .btn-small { font-size: .85rem; padding: .3rem .6rem; }
    .form-actions { display: flex; gap: .5rem; }
    .section-subtitle { font-size: .9rem; font-weight: 500; color: #666; margin: .75rem 0 .25rem; }
    .weight-row { display: flex; align-items: center; gap: .75rem; margin: .4rem 0; }
    .weight-row input[type=checkbox] { width: 18px; height: 18px; cursor: pointer; }
    .weight-row input[type=number]   { width: 60px; border: 1px solid #ccc; border-radius: 6px; padding: .3rem .4rem; font-size: .95rem; text-align: center; }
    .share-label { min-width: 80px; font-size: .9rem; color: #444; font-weight: 500; }
    .participant-name { min-width: 80px; font-size: .9rem; }
    .gift-row { display: flex; align-items: center; gap: .5rem; margin-bottom: .5rem; flex-wrap: wrap; }
    .select-small { font-size: .85rem; padding: .2rem .4rem; border: 1px solid #e0e0e0; border-radius: 6px; background: white; flex: 1; min-width: 80px; }
    .btn-remove { background: transparent; border: none; cursor: pointer; color: #993c1d; font-size: .85rem; padding: .2rem .4rem; border-radius: 4px; }
    .btn-remove:hover { background: #fee; }
    .amount-wrapper { display: flex; align-items: center; gap: .5rem; flex: 1; }
    .amount-slider { flex: 1; min-width: 60px; }
    .amount-number { width: 70px; font-size: .85rem; padding: .2rem .4rem; border: 1px solid #e0e0e0; border-radius: 6px; }
#btn-add-gift:disabled { opacity: 0.4; cursor: not-allowed; }
    '
]

{ #category : 'web resources' }
TripExpenseFormView class >> template [

	<webResource: #html>
	^ '
    <div id="expense-form" class="expense-form">
        <h3>Nouvelle depense</h3>
<div id="error-banner" class="error-banner" style="display:none"></div>
        <label>Description</label>
        <input id="expense-desc" class="input" type="text" placeholder="Ex : Restaurant">
        <label>Montant</label>
        <input id="expense-amount" class="input" type="number" min="0" step="1" placeholder="0.00">
        <label>Paye par</label>
        <select id="expense-payer" class="select"></select>
        <label>Repartition</label>
        <slot name="weights"></slot>
    <div class="form-actions">
        <button id="btn-add" class="btn-primary">Ajouter</button>
        <button id="btn-cancel" class="btn-secondary">Annuler</button>
    </div>
       
    </div>
    '
]

{ #category : 'event handling' }
TripExpenseFormView >> handleAddExpense [
    | desc amount payerId |
    desc    := (self shadowedElementWithId: #'expense-desc')   propertyAt: 'value'.
    amount  := (self shadowedElementWithId: #'expense-amount') propertyAt: 'value'.
    payerId := (self shadowedElementWithId: #'expense-payer')  propertyAt: 'value'.
    self serverAnnounce: (TripDetailAddExpenseRequested
        description: desc
        amountString: amount
        payerId: payerId)
]

{ #category : 'event handling' }
TripExpenseFormView >> handleAddGift [
self serverAnnounce: TripDetailGiftAddRequested
]

{ #category : 'event handling' }
TripExpenseFormView >> handleAmountChanged [

| val |
    val := (self shadowedElementWithId: 'expense-amount') propertyAt: 'value'.
    (val isNil or: [ val isEmpty ]) ifTrue: [ ^ self ].
    self serverAnnounce: (TripExpenseAmountChanged amount: val asNumber)
]

{ #category : 'event handling' }
TripExpenseFormView >> handleHideForm [
    self serverAnnounce: TripDetailHideExpenseFormRequested
]

{ #category : 'event handling' }
TripExpenseFormView >> handlePayerChanged [
| payerId |
    payerId := (self shadowedElementWithId: #'expense-payer') propertyAt: 'value'.
    self serverAnnounce: (TripExpensePayerChanged payerId: payerId)
]

{ #category : 'initialization' }
TripExpenseFormView >> initializeShadowRoot [

	super initializeShadowRoot.
	(self shadowedElementWithId: #'btn-add')
		when: CpClickEvent basicPrimary
		send: #handleAddExpense
		to: self.
	(self shadowedElementWithId: #'btn-cancel')
		when: CpClickEvent basicPrimary
		send: #handleHideForm
		to: self.
	(self shadowedElementWithId: #'expense-payer')
		when: CpChangeEvent
		send: #handlePayerChanged
		to: self.
	(self shadowedElementWithId: #'expense-amount')
		when: CpInputEvent
		send: #handleAmountChanged
		to: self
]

{ #category : 'rendering' }
TripExpenseFormView >> renderErrorMessage: aString [
	| banner |
	banner := self shadowedElementWithId: #'error-banner'.
	aString isEmpty
		ifTrue: [
				banner style: 'display:none'.
				banner textContent: '' ]
		ifFalse: [
				banner style: 'display:block'.
				banner textContent: aString ]
]

{ #category : 'rendering' }
TripExpenseFormView >> renderPayerOptions: aCollectionOfArrays [

	| select currentValue html |
	select := self shadowedElementWithId: #'expense-payer'.
	currentValue := select propertyAt: 'value'.
	html := String streamContents: [ :s |
			        aCollectionOfArrays do: [ :arr |
					        s
						        nextPutAll: '<option value="';
						        nextPutAll: arr first;
						        nextPutAll: '">';
						        nextPutAll: (arr at: 2);
						        nextPutAll: '</option>' ] ].
	select propertyAt: 'innerHTML' put: html.
	currentValue isEmpty ifFalse: [
		select propertyAt: 'value' put: currentValue ]
]

{ #category : 'rendering' }
TripExpenseFormView >> renderPayerOptions: aCollectionOfArrays currentPayerId: aPayerId locked: aBoolean [

	| select html |
	select := self shadowedElementWithId: #'expense-payer'.
	html := String streamContents: [ :s |
			        s nextPutAll:
				        '<option value="">-- Pas encore payé --</option>'.
			        aCollectionOfArrays do: [ :arr |
					        s
						        nextPutAll: '<option value="';
						        nextPutAll: arr first;
						        nextPutAll: '">';
						        nextPutAll: (arr at: 2);
						        nextPutAll: '</option>' ] ].
	select propertyAt: 'innerHTML' put: html.
	aPayerId ifNotNil: [ select propertyAt: 'value' put: aPayerId ].
	aBoolean
		ifTrue: [ select attributeAt: 'disabled' put: '' ]
		ifFalse: [ select removeAttributeAt: 'disabled' ]
]

{ #category : 'rendering' }
TripExpenseFormView >> renderPayerOptions: aCollectionOfArrays locked: aBoolean [
    | select html |
    select := self shadowedElementWithId: #'expense-payer'.
    html := String streamContents: [ :s |
        aCollectionOfArrays do: [ :arr |
            s
                nextPutAll: '<option value="';
                nextPutAll: (arr at: 1);
                nextPutAll: '">';
                nextPutAll: (arr at: 2);
                nextPutAll: '</option>' ] ].
    select propertyAt: 'innerHTML' put: html.
    aBoolean
        ifTrue:  [ select attributeAt: 'disabled' put: '' ]
        ifFalse: [ select removeAttributeAt: 'disabled' ]
]

{ #category : 'rendering' }
TripExpenseFormView >> reset [
    (self shadowedElementWithId: #'expense-desc')
        propertyAt: 'value' put: ''.
    (self shadowedElementWithId: #'expense-amount')
        propertyAt: 'value' put: ''
]
