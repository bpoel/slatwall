/*

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component displayname="Product" entityname="SlatwallProduct" table="SlatwallProduct" persistent="true" extends="slatwall.com.entity.baseEntity" {
	
	// Persistant Properties
	property name="productID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="active" ormtype="boolean" default="true" displayname="Active" hint="As Products Get Old, They would be marked as Not Active";
	property name="filename" ormtype="string" default="" displayname="File Name" hint="This is the name that is used in the URL string";
	property name="template" ormtype="string" default="" displayname="Design Template" hint="This is the Template to use for product display";
	property name="productName" ormtype="string" default="" displayname="Product Name" validateRequired="Product Name Is Required" hint="Primary Notation for the Product to be Called By";
	property name="productCode" ormtype="string" default="" displayname="Product Code" validateRequired="Product Code Is Required" hint="Product Code, Typically used for Manufacturer Coded";
	property name="productDescription" ormtype="string" default="" displayname="Product Description" hint="HTML Formated description of the Product";
	property name="productYear" ormtype="int" displayname="Product Year" hint="Products specific model year if it has one";
	property name="manufactureDiscontinued"	ormtype="boolean" default=false persistent=true displayname="Manufacture Discounted" hint="This property can determine if a product can still be ordered by a vendor or not";
	property name="showOnWeb" ormtype="boolean" default=false displayname="Show On Web Retail" hint="Should this product be sold on the web retail Site";
	property name="showOnWebWholesale" ormtype="boolean" default=false persistent=true displayname="Show On Web Wholesale" hint="Should this product be sold on the web wholesale Site";
	property name="trackInventory" ormtype="boolean" default=false displayname="Non-Inventory Item";
	property name="callToOrder" ormtype="boolean" default=false displayname="Call To Order";
	property name="allowShipping" ormtype="boolean" default=true displayname="Allow Shipping";
	property name="allowPreorder" ormtype="boolean" default=true displayname="Allow Pre-Orders" hint="";
	property name="allowBackorder" ormtype="boolean" default=false displayname="Allow Backorders";
	property name="allowDropship" ormtype="boolean" default="false" displayname="Allow Dropship";
	property name="shippingWeight" ormtype="float" default="0" hint="This Weight is used to calculate shipping charges, gets overridden by sku Shipping Weight";
	property name="publishedWeight" ormtype="float" default="0" hint="This Weight is used for display purposes on the website, gets overridden by sku Published Weight";
	property name="createdDateTime" ormtype="date" default="" displayname="Date Create";
	property name="lastUpdatedDateTime"	ormtype="date" default="" displayname="Date Last Updated";
	
	// Related Object Properties
	property name="brand" displayname="Brand" cfc="Brand" fieldtype="many-to-one" fkcolumn="brandID";
	property name="skus" type="array" cfc="sku" singularname="SKU" fieldtype="one-to-many" fkcolumn="productID" cascade="all" inverse=true;
	property name="productType" validateRequired displayname="Product Type" cfc="ProductType" fieldtype="many-to-one" fkcolumn="productTypeID";
	property name="genderType" cfc="Type" fieldtype="many-to-one" fkcolumn="typeID" cascade="all" inverse=true;
	property name="madeInCountry" cfc="Country" fieldtype="many-to-one" fkcolumn="countryCode";
	property name="productContent" cfc="ProductContent" fieldtype="one-to-many" fkcolumn="productID" cascade="all";
	
	// Non-Persistant Properties
	property name="gender" type="string" persistent="false";
	property name="title" type="string" persistent="false";
	property name="defaultSku" persistent="false";
	property name="onTermSale" type="boolean" persistent="false";
	property name="onClearanceSale" type="boolean" persistent="false";
	property name="dateFirstReceived" type="date" persistent="false";
	property name="dateLastReceived" type="date" persistent="false";
	property name="livePrice" type="numeric" persistent="false";
	property name="price" type="numeric" validateRequired validateNumeric persistent="false";
	property name="listPrice" type="numeric" validateRequired validateNumeric persistent="false";
	property name="qoh" type="numeric" persistent="false";
	property name="qc" type="numeric" persistent="false";
	property name="qexp" type="numeric" persistent="false";
	
	public Product function init(){
	   // set default collections for association management methods
	   if(isNull(variables.ProductContent)) {
	       variables.ProductContent = [];
	   }
	   if(isNull(variables.Skus)) {
	       variables.Skus = [];
	   }
	   return Super.init();
	}

	// Related Object Helpers
	
	public string function getBrandName() {
		if( structKeyExists(variables,"brand") ) {
			return getBrand().getBrandName();
		}
		else {	
			return "";
		}
	}
	
	public any function getBrandOptions() {
		if(!isDefined("variables.brandOptions")) {
			var smartList = new Slatwall.com.utility.SmartList(entityName="SlatwallBrand");
			smartList.addSelect(rawProperty="brandName", aliase="name");
			smartList.addSelect(rawProperty="brandID", aliase="id"); 
			smartList.addOrder("brandName|ASC");
			variables.brandOptions = smartList.getRecords();
		}
		return variables.brandOptions;
	}
	
    public any function getProductTypeOptions() {
        if(!structKeyExists(variables,"propertyTypeOptions")) {
            var smartList = new Slatwall.com.utility.SmartList(entityName="SlatwallProductType");
            smartList.addSelect(rawProperty="productType", aliase="name");
            smartList.addSelect(rawProperty="productTypeID", aliase="id");
			smartList.addOrder("productType|ASC");
            variables.propertyTypeOptions = smartList.getRecords();
        }
        return variables.propertyTypeOptions;
    }
    
    public any function getProductTypeTree() {
        return getService("ProductService").getProductTypeTree();
    }
    	
	
	public array function getSkus() {
		if(!structKeyExists(variables, "skus")) {
			variables.skus = arrayNew(1);
		}
		return variables.skus;
	}
	
	public any function getSkuByID(required string skuID) {
		var skus = getSkus();
		for(var i = 1; i <= arrayLen(skus); i++) {
			if(skus[i].getSkuID() == arguments.skuID) {
				return skus[i];
			}
		}
	}
	
	public any function getGenderType() {
		if(!isDefined("variables.genderType")) {
			variables.genderType = getService(service="TypeService").getNewEntity(); //get New Entity here should have a parent programing type ID set in the future.
		}
		return variables.genderType;
	}
	
	public any function getTemplateOptions() {
		if(!isDefined("variables.templateOptions")){
			variables.templateOptions = getService(service="ProductService").getProductTemplates();
		}
		return variables.templateOptions;
	}
	
	// Non-Persistant Helpers
	
	public string function getContentIDs() { 
		var contentIDs = "";
		for( var i=1; i<= arrayLen(getProductContent()); i++ ) {
			contentIDs = listAppend(contentIDs,getProductContent()[i].getContentID());
		}
		return contentIDs;
	}
	
	public string function getGender() {
		if(!isDefined("variables.gender")) {
			variables.gender = getGenderType().getType();
		}
		return variables.gender;
	}
	
	public string function getTitle() {
		return "#getBrandName()# #getProductYear()# #getProductName()#";
	}
	
	public string function getProductURL() {
		return getMuraScope().createHREF(filename="#setting('product_urlKey')#/#getFilename()#");
	}
	
	public numeric function getQIA() {
		return getQOH() - getQC();
	}
	
	public string function getTemplate() {
		if(!structKeyExists(variables, "template") || variables.template == "") {
			return setting('product_defaultTemplate');
		} else {
			return variables.template;
		}
	}
	
	/******* Generic setting accessor **************/
	
	public boolean function getSetting( required string settingName ) {
		if(structKeyExists(variables,arguments.settingName)) {
			return variables[arguments.settingName];
		} else {
			var settingValue = getService("ProductService").getProductTypeSetting( getProductType().getProductTypeName(),arguments.settingName );
			if(len(settingValue) > 0) {
				return settingValue;
			} else {
				return setting("product_#arguments.settingName#");
			}
		}
		
	}
	
	
	/***************************************************/
	

	/******* Association management methods for bidirectional relationships **************/
	
	// Product Type (many-to-one)
	
	public void function setProductType(required ProductType ProductType) {
	   variables.productType = arguments.ProductType;
	   if(isNew() or !arguments.ProductType.hasProduct(this)) {
	       arrayAppend(arguments.ProductType.getProducts(),this);
	   }
	}
	
	public void function removeProductType(required ProductType ProductType) {
       var index = arrayFind(arguments.ProductType.getProducts(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.ProductType.getProducts(),index);
       }    
       structDelete(variables,"productType");
    }
    
    // Brand (many-to-one)
	
	public void function setBrand(required Brand Brand) {
	   variables.Brand = arguments.Brand;
	   if(isNew() or !arguments.Brand.hasProduct(this)) {
	       arrayAppend(arguments.Brand.getProducts(),this);
	   }
	}
	
	public void function removeBrand(required Brand Brand) {
       var index = arrayFind(arguments.Brand.getProducts(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.Brand.getProducts(),index);
       }    
       structDelete(variables,"Brand");
    }
	
	// ProductContent (one-to-many)
	
	public void function setProductContent(required array ProductContent) {
		if( !arrayIsEmpty(arguments.ProductContent) ) {
			for( var i=1; i<= arraylen(arguments.ProductContent); i++ ) {
				var thisProductContent = arguments.ProductContent[i];
				if(isObject(thisProductContent) && thisProductContent.getClassName() == "SlatwallProductContent") {
					addProductContent(thisProductContent);
				}
			}
		} 
	}
	
	public void function clearProductContent() {
		for( var i=1; i<= arraylen(getProductContent()); i++ ) {
			removeProductContent(getProductContent()[i]);
		}
	}
	
	public void function addProductContent(required ProductContent ProductContent) {
	   arguments.ProductContent.setProduct(this);
	}
	
	public void function removeProductContent(required ProductContent ProductContent) {
	   arguments.ProductContent.removeProduct(this);
	}
	
	// Skus (one-to-many)
	
	public void function setSkus(required array Skus) {
		// first, clear existing collection
		variables.Skus = [];
		for( var i=1; i<= arraylen(arguments.Skus); i++ ) {
			var thisSku = arguments.Skus[i];
			if(isObject(thisSku) && thisSku.getClassName() == "SlatwallSku") {
				addSku(thisSku);
			}
		}
	}
	
	public void function addSku(required any Sku) {
	   arguments.Sku.setProduct(this);
	}
	
	public void function removeSku(required any Sku) {
	   arguments.Sku.removeProduct(this);
	}
	
	/************   END Association Management Methods   *******************/

	public struct function getOptionGroupsStruct() {
		if(isNull(variables.optionGroups)) {
			variables.optionGroups = structNew();
			var skus = getSkus();
			for(var i=1; i <= arrayLen(skus); i++){
				var options = skus[i].getOptions();
				for(var ii=1; ii <= arrayLen(options); ii++) {
					if( !structKeyExists( variables.optionGroups, options[ii].getOptionGroup().getOptionGroupID() ) ){
						variables.optionGroups[options[ii].getOptionGroup().getOptionGroupID()] = options[ii].getOptionGroup();
					}
				}
			}
		}
		return variables.optionGroups;
	}
	
	public any function getDefaultSku() {
		if( !structKeyExists(variables, "defaultSku")) {
			var skus = getSkus();
			for(var i = 1; i<= arrayLen(skus); i++) {
				if(skus[i].getIsDefault()) {
					variables.defaultSku = skus[i];
				}
			}
			if( !isNew() && !structKeyExists(variables, "defaultSku") && arrayLen(skus) > 0) {
				skus[1].setIsDefault(true);
				getService("skuService").save(entity=skus[1]);
				variables.defaultSku = skus[1];
			} else if ( !structKeyExists(variables, "defaultSku") ) {
				variables.defaultSku = getService("skuService").getNewEntity();
			}
		}
		return variables.defaultSku;
	}
	
	// Start: Functions that deligate to the default sku
	public string function getImage(string size, numeric width, numeric height, string class) {
		return getDefaultSku().getImage(argumentCollection = arguments);
	}
	
	public string function getImagePath() {
		return getDefaultSku().getImagePath();
	}
	
	public numeric function getPrice() {
		return getDefaultSku().getPrice();
	}
	
	public numeric function getListPrice() {
		return getDefaultSku().getListPrice();
	}
	
	public numeric function getLivePrice() {
		return getDefaultSku().getLivePrice();
	}
	
	// Start Functions for determining different option combinations
	public array function getAvaiableSkusBySelectedOptions(required string selectedOptions) {
		var availableSkus = arrayNew(1);
		var skus = getSkus();
		
		for(var i = 1; i<=arrayLen(skus); i++) {
			var skuOptions = skus[i].getOptions();
			var matchCount = 0;
			for(var ii = 1; ii <= arrayLen(skuOptions); ii++) {
				var option = skuOptions[ii];
				for(var iii = 1; iii <= listLen(arguments.selectedOptions); iii++) {
					if(option.getOptionID() == listGetAt(arguments.selectedOptions, iii)) {
						matchCount += 1;
					}
				}
			}
			if(matchCount == listLen(arguments.selectedOptions)) {
				arrayAppend(availableSkus, skus[i]);
			}
		}
		return availableSkus;
	}
	
	public struct function getAvailableOptionsBySelectedOptions(required string selectedOptions) {
		var availableGroupOptions = structNew();
		var availableSkus = getAvaiableSkusBySelectedOptions(arguments.selectedOptions);
		for(var i = 1; i<=arrayLen(availableSkus); i++) {
			var options = availableSkus[i].getOptions();
			for(var ii = 1; ii <= arrayLen(options); ii++) {
				if(!listFind(arguments.selectedOptions, options[ii].getOptionID())) {
					if(!structKeyExists(availableGroupOptions, options[ii].getOptionGroup().getOptionGroupID())) {
						availableGroupOptions[options[ii].getOptionGroup().getOptionGroupID()] = structNew();
					}
					if(!structKeyExists(availableGroupOptions[options[ii].getOptionGroup().getOptionGroupID()], options[ii].getOptionID())){
						availableGroupOptions[options[ii].getOptionGroup().getOptionGroupID()][options[ii].getOptionID()] = options[ii];
					}
				}
			}	
		}
		return availableGroupOptions;
	}
	
	public struct function getAvailableGroupOptionsBySelectedOptions(required string optionGroupID, string selectedOptions="") {
		var availableGroupOptions = getAvailableOptionsBySelectedOptions(arguments.selectedOptions);
		if(structKeyExists(availableGroupOptions, arguments.optionGroupID)) {
			return availableGroupOptions[arguments.optionGroupID];
		} else {
			return structNew();
		}
	}
	// End Functions for determining different option combinations
	
	public any function getSkuBySelectedOptions(string selectedOptions="") {
		var availableSkus = getAvaiableSkusBySelectedOptions(arguments.selectedOptions);
		if(arrayLen(availableSkus) == 1) {
			return availableSkus[1];
		} else {
			return availableSkus;
		}
	}
}


