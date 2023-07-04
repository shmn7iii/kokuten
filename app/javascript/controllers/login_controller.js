import {Controller} from "stimulus"
import * as Credential from "credential";

export default class extends Controller {
    create(event) {
        const [data, status, xhr] = event.detail;
        const credentialOptions = data;
        const callback_url = encodeURI(`/login/callback`)
        const redirect_url = encodeURI(`/user`)

        Credential.get(callback_url, credentialOptions, redirect_url)
    }
}
