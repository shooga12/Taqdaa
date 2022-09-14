export const emptyImage = (img)=>{
    if(img.length == 0)
      return true;
    return false;
}
export const validName = (name)=>{
    return /^[A-Za-z]{1,30}$/.test(name);
}
export const validEmail = (email)=>{
    var pattern =  /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/;
    return pattern.test(email);
}
export const validPhone = (phone)=> {
    return /[0-9]{10}/.test(phone);
}