//Function for password hide and unhide
var fields = document.querySelectorAll(".login-form input");
var btn = document.querySelector('#btn')

/*Check fields. if both empty, button is disabled. if both filled, button is enabled.*/
function check(){
    if(fields[0].value.length == 0 || fields[1].value.length == 0)
        btn.classList.add("disabled");
    else
        btn.classList.remove("disabled");  
    }

fields[0].addEventListener("keyup",check); // Add event listeners to both fields to detect when user release a key. //
fields[1].addEventListener("keyup",check); //                                                                       //

/*Hide and Show password*/
document.querySelector(".show-password").addEventListener("click", function(){
if(this.classList[2] == "fa-eye-slash"){

    this.classList.remove("fa-eye-slash");
    this.classList.add("fa-eye");
    fields[1].type = "text";

}else{

    this.classList.remove("fa-eye");
    this.classList.add("fa-eye-slash");
    fields[1].type = "password";
    }
});

