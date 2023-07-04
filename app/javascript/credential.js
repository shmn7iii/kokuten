import * as WebAuthnJSON from "@github/webauthn-json"
import {csrfToken} from '@rails/ujs'
import * as Flash from "flash";

function callback(callbackUrl, body, redirectUrl) {
    fetch(callbackUrl, {
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
            window.location.replace(redirectUrl)
        } else if (response.status < 500) {
            response.text().then(Flash.rewrite)
        } else {
            Flash.rewrite("Sorry, something wrong happened.");
        }
    });
}

function create(callbackUrl, credentialOptions, redirectUrl) {
    WebAuthnJSON.create({"publicKey": credentialOptions}).then(function (credential) {
        callback(callbackUrl, credential, redirectUrl);
    }).catch(function (error) {
        Flash.rewrite(error.message);
    });
}

function get(callbackUrl, credentialOptions, redirectUrl) {
    WebAuthnJSON.get({"publicKey": credentialOptions}).then(function (credential) {
        callback(callbackUrl, credential, redirectUrl);
    }).catch(function (error) {
        Flash.rewrite(error.message);
    });
}

export {create, get}
