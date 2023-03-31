function fromMs(ms) {
    var s=ms%60000;
    var m=parseInt((ms-s)/60000).toString();
    s=parseInt(s/1000).toString();
    if(m.length<2)m="0"+m;
    if(s.length<2)s="0"+s;
    return m+":"+s;
}
