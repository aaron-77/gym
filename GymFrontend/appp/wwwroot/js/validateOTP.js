const $inputOTPCode = null;
$form = null;

document.addEventListener("DOMContentLoaded", () => {
    $inputOTPCode = document.getElementById("inputOTP");
    $form = document.getElementById("formCheckOTP");
    form.addEventListener("submit", (e) => {
        e.preventDefault();
        fetch()
    })
    

})