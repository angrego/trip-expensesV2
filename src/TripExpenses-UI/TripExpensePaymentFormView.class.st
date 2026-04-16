Class {
	#name : 'TripExpensePaymentFormView',
	#superclass : 'CpView',
	#category : 'TripExpenses-UI-PaymentForm',
	#package : 'TripExpenses-UI',
	#tag : 'PaymentForm'
}

{ #category : 'web resources' }
TripExpensePaymentFormView class >> style [
    <webResource: #css>
    ^ '
    :host { display: block; }
    .overlay {
        position: fixed;
        top: 0; left: 0; right: 0; bottom: 0;
        background: rgba(0,0,0,.4);
        display: flex;
        align-items: flex-end;
        z-index: 100;
    }
    .sheet {
        background: white;
        border-radius: 16px 16px 0 0;
        padding: 1.5rem;
        width: 100%;
        box-sizing: border-box;
    }
    .sheet-title { font-size: 1.1rem; font-weight: 600; color: #2e7d32; margin-bottom: .5rem; }
    .remaining { font-size: .9rem; color: #666; margin-bottom: 1rem; }
    .input { display: block; width: 100%; box-sizing: border-box; border: 1px solid #ccc; border-radius: 8px; padding: .5rem; font-size: 1rem; margin-bottom: 1rem; }
    .form-actions { display: flex; gap: .5rem; }
    .btn-primary { flex: 1; background: #2e7d32; color: #fff; border: none; border-radius: 8px; padding: .75rem; cursor: pointer; font-size: 1rem; }
    .btn-secondary { flex: 1; background: transparent; border: 1px solid #ccc; border-radius: 8px; padding: .75rem; cursor: pointer; font-size: 1rem; }
    .error-banner { background: #fee; border: 1px solid #f99; border-radius: 8px; padding: .75rem; margin-bottom: 1rem; color: #900; }
    '
]

{ #category : 'web resources' }
TripExpensePaymentFormView class >> template [
    <webResource: #html>
    ^ '
    <div class="overlay">
        <div class="sheet">
            <div class="sheet-title">💰 Saisir mon paiement</div>
            <div class="remaining">Reste à payer : <span id="remaining"></span> <span id="currency"></span></div>
            <div id="error-banner" class="error-banner" style="display:none"></div>
            <input id="amount" class="input" type="number" min="0" step="0.01" placeholder="Montant payé">
            <div class="form-actions">
                <button id="btn-cancel" class="btn-secondary">Annuler</button>
                <button id="btn-add" class="btn-primary">Confirmer</button>
            </div>
        </div>
    </div>
    '
]

{ #category : 'rendering' }
TripExpensePaymentFormView >> handleAdd [
    | val |
    val := (self shadowedElementWithId: #'amount') propertyAt: 'value'.
    (val isNil or: [ val isEmpty ]) ifTrue: [ ^ self ].
    self serverAnnounce: (TripExpensePaymentFormAddRequested amount: val asNumber)
]

{ #category : 'rendering' }
TripExpensePaymentFormView >> handleCancel [
    self serverAnnounce: TripExpensePaymentFormHideRequested
]

{ #category : 'rendering' }
TripExpensePaymentFormView >> initializeShadowRoot [
    super initializeShadowRoot.
    (self shadowedElementWithId: #'btn-add')
        when: CpClickEvent basicPrimary send: #handleAdd to: self.
    (self shadowedElementWithId: #'btn-cancel')
        when: CpClickEvent basicPrimary send: #handleCancel to: self
]

{ #category : 'rendering' }
TripExpensePaymentFormView >> renderCurrency: aString [
    (self shadowedElementWithId: #'currency') textContent: aString
]

{ #category : 'rendering' }
TripExpensePaymentFormView >> renderErrorMessage: aString [
    | banner |
    banner := self shadowedElementWithId: #'error-banner'.
    aString isEmpty
        ifTrue:  [ banner style: 'display:none'. banner textContent: '' ]
        ifFalse: [ banner style: 'display:block'. banner textContent: aString ]
]

{ #category : 'rendering' }
TripExpensePaymentFormView >> renderRemainingAmount: aString [
    (self shadowedElementWithId: #'remaining') textContent: aString
]
