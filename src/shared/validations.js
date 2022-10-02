export const emptyImage = (img)=>{
    if(img.length == 0)
      return true;
    return false;
}
export const noSpace = (name)=>{
    for(var i =0; i<name.length; i++){
        if(name[i] = ' ')
          return false;
    }
    return true;
}
export const validName = (name)=>{
    return /^[A-Za-z]{1,30}$/.test(name);
}
export const validNameWithDigits = (name)=>{
    return /^[A-Za-z0-9& ]{1,30}$/.test(name);
}
export const validEmail = (email)=>{
   return /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/.test(email)
}
export const validPhone = (phone)=> {
    return /[0-9]{10}/.test(phone);
}