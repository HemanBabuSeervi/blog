blogs=document.getElementsByClassName("day");
function random256(){
    return Math.floor(256*Math.random());
}
for(i=0; i<blogs.length; i++){
    console.log(random256());
    blogs[i].style.borderLeft="3px solid rgb("+random256()+","+random256()+","+random256()+")";
}
