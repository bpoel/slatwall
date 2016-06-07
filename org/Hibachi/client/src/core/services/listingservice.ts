/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class ListingService{
    
    private listingDisplays = {};
    
    //@ngInject
    constructor(private utilityService){}
    
    public setListingState = (listingID, state) =>{
        this.listingDisplays[listingID] = state; 
    }
    
     //this has moved into a service
    public getKeyOfMatchedExpandableRule = (listingID, pageRecord)=>{
        var expandableRuleMatchedKey = -1; 
        if(angular.isDefined(this.listingDisplays[listingID].expandableRules)){
            angular.forEach(this.listingDisplays[listingID].expandableRules, (rule, key)=>{
                if(angular.isDefined(pageRecord[rule.filterPropertyIdentifier])){
                    if(angular.isString(pageRecord[rule.filterPropertyIdentifier])){
                        var pageRecordValue = pageRecord[rule.filterPropertyIdentifier].trim(); 
                    } else {
                        var pageRecordValue = pageRecord[rule.filterPropertyIdentifier]; 
                    }
                    switch (rule.filterComparisonOperator){
                        case "!=":
                            if(pageRecordValue != rule.filterComparisonValue){
                                expandableRuleMatchedKey = key; 
                            }
                            break; 
                        case ">":
                            if(pageRecordValue > rule.filterComparisonValue){
                                expandableRuleMatchedKey = key; 
                            }
                            break;
                        case ">=":  
                            if(pageRecordValue >= rule.filterComparisonValue){
                                expandableRuleMatchedKey = key; 
                            }
                            break;
                        case "<":
                            if(pageRecordValue < rule.filterComparisonValue){
                                expandableRuleMatchedKey = key; 
                            }
                            break; 
                        case "<=":
                            if(pageRecordValue <= rule.filterComparisonValue){
                                expandableRuleMatchedKey = key; 
                            }
                            break; 
                        default: 
                            //= case
                            if(pageRecordValue == rule.filterComparisonValue){
                                expandableRuleMatchedKey = key; 
                            }
                            break; 
                    }
                    if(expandableRuleMatchedKey != -1){
                        return expandableRuleMatchedKey;
                    }
                }
            }); 
        }  
        return expandableRuleMatchedKey;
    }
    
    //this has moved into a service
    public getPageRecordMatchesExpandableRule = (listingID, pageRecord)=>{
        var keyOfExpandableRuleMet = this.getKeyOfMatchedExpandableRule(listingID, pageRecord); 
        return keyOfExpandableRuleMet != -1;  
    }
    
    //this has moved into a service
    public getPageRecordChildCollectionConfigForExpandableRule = (listingID, pageRecord) => {
        var keyOfExpandableRuleMet = this.getKeyOfMatchedExpandableRule(listingID, pageRecord); 
        if(angular.isDefined(pageRecord[this.listingDisplays[listingID].exampleEntity.$$getIDName()]) 
            && angular.isDefined(this.listingDisplays[listingID].childCollectionConfigs[pageRecord[this.listingDisplays[listingID].exampleEntity.$$getIDName()]])
        ){
            return this.listingDisplays[listingID].childCollectionConfigs[pageRecord[this.listingDisplays[listingID].exampleEntity.$$getIDName()]];
        }
        if(keyOfExpandableRuleMet != -1){
           var childCollectionConfig = this.listingDisplays[listingID].expandableRules[keyOfExpandableRuleMet].childrenCollectionConfig.clone();
           angular.forEach(childCollectionConfig.filterGroups[0], (filterGroup, key)=>{ 
                angular.forEach(filterGroup, (filter,key)=>{
                    if(angular.isString(filter.value) 
                        && filter.value.length 
                        && filter.value.charAt(0) == '$'
                    ){
                        filter.value = this.utilityService.replaceStringWithProperties(filter.value, pageRecord); 
                    }    
                });
           }); 
           this.listingDisplays[listingID].childCollectionConfigs[pageRecord[this.listingDisplays[listingID].exampleEntity.$$getIDName()]] = childCollectionConfig; 
           return this.listingDisplays[listingID].childCollectionConfigs[pageRecord[this.listingDisplays[listingID].exampleEntity.$$getIDName()]];
        } 
    }    
}
export{ListingService};
