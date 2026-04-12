Class {
	#name : 'TripExpenseGiftFormView',
	#superclass : 'CpView',
	#category : 'TripExpenses-UI-Expense',
	#package : 'TripExpenses-UI',
	#tag : 'Expense'
}

{ #category : 'web resources' }
TripExpenseGiftFormView class >> style [

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
        max-height: 80vh;
        overflow-y: auto;
    }
    .sheet-title { font-size: 1.1rem; font-weight: 600; color: #5046e4; margin-bottom: 1rem; }
    .form-actions { display: flex; gap: .5rem; margin-top: 1rem; }
    .btn-primary { flex: 1; background: #5046e4; color: #fff; border: none; border-radius: 8px; padding: .75rem; cursor: pointer; font-size: 1rem; }
    .btn-secondary { flex: 1; background: transparent; border: 1px solid #ccc; border-radius: 8px; padding: .75rem; cursor: pointer; font-size: 1rem; }
.error-banner { background: #fee; border: 1px solid #f99; border-radius: 8px; padding: .75rem; margin-bottom: 1rem; color: #900; }
    '
]

{ #category : 'web resources' }
TripExpenseGiftFormView class >> template [

	<webResource: #html>
	^ '
    <div class="overlay">

        <div class="sheet">

            <div class="sheet-title">🎁 Ajouter un cadeau</div>
<div id="error-banner" class="error-banner" style="display:none"></div>
            <slot name="gift"></slot>
            <div class="form-actions">
                <button id="btn-cancel" class="btn-secondary">Annuler</button>
                <button id="btn-add" class="btn-primary">Ajouter</button>
            </div>
        </div>
    </div>
    '
]

{ #category : 'event handling' }
TripExpenseGiftFormView >> handleAdd [
    self serverAnnounce: TripExpenseGiftFormAddRequested
]

{ #category : 'event handling' }
TripExpenseGiftFormView >> handleCancel [
    self serverAnnounce: TripExpenseGiftFormHideRequested
]

{ #category : 'initialization' }
TripExpenseGiftFormView >> initializeShadowRoot [
    super initializeShadowRoot.
    (self shadowedElementWithId: #'btn-add')
        when: CpClickEvent basicPrimary send: #handleAdd to: self.
    (self shadowedElementWithId: #'btn-cancel')
        when: CpClickEvent basicPrimary send: #handleCancel to: self
]

{ #category : 'initialization' }
TripExpenseGiftFormView >> renderErrorMessage: aString [
    | banner |
    banner := self shadowedElementWithId: #'error-banner'.
    aString isEmpty
        ifTrue:  [ banner style: 'display:none'. banner textContent: '' ]
        ifFalse: [ banner style: 'display:block'. banner textContent: aString ]
]
