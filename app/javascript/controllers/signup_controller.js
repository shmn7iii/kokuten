import {Controller} from "stimulus"
import * as Credential from "credential";

export default class extends Controller {
    create(event) {
        const [data, status, xhr] = event.detail;
        const credentialOptions = data;
        const callback_url = encodeURI('/signup/callback')

        Credential.create(callback_url, credentialOptions)
    }
}
