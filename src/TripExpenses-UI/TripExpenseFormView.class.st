Class {
	#name : 'TripExpenseFormView',
	#superclass : 'CpView',
	#instVars : [
		'weightRows',
		'amountSliders',
		'payerOptions'
	],
	#category : 'TripExpenses-UI-Expense',
	#package : 'TripExpenses-UI',
	#tag : 'Expense'
}

{ #category : 'web resources' }
TripExpenseFormView class >> style [
    <webResource: #css>
    ^ '
    :host { display: block; }
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
    '
]

{ #category : 'web resources' }
TripExpenseFormView class >> template [
    <webResource: #html>
    ^ '
    <div id="expense-form" class="expense-form">
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
    '
]

{ #category : 'rendering' }
TripExpenseFormView >> buildCheckboxFor: dict [
    | checkbox |
    checkbox := CpHtmlElement newWithTag: 'input'.
    checkbox attributeAt: 'type' put: 'checkbox'.
    (dict at: 'included') ifTrue: [
        checkbox attributeAt: 'checked' put: '' ].
    ^ checkbox
]

{ #category : 'rendering' }
TripExpenseFormView >> buildGiftAmountInputFor: dict [
    | wrapper slider numberInput mode |
    mode := dict at: 'mode'.
    wrapper := CpHtmlElement newWithTag: 'div'.
    wrapper attributeAt: 'class' put: 'amount-wrapper'.
    mode = 'share' ifTrue: [
        wrapper attributeAt: 'style' put: 'display:none' ].

    slider := CpHtmlElement newWithTag: 'input'.
    slider attributeAt: 'type' put: 'range'.
    slider attributeAt: 'min' put: '0'.
    slider attributeAt: 'max' put: '0'.
    slider attributeAt: 'step' put: '1'.
    slider attributeAt: 'class' put: 'amount-slider'.
    slider propertyAt: 'value' put: (dict at: 'amount') printString.

    numberInput := CpHtmlElement newWithTag: 'input'.
    numberInput attributeAt: 'type' put: 'number'.
    numberInput attributeAt: 'min' put: '0'.
    numberInput attributeAt: 'step' put: '0.01'.
    numberInput attributeAt: 'class' put: 'amount-number'.
    numberInput propertyAt: 'value' put: (dict at: 'amount') printString.

    slider
        when: CpInputEvent
        do: [ numberInput propertyAt: 'value' put: (slider propertyAt: 'value') ]
        for: self.

    numberInput
        when: CpInputEvent
        do: [
            | val |
            slider propertyAt: 'value' put: (numberInput propertyAt: 'value').
            val := numberInput propertyAt: 'value'.
            val isEmpty ifFalse: [
                [ self serverAnnounce: (TripDetailGiftAmountChanged
                    entryId: (dict at: 'entryId')
                    amount: val asNumber) ]
                on: Error
                do: [ :e | "ignorer les valeurs invalides" ] ] ]
        for: self.

    amountSliders ifNotNil: [ amountSliders add: slider ].

    wrapper appendChild: slider.
    wrapper appendChild: numberInput.
    ^ wrapper
]

{ #category : 'rendering' }
TripExpenseFormView >> buildGiftFromSelectFor: dict [
    | select |
    select := self buildParticipantSelectNamed: 'from' value: (dict at: 'fromId').
    select
        when: CpChangeEvent
        do: [ self serverAnnounce: (TripDetailGiftFromChanged
                entryId: (dict at: 'entryId')
                fromId: (select propertyAt: 'value')) ]
        for: self.
    ^ select
]

{ #category : 'rendering' }
TripExpenseFormView >> buildGiftModeSelectFor: dict amountInput: anAmountInput [
    | select mode |
    mode := dict at: 'mode'.
    select := CpHtmlElement newWithTag: 'select'.
    select attributeAt: 'class' put: 'select-small'.
    #('fixed' 'share' 'globalShare') do: [ :m |
        | opt |
        opt := CpHtmlElement newWithTag: 'option'.
        opt attributeAt: 'value' put: m.
        mode = m ifTrue: [ opt attributeAt: 'selected' put: '' ].
        opt textContent: (m = 'fixed'
            ifTrue:  [ 'montant fixe' ]
            ifFalse: [ m = 'share'
                ifTrue:  [ 'payer la part' ]
                ifFalse: [ 'cadeau global' ] ]).
        select appendChild: opt ].
    select
        when: CpChangeEvent
        do: [
            | newMode |
            newMode := (select propertyAt: 'value') asSymbol.
            newMode = #share
                ifTrue:  [ anAmountInput attributeAt: 'style' put: 'display:none' ]
                ifFalse: [ anAmountInput removeAttributeAt: 'style' ].
            self serverAnnounce: (TripDetailGiftModeChanged
                entryId: (dict at: 'entryId')
                mode: newMode) ]
        for: self.
    ^ select
]

{ #category : 'rendering' }
TripExpenseFormView >> buildGiftRemoveButtonFor: dict [
    | btn |
    btn := CpHtmlElement newWithTag: 'button'.
    btn attributeAt: 'class' put: 'btn-remove'.
    btn textContent: '✕'.
    btn
        when: CpClickEvent basicPrimary
        do: [ self serverAnnounce: (TripDetailGiftRemoveRequested
                entryId: (dict at: 'entryId')) ]
        for: self.
    ^ btn
]

{ #category : 'rendering' }
TripExpenseFormView >> buildGiftRowFor: dict [
    | row amountInput |
    row := CpHtmlElement newWithTag: 'div'.
    row attributeAt: 'class' put: 'gift-row'.
    row attributeAt: 'data-entry-id' put: (dict at: 'entryId').
    amountInput := self buildGiftAmountInputFor: dict.
    row appendChild: (self buildGiftFromSelectFor: dict).
    row appendChild: (self buildGiftToSelectFor: dict).
    row appendChild: (self buildGiftModeSelectFor: dict amountInput: amountInput).
    row appendChild: amountInput.
    row appendChild: (self buildGiftRemoveButtonFor: dict).
    ^ row
]

{ #category : 'rendering' }
TripExpenseFormView >> buildGiftToSelectFor: dict [
    | select |
    select := self buildParticipantSelectNamed: 'to' value: (dict at: 'toId').
    (dict at: 'mode') = 'globalShare' ifTrue: [
        select attributeAt: 'style' put: 'display:none' ].
    select
        when: CpChangeEvent
        do: [ self serverAnnounce: (TripDetailGiftToChanged
                entryId: (dict at: 'entryId')
                toId: (select propertyAt: 'value')) ]
        for: self.
    ^ select
]

{ #category : 'rendering' }
TripExpenseFormView >> buildNameLabelFor: dict [
    | label |
    label := CpHtmlElement newWithTag: 'span'.
    label attributeAt: 'class' put: 'participant-name'.
    label textContent: (dict at: 'name').
    ^ label
]

{ #category : 'rendering' }
TripExpenseFormView >> buildParticipantSelectNamed: aName value: aValue [
    | select |
    select := CpHtmlElement newWithTag: 'select'.
    select attributeAt: 'class' put: 'select-small'.
    payerOptions ifNotNil: [
        payerOptions do: [ :dict |
            | opt |
            opt := CpHtmlElement newWithTag: 'option'.
            opt attributeAt: 'value' put: (dict at: 'id').
            (dict at: 'id') = aValue ifTrue: [
                opt attributeAt: 'selected' put: '' ].
            opt textContent: (dict at: 'name').
            select appendChild: opt ] ].
    ^ select
]

{ #category : 'rendering' }
TripExpenseFormView >> buildWeightInputFor: dict checkbox: checkbox [
    | weightInput |
    weightInput := CpHtmlElement newWithTag: 'input'.
    weightInput attributeAt: 'type' put: 'number'.
    weightInput attributeAt: 'min' put: '1'.
    weightInput attributeAt: 'class' put: 'weight-input'.
    weightInput propertyAt: 'value' put: (dict at: 'weight') printString.
    (dict at: 'included') ifFalse: [
        weightInput attributeAt: 'disabled' put: '' ].
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
    ^ weightInput
]

{ #category : 'rendering' }
TripExpenseFormView >> buildWeightRowFor: dict appendTo: container [
    | row checkbox nameLabel weightInput shareLabel |
    row := CpHtmlElement newWithTag: 'div'.
    row attributeAt: 'class' put: 'weight-row'.
    checkbox := self buildCheckboxFor: dict.
    nameLabel := self buildNameLabelFor: dict.
    weightInput := self buildWeightInputFor: dict checkbox: checkbox.
    shareLabel := CpHtmlElement newWithTag: 'span'.
    shareLabel attributeAt: 'class' put: 'share-label'.
    shareLabel textContent: '–'.
    row appendChild: checkbox.
    row appendChild: nameLabel.
    row appendChild: weightInput.
    row appendChild: shareLabel.
    container appendChild: row.
    ^ (dict at: 'id') -> { checkbox. weightInput. shareLabel }
]

{ #category : 'rendering' }
TripExpenseFormView >> computeShareText: amount weight: w totalWeight: totalWeight currency: currency [
    | share |
    share := totalWeight = 0
        ifTrue: [ 0 ]
        ifFalse: [ amount * w / totalWeight roundTo: 0.01 ].
    ^ share printString , ' ' , currency
]

{ #category : 'rendering' }
TripExpenseFormView >> computeTotalWeight [
    ^ weightRows inject: 0 into: [ :sum :assoc |
        | cb |
        cb := assoc value first.
        (cb propertyAt: 'checked')
            ifTrue: [
                | w |
                w := assoc value second propertyAt: 'value'.
                w := w isEmpty ifTrue: [ 1 ] ifFalse: [ w asNumber ].
                sum + w ]
            ifFalse: [ sum ] ]
]

{ #category : 'rendering' }
TripExpenseFormView >> currencyFromDOM [
    ^ (self shadowedElementWithId: #'trip-name')
        attributeAt: 'data-currency'
]

{ #category : 'initialization' }
TripExpenseFormView >> handleAddExpense [

	| desc amount payerId weights |
	desc := (self shadowedElementWithId: #'expense-desc') propertyAt:
		        'value'.
	amount := (self shadowedElementWithId: #'expense-amount')
		          propertyAt: 'value'.
	payerId := (self shadowedElementWithId: #'expense-payer')
		           propertyAt: 'value'.
	weights := (weightRows ifNil: [ #(  ) ] ifNotNil: [ weightRows ])
		           collect: [ :assoc |
				           | cb inp pid w |
				           pid := assoc key.
				           cb := assoc value first.
				           inp := assoc value second.
				           w := (cb propertyAt: 'checked')
					                ifTrue: [
							                | v |
							                v := inp propertyAt: 'value'.
							                v isEmpty
								                ifTrue: [ '1' ]
								                ifFalse: [ v ] ]
					                ifFalse: [ '0' ].
				           pid , ':' , w ].
	self serverAnnounce: (TripDetailAddExpenseRequested
			 description: desc
			 amountString: amount
			 payerId: payerId
			 weightsString: weights asArray)
]

{ #category : 'initialization' }
TripExpenseFormView >> handleAddGift [
    self serverAnnounce: TripDetailGiftAddRequested
]

{ #category : 'initialization' }
TripExpenseFormView >> handleHideForm [
    self serverAnnounce: TripDetailHideExpenseFormRequested
]

{ #category : 'initialization' }
TripExpenseFormView >> initializeShadowRoot [
    super initializeShadowRoot.
    (self shadowedElementWithId: #'btn-add')
        when: CpClickEvent basicPrimary send: #handleAddExpense to: self.
    (self shadowedElementWithId: #'btn-cancel')
        when: CpClickEvent basicPrimary send: #handleHideForm to: self.
    (self shadowedElementWithId: #'btn-add-gift')
        when: CpClickEvent basicPrimary send: #handleAddGift to: self
]

{ #category : 'rendering' }
TripExpenseFormView >> readExpenseAmount [
    | str |
    str := (self shadowedElementWithId: #'expense-amount') propertyAt: 'value'.
    ^ str isEmpty ifTrue: [ 0 ] ifFalse: [ str asNumber ]
]

{ #category : 'rendering' }
TripExpenseFormView >> readWeight: anInput [
    | w |
    w := anInput propertyAt: 'value'.
    ^ w isEmpty ifTrue: [ 1 ] ifFalse: [ w asNumber ]
]

{ #category : 'rendering' }
TripExpenseFormView >> recalculateShares [

	| amount totalWeight currency |
	weightRows ifNil: [ ^ self ].
	amount := self readExpenseAmount.
(self shadowedElementsWithClass: 'amount-slider') do: [ :s |
    s attributeAt: 'max' put: amount printString ].
	currency := [ self currencyFromDOM ]
		            on: Error
		            do: [ '' ].
	totalWeight := self computeTotalWeight.
	self
		updateShareLabels: amount
		totalWeight: totalWeight
		currency: currency
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
TripExpenseFormView >> renderGiftEntries: aCollectionOfDicts [
    | container |
    container := self shadowedElementWithId: #'gift-entries'.
    container removeChildren.
    aCollectionOfDicts do: [ :dict |
        | row |
        row := self buildGiftRowFor: dict.
        container appendChild: row ]
]

{ #category : 'rendering' }
TripExpenseFormView >> renderParticipantWeightEntries: aCollectionOfDicts [

	| container |
    container := self shadowedElementWithId: #'participant-weights'.
    container removeChildren.
    weightRows := OrderedCollection new.
    aCollectionOfDicts isEmpty ifTrue: [ ^ self ].
    weightRows addAll: (aCollectionOfDicts collect: [ :dict |
        self buildWeightRowFor: dict appendTo: container ]).
    (self shadowedElementWithId: #'expense-amount')
        when: CpInputEvent
        do: [ self recalculateShares ]
        for: self.
    self recalculateShares
]

{ #category : 'rendering' }
TripExpenseFormView >> renderPayerOptions: aCollectionOfDicts [
    | select |
    payerOptions := aCollectionOfDicts.
    select := self shadowedElementWithId: #'expense-payer'.
    select removeChildren.
    aCollectionOfDicts do: [ :dict |
        | opt |
        opt := CpHtmlElement newWithTag: 'option'.
        opt attributeAt: 'value' put: (dict at: 'id').
        opt textContent: (dict at: 'name').
        select appendChild: opt ]
]

{ #category : 'rendering' }
TripExpenseFormView >> updateShareLabels: amount totalWeight: totalWeight currency: currency [
    weightRows do: [ :assoc |
        | cb inp label text |
        cb    := assoc value first.
        inp   := assoc value second.
        label := assoc value third.
        text  := (cb propertyAt: 'checked')
            ifTrue: [ self computeShareText: amount
                          weight: (self readWeight: inp)
                          totalWeight: totalWeight
                          currency: currency ]
            ifFalse: [ '–' ].
        label textContent: text ]
]
