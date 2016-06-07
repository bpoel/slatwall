/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWModalWindowController {

    public modalName;
    public title; 
    public saveAction;

    // @ngInject
    constructor(){
        if(angular.isUndefined(this.modalName)){
            console.warn("You did not pass a modal title to SWModalWindowController");
            this.modalName = ""; 
        }
    }

}

class SWModalWindow implements ng.IDirective{

    public templateUrl;
    public transclude={
        modalBody:"?swModalBody"
    }; 
    public restrict = "EA";
    public scope = {};

    public bindToController = {
        modalName:"@",
        title:"@",
        saveAction:"&?"
    };
    public controller=SWModalWindowController;
    public controllerAs="swModalWindow";

    // @ngInject
    constructor(public $compile, private corePartialsPath,hibachiPathBuilder){
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "modalwindow.html";
    }

    public compile = (element: JQuery, attrs: angular.IAttributes, transclude: any) => {
        return {
            pre: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {      
            },
            post: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
            }
        };
    }

    public static Factory(){
        var directive:ng.IDirectiveFactory = (
            $compile
            ,corePartialsPath
            ,hibachiPathBuilder

        )=> new SWModalWindow(
            $compile
            ,corePartialsPath
            ,hibachiPathBuilder
        );
        directive.$inject = ["$compile","corePartialsPath",
            'hibachiPathBuilder'];
        return directive;
    }
}
export{
    SWModalWindow,
    SWModalWindowController
}