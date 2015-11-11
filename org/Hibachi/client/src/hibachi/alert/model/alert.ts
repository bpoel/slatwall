/// <reference path='../../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />

//model
class Alert {
    msg:string;
    type:string;
    
    constructor(
        msg?: string,
        type?: string
    ) { 
        this.msg = msg;
        this.type = type;   
    }
} 
export = Alert;




