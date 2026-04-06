"
I display the detail of a trip: header, participants, expenses, balances, settlements.
I am a Passive View — I only receive Strings and Booleans from my Presenter.
The back button announces TripDetailBackRequested.
"
Class {
	#name : 'TripDetailView',
	#superclass : 'CpView',
	#instVars : [
		'weightRows'
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
        <div id="expense-form" class="expense-form" style="display:none">
            <h3>Nouvelle depense</h3>
            <label>Description</label>
            <input id="expense-desc" class="input" type="text" placeholder="Ex : Restaurant">
            <label>Montant</label>
            <input id="expense-amount" class="input" type="number" min="0.01" step="0.01" placeholder="0.00">
            <label>Paye par</label>
            <select id="expense-payer" class="select"></select>
            <label>Repartition</label>
            <div id="participant-weights"></div>
            <div class="section-subtitle">Cadeaux</div>
            <div id="gift-entries"></div>
            <button id="btn-add-gift" class="btn-secondary btn-small">+ Ajouter un cadeau</button>
            <div class="form-actions">
                <button id="btn-add" class="btn-primary">Ajouter</button>
                <button id="btn-cancel" class="btn-secondary">Annuler</button>
            </div>
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
TripDetailView >> currencyFromDOM [
    ^ (self shadowedElementWithId: #'trip-name')
        attributeAt: 'data-currency'
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
TripDetailView >> handleBack [
	self serverAnnounce: TripDetailBackRequested
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
        when: CpClickEvent basicPrimary send: #handleShowForm to: self.
    (self shadowedElementWithId: #'btn-add')
        when: CpClickEvent basicPrimary send: #handleAddExpense to: self.
    (self shadowedElementWithId: #'btn-cancel')
        when: CpClickEvent basicPrimary send: #handleHideForm to: self.
    (self shadowedElementWithId: #'btn-add-gift')
        when: CpClickEvent basicPrimary send: #handleAddGift to: self
]

{ #category : 'rendering' }
TripDetailView >> recalculateShares [

	| amountStr amount totalWeight currency |
	weightRows ifNil: [ ^ self ].
	amountStr := (self shadowedElementWithId: #'expense-amount')
		             propertyAt: 'value'.
	amount := amountStr isEmpty
		          ifTrue: [ 0 ]
		          ifFalse: [ amountStr asNumber ].
	currency := [ self currencyFromDOM ]
		            on: Error
		            do: [ '' ].

	totalWeight := weightRows inject: 0 into: [ :sum :assoc |
			               | cb |
			               cb := assoc value first.
			               (cb propertyAt: 'checked')
				               ifTrue: [
						               | w |
						               w := assoc value second propertyAt: 'value'.
						               w := w isEmpty
							                    ifTrue: [ 1 ]
							                    ifFalse: [ w asNumber ].
						               sum + w ]
				               ifFalse: [ sum ] ].

	weightRows do: [ :assoc |
			| cb inp label share text |
			cb := assoc value first.
			inp := assoc value second.
			label := assoc value third.
			(cb propertyAt: 'checked')
				ifTrue: [
						| w |
						w := inp propertyAt: 'value'.
						w := w isEmpty
							     ifTrue: [ 1 ]
							     ifFalse: [ w asNumber ].
						share := totalWeight = 0
							         ifTrue: [ 0 ]
							         ifFalse: [ amount * w / totalWeight roundTo: 0.01 ].
						text := share printString , ' ' , currency ]
				ifFalse: [ text := '–' ].
			label textContent: text ]
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
	aString isEmpty
		ifTrue: [
				banner style: 'display:none'.
				banner textContent: '' ]
		ifFalse: [
				banner style: 'display:block'.
				banner textContent: aString ]
]

{ #category : 'rendering' }
TripDetailView >> renderParticipantWeightEntries: aCollectionOfDicts [

	| container |
	container := self shadowedElementWithId: #'participant-weights'.
	container removeChildren.
	weightRows := OrderedCollection new.
	aCollectionOfDicts isEmpty ifTrue: [ ^ self ].
	weightRows addAll: (aCollectionOfDicts collect: [ :dict |
				 | row checkbox weightInput shareLabel |
				 row := CpHtmlElement newWithTag: 'div'.
				 row attributeAt: 'class' put: 'weight-row'.
				 checkbox := CpHtmlElement newWithTag: 'input'.
				 checkbox attributeAt: 'type' put: 'checkbox'.
				 (dict at: 'included') ifTrue: [
					 checkbox attributeAt: 'checked' put: '' ].
				 weightInput := CpHtmlElement newWithTag: 'input'.
				 weightInput attributeAt: 'type' put: 'number'.
				 weightInput attributeAt: 'min' put: '1'.
				 weightInput attributeAt: 'class' put: 'weight-input'.
				 weightInput
					 propertyAt: 'value'
					 put: (dict at: 'weight') printString.
				 (dict at: 'included') ifFalse: [
					 weightInput attributeAt: 'disabled' put: '' ].
				 shareLabel := CpHtmlElement newWithTag: 'span'.
				 shareLabel attributeAt: 'class' put: 'share-label'.
				 shareLabel textContent: '–'.
				 checkbox
					 when: CpChangeEvent
					 do: [
							 (checkbox propertyAt: 'checked')
								 ifTrue: [ weightInput removeAttributeAt: 'disabled' ]
								 ifFalse: [ weightInput attributeAt: 'disabled' put: '' ].
							 self recalculateShares ]
					 for: self.
				 weightInput
					 when: CpInputEvent
					 do: [ self recalculateShares ]
					 for: self.
				 row appendChild: checkbox.
				 row appendChild: weightInput.
				 row appendChild: shareLabel.
				 container appendChild: row.
				 (dict at: 'id') -> {
					 checkbox.
					 weightInput.
					 shareLabel } ]).

	(self shadowedElementWithId: #'expense-amount')
		when: CpInputEvent
		do: [ self recalculateShares ]
		for: self.

	self recalculateShares
]

{ #category : 'rendering' }
TripDetailView >> renderPayerOptions: aCollectionOfDicts [
	"Recoit un Array de Dictionary { 'id' -> String. 'name' -> String }.
	 Construit les <option> directement — pas de String encodee a decoder."
	| select |
	select := self shadowedElementWithId: #'expense-payer'.
	select removeChildren.
	aCollectionOfDicts do: [ :dict |
		| option |
		option := CpHtmlElement newWithTag: 'option'.
		option attributeAt: 'value' put: (dict at: 'id').
		option textContent: (dict at: 'name').
		select appendChild: option ]
]

{ #category : 'rendering' }
TripDetailView >> renderShowExpenseForm: aBoolean [
	| form btn |
	form := self shadowedElementWithId: #'expense-form'.
	btn := self shadowedElementWithId: #'btn-show-form'.
	aBoolean
		ifTrue: [
				form style: 'display:block'.
				btn style: 'display:none'.
				(self shadowedElementWithId: #'expense-desc')
					propertyAt: 'value'
					put: ''.
				(self shadowedElementWithId: #'expense-amount')
					propertyAt: 'value'
					put: '' ]
		ifFalse: [
				form style: 'display:none'.
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
