import {Controller} from "stimulus"
import * as Credential from "credential";

export default class extends Controller {
    create(event) {
        const [data, status, xhr] = event.detail;
        const credentialOptions = data;
        const callback_url = encodeURI('/signup/callback')
        const redirect_url = encodeURI('/user')

        Credential.create(callback_url, credentialOptions, redirect_url)
    }
}
