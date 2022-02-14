const current_date = document.getElementById("current_date")
const lesson_type = document.getElementById("lessons_type")


current_date.value = new Date().toISOString().substring(0, 10);
current_date.min = new Date().toISOString().substring(0, 10);


// function handler(){
//     alert(current_date.value);
// }

// lesson_type.onselect(function change_lesson_type(){
//     const selected_type = lesson_type.value
//     alert(selected_type)
// })