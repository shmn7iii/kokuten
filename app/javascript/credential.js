import * as WebAuthnJSON from "@github/webauthn-json"
import {csrfToken} from '@rails/ujs'

function callback(url, body) {
    fetch(url, {
        method: "POST",
        body: JSON.stringify(body),
        headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "X-CSRF-Token": csrfToken()
        },
        credentials: 'same-origin'
    }).then(function (response) {
        if (response.ok) {
            window.location.replace("/")
        } else if (response.status < 500) {
            console.log(response);

        } else {
            console.log(response);
            console.log("Sorry, something wrong happened.");
        }
    });
}

function create(callbackUrl, credentialOptions) {
    WebAuthnJSON.create({"publicKey": credentialOptions}).then(function (credential) {
        callback(callbackUrl, credential);
    }).catch(function (error) {
        console.log(error);
    });

    console.log("Creating new public key credential...");
}

function get(callbackUrl, credentialOptions) {
    WebAuthnJSON.get({"publicKey": credentialOptions}).then(function (credential) {
        callback(callbackUrl, credential);
    }).catch(function (error) {
        console.log(error);
    });

    console.log("Getting public key credential...");
}

export {create, get}
