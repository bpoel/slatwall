/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSkuPriceQuantityEditController{
    
    public skuPriceId;
    public skuPrice; 
    public column; 
    public columnPropertyIdentifier; 
    
    
    //@ngInject
    constructor(
        private $hibachi
    ){
        
        if(angular.isUndefined(this.skuPrice)){
            this.$hibachi.getEntity("SkuPrice", this.skuPriceId).then(
                (skuPrice)=>{
                    if(angular.isDefined(skuPrice)){
                        this.skuPrice = this.$hibachi.newEntity('SkuPrice');
                        angular.extend(this.skuPrice.data, skuPrice);
                    } else { 
                        throw("There was a problem fetching the sku in SWSkuPriceSingleEditController");
                    }
                },
                (reason)=>{
                    throw("SWSkuPriceQuantityEdit had trouble fetchin its sku because" + reason);
                }
           ); 
        }
    }    

}

class SWSkuPriceQuantityEdit implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
        skuPrice:"=?",
        skuPriceId:"@",
        column:"=?",
        columnPropertyIdentifier:"@"
    };
    public controller = SWSkuPriceQuantityEditController;
    public controllerAs="swSkuPriceQuantityEdit";
   
   
    public static Factory(){
        var directive = (
            skuPartialsPath,
			slatwallPathBuilder
        )=> new SWSkuPriceQuantityEdit(
            skuPartialsPath,
			slatwallPathBuilder
        );
        directive.$inject = [
            'skuPartialsPath',
			'slatwallPathBuilder'
        ];
        return directive;
    }
    constructor(
		skuPartialsPath,
	    slatwallPathBuilder
    ){
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath)+"skupricequantityedit.html";
    }
}
export{
    SWSkuPriceQuantityEdit,
    SWSkuPriceQuantityEditController
}