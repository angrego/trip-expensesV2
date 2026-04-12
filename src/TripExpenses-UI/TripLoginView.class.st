Class {
	#name : 'TripLoginView',
	#superclass : 'CpView',
	#category : 'TripExpenses-UI-Login',
	#package : 'TripExpenses-UI',
	#tag : 'Login'
}

{ #category : 'web resources' }
TripLoginView class >> style [
    <webResource: #css>
    ^ '
    :host { display: flex; justify-content: center; align-items: center; min-height: 100vh; font-family: sans-serif; }
    .login-card { border: 1px solid #e0e0e0; border-radius: 16px; padding: 2rem; width: 320px; }
    .login-title { font-size: 1.5rem; font-weight: 600; color: #5046e4; margin-bottom: 1.5rem; text-align: center; }
    .input { display: block; width: 100%; box-sizing: border-box; border: 1px solid #ccc; border-radius: 8px; padding: .5rem; margin: .25rem 0 1rem; font-size: 1rem; }
    .btn-primary { display: block; width: 100%; background: #5046e4; color: #fff; border: none; border-radius: 8px; padding: .75rem; cursor: pointer; font-size: 1rem; }
    .error-banner { background: #fee; border: 1px solid #f99; border-radius: 8px; padding: .75rem; margin-bottom: 1rem; color: #900; }
    '
]

{ #category : 'web resources' }
TripLoginView class >> template [
    <webResource: #html>
    ^ '
    <div class="login-card">
        <div class="login-title">✈ Mes Voyages</div>
        <div id="error-banner" class="error-banner" style="display:none"></div>
        <label>Nom</label>
        <input id="participant-name" class="input" type="text" placeholder="Votre nom">
        <label>Mot de passe</label>
        <input id="password" class="input" type="password" placeholder="Mot de passe">
        <button id="btn-login" class="btn-primary">Se connecter</button>
    </div>
    '
]

{ #category : 'rendering' }
TripLoginView >> handleLogin [
    | name password |
    name     := (self shadowedElementWithId: #'participant-name') propertyAt: 'value'.
    password := (self shadowedElementWithId: #'password') propertyAt: 'value'.
    self serverAnnounce: (TripLoginRequested
        participantName: name
        password: password)
]

{ #category : 'rendering' }
TripLoginView >> initializeShadowRoot [
    super initializeShadowRoot.
    (self shadowedElementWithId: #'btn-login')
        when: CpClickEvent basicPrimary
        send: #handleLogin
        to: self
]

{ #category : 'rendering' }
TripLoginView >> renderErrorMessage: aString [
    | banner |
    banner := self shadowedElementWithId: #'error-banner'.
    aString isEmpty
        ifTrue:  [ banner style: 'display:none'. banner textContent: '' ]
        ifFalse: [ banner style: 'display:block'. banner textContent: aString ]
]
