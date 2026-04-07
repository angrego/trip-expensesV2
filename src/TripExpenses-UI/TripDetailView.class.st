"
I display the detail of a trip: header, participants, expenses, balances, settlements.
I am a Passive View — I only receive Strings and Booleans from my Presenter.
The back button announces TripDetailBackRequested.
"
Class {
	#name : 'TripDetailView',
	#superclass : 'CpView',
	#instVars : [
		'weightRows',
		'payerOptions'
	],
	#category : 'TripExpenses-UI-TripDetail',
	#package : 'TripExpenses-UI',
	#tag : 'TripDetail'
}

{ #category : 'web resources' }
TripDetailView class >> style [

	<webResource: #css>
	^ '
	:host { display: block; padding: 1rem; font-family: sans-serif; max-width: 640px; margin: 0 auto; }
	.header { margin-bottom: 1.5rem; display: flex; align-items: center; gap: 1rem; }
	.btn-back { background: transparent; border: none; cursor: pointer; font-size: 1.2rem; color: #5046e4; padding: 0; }
	.trip-name { font-size: 1.5rem; font-weight: 500; margin: 0 0 .25rem; flex: 1; }
	.trip-meta { color: #666; font-size: .9rem; }
	.section { margin-bottom: 1.5rem; }
	.section-title { font-size: 1rem; font-weight: 500; margin: 0 0 .5rem; color: #444; border-bottom: 2px solid #e0e0e0; padding-bottom: .25rem; }
	.participants-list { display: flex; flex-wrap: wrap; gap: .25rem; }
	.btn-primary   { background: #5046e4; color: #fff; border: none; border-radius: 8px; padding: .5rem 1rem; cursor: pointer; margin-top: .5rem; }
	.btn-secondary { background: transparent; border: 1px solid #ccc; border-radius: 8px; padding: .5rem 1rem; cursor: pointer; margin-top: .5rem; }
	.expense-form  { border: 1px solid #e0e0e0; border-radius: 12px; padding: 1.25rem; margin-bottom: 1rem; }
	.expense-form h3 { margin: 0 0 1rem; font-size: 1rem; }
	.input  { display: block; width: 100%; box-sizing: border-box; border: 1px solid #ccc; border-radius: 8px; padding: .5rem; margin: .25rem 0 .75rem; font-size: 1rem; }
	.select { display: block; width: 100%; box-sizing: border-box; border: 1px solid #ccc; border-radius: 8px; padding: .5rem; margin: .25rem 0 .75rem; font-size: 1rem; background: #fff; }
	.form-actions { display: flex; gap: .5rem; }
	.error-banner { background: #fee; border: 1px solid #f99; border-radius: 8px; padding: .75rem; margin-bottom: 1rem; color: #900; }
	.empty { color: #999; font-size: .9rem; padding: .5rem 0; 
.participant-weight-row { display:flex; align-items:center; gap:.75rem; margin:.3rem 0; }
 .participant-weight-row label { flex:1; font-size:.95rem; }
 .weight-input { width:60px; border:1px solid #ccc; border-radius:6px; padding:.3rem .5rem; font-size:.95rem; text-align:center; }
 .weight-input:disabled { background:#f5f5f5; color:#aaa; }}
.weight-row { display: flex; align-items: center; gap: .75rem; margin: .4rem 0; }
 .weight-row input[type=checkbox] { width: 18px; height: 18px; cursor: pointer; }
 .weight-row input[type=number]   { width: 60px; border: 1px solid #ccc; border-radius: 6px; padding: .3rem .4rem; font-size: .95rem; text-align: center; }
 .share-label { min-width: 80px; font-size: .9rem; color: #444; font-weight: 500; }
.participant-name { min-width: 80px; font-size: .9rem; }
.gift-row {
    display: flex;
    align-items: center;
    gap: .5rem;
    margin-bottom: .5rem;
    flex-wrap: wrap;
}
.select-small {
    font-size: .85rem;
    padding: .2rem .4rem;
    border: 1px solid #e0e0e0;
    border-radius: 6px;
    background: white;
    flex: 1;
    min-width: 80px;
}
.btn-remove {
    background: transparent;
    border: none;
    cursor: pointer;
    color: #993c1d;
    font-size: .85rem;
    padding: .2rem .4rem;
    border-radius: 4px;
}
.btn-remove:hover { background: #fee; }
	'
]

{ #category : 'web resources' }
TripDetailView class >> template [

	<webResource: #html>
	^ '
    <div class="header">
        <button id="btn-back" class="btn-back" title="Retour">&#8592;</button>
        <div>
            <h1 class="trip-name" id="trip-name">…</h1>
            <div class="trip-meta" id="trip-meta"></div>
        </div>
    </div>
    <div id="error-banner" class="error-banner" style="display:none"></div>
    <div class="section">
        <div class="section-title">Participants</div>
        <div class="participants-list"><slot name="participants"></slot></div>
        <slot name="addParticipant"></slot>
    </div>
    <div class="section">
        <div class="section-title">Depenses</div>
<slot name="expenses"></slot>
        <div id="expense-form-container">
    <slot name="expenseForm"></slot>
</div>
<button id="btn-show-form" class="btn-primary">+ Ajouter une depense</button>
    </div>
    <div class="section">
        <div class="section-title">Balances</div>
        <slot name="balances"></slot>
    </div>
    <div class="section">
        <div class="section-title">Reglements</div>
        <slot name="settlements"></slot>
        <div id="empty-settlements" class="empty">Tout le monde est quitte !!!!</div>
    </div>
    '
]

{ #category : 'rendering' }
TripDetailView >> buildGiftEntries [

	| entries |
	entries := self model giftEntries.
	entries ifNil: [ ^ #(  ) ].
	^ (entries collect: [ :e |
			   Dictionary new
				   at: 'entryId' put: e entryId;
				   at: 'fromId' put: (e fromId ifNil: [ '' ]);
				   at: 'toId' put: (e toId ifNil: [ '' ]);
				   at: 'mode' put: e mode asString;
				   at: 'amount' put: (e amount ifNil: [ 0 ]);
				   yourself ]) asArray
]

{ #category : 'rendering' }
TripDetailView >> buildGiftModeSelectFor: dict [
    | select mode |
    mode := dict at: 'mode'.
    select := CpHtmlElement newWithTag: 'select'.
    select attributeAt: 'class' put: 'select-small'.
    #('fixed' 'share') do: [ :m |
        | opt |
        opt := CpHtmlElement newWithTag: 'option'.
        opt attributeAt: 'value' put: m.
        mode = m ifTrue: [ opt attributeAt: 'selected' put: '' ].
        opt textContent: (m = 'fixed' ifTrue: [ 'montant fixe' ] ifFalse: [ 'payer la part' ]).
        select appendChild: opt ].
    select
        when: CpChangeEvent
        do: [ self handleGiftModeChange: select forEntry: (dict at: 'entryId') ]
        for: self.
    ^ select
]

{ #category : 'event handling' }
TripDetailView >> handleAddExpense [
    | desc amount payerId weights |
    desc    := (self shadowedElementWithId: #'expense-desc')   propertyAt: 'value'.
    amount  := (self shadowedElementWithId: #'expense-amount') propertyAt: 'value'.
    payerId := (self shadowedElementWithId: #'expense-payer')  propertyAt: 'value'.

    weights := (weightRows isNil ifTrue: [ #() ] ifFalse: [ weightRows ])
        collect: [ :assoc |
            | cb inp pid w |
            pid := assoc key.
            cb  := assoc value first.
            inp := assoc value second.
            w   := (cb propertyAt: 'checked')
                ifTrue:  [
                    | v |
                    v := inp propertyAt: 'value'.
                    v isEmpty ifTrue: [ '1' ] ifFalse: [ v ] ]
                ifFalse: [ '0' ].
            pid , ':' , w ].

    self serverAnnounce: (TripDetailAddExpenseRequested
        description: desc
        amountString: amount
        payerId: payerId
        weightsString: weights asArray)
]

{ #category : 'event handling' }
TripDetailView >> handleAddGift [
self serverAnnounce: TripDetailGiftAddRequested
]

{ #category : 'event handling' }
TripDetailView >> handleBack [
	self serverAnnounce: TripDetailBackRequested
]

{ #category : 'rendering' }
TripDetailView >> handleGiftModeChange: aSelect forEntry: anEntryId [
    | newMode amountInput |
    newMode := (aSelect propertyAt: 'value') asSymbol.
    amountInput := aSelect nextElementSibling.
    newMode = #share
        ifTrue:  [ amountInput attributeAt: 'style' put: 'display:none' ]
        ifFalse: [ amountInput removeAttributeAt: 'style' ].
    self serverAnnounce: (TripDetailGiftModeChanged
        entryId: anEntryId
        mode: newMode)
]

{ #category : 'event handling' }
TripDetailView >> handleHideForm [
	self serverAnnounce: TripDetailHideExpenseFormRequested
]

{ #category : 'event handling' }
TripDetailView >> handleShowForm [
	self serverAnnounce: TripDetailShowExpenseFormRequested
]

{ #category : 'initialization' }
TripDetailView >> initializeShadowRoot [
    super initializeShadowRoot.
    (self shadowedElementWithId: #'btn-back')
        when: CpClickEvent basicPrimary send: #handleBack to: self.
    (self shadowedElementWithId: #'btn-show-form')
        when: CpClickEvent basicPrimary send: #handleShowForm to: self
]

{ #category : 'rendering' }
TripDetailView >> renderCurrency: aCurrency [
	(self shadowedElementWithId: #'trip-name')
		attributeAt: 'data-currency'
		put: aCurrency
]

{ #category : 'rendering' }
TripDetailView >> renderEmptySettlements:aBoolean [
	| empty |
	empty := self shadowedElementWithId: #'empty-settlements'.
	empty style: (aBoolean ifTrue: [ 'display:block' ] ifFalse: [ 'display:none' ])
]

{ #category : 'rendering' }
TripDetailView >> renderErrorMessage: aString [
    | banner |
    banner := self shadowedElementWithId: #'error-banner'.
    (aString isNil or: [ aString isEmpty ])
        ifTrue: [
            banner style: 'display:none'.
            banner textContent: '' ]
        ifFalse: [
            banner style: 'display:block'.
            banner textContent: aString ]
]

{ #category : 'rendering' }
TripDetailView >> renderShowExpenseForm: aBoolean [
    | container btn |
    container := self shadowedElementWithId: #'expense-form-container'.
    btn := self shadowedElementWithId: #'btn-show-form'.
    aBoolean
        ifTrue: [
            container style: 'display:block'.
            btn style: 'display:none' ]
        ifFalse: [
            container style: 'display:none'.
            btn style: 'display:block' ]
]

{ #category : 'rendering' }
TripDetailView >> renderTotalExpenses: aTotal [

	| currency meta |
	currency:=''.
	currency := (self shadowedElementWithId: #'trip-name')
		            attributeAt: 'data-currency'.
	meta := self shadowedElementWithId: #'trip-meta'.
	meta textContent: 'Total : ' , aTotal , ' ' , currency
]

{ #category : 'rendering' }
TripDetailView >> renderTripName: aName [
	(self shadowedElementWithId: #'trip-name') textContent: aName
]
