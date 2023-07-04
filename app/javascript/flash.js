// JavaScript から flash を書き換えたい

function rewrite(message) {
    document.getElementById('flash').innerHTML =
        `<div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative" role="alert">
            ${message}
        </div>`

}

export {rewrite}
