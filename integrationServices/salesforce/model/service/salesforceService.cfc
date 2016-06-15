/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
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
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

*/
component extends="Slatwall.model.service.HibachiService" persistent="false" accessors="true" output="false" {

	property name="settingService" type="any";
	
	
	// ===================== START: Logical Methods ===========================
	
	public any function something(){
		
		var httpRequest = new http();
        httpRequest.setMethod("POST");
		httpRequest.setPort("443");
		httpRequest.setTimeout(45);
		httpRequest.setUrl("");
		httpRequest.setResolveurl(false);
//		if(arguments.format == 'xml'){
//			httpRequest.addParam(type="XML", name="name",value=trim(arguments.requestPacket));
//			return XmlParse(REReplace(httpRequest.send().getPrefix().fileContent, "^[^<]*", "", "one"));
//		}else{
			httpRequest.addParam(type="header",name="Content-Type",value="application/json");
//			httpRequest.addParam(type="body", value=trim(arguments.requestPacket));
//			return deserializeJson(httpRequest.send().getPrefix().fileContent);
//		}

		
		
		initParams = { 
		    @WebInitParam(name = "clientId", value = 
		            "3MVG9lKcPoNINVBJSoQsNCD.HHDdbugPsNXwwyFbgb47KWa_PTv"),
		    @WebInitParam(name = "clientSecret", value = "5678471853609579508"),
		    @WebInitParam(name = "redirectUri", value = 
		            "https://localhost:8443/RestTest/oauth/_callback"),
		    @WebInitParam(name = "environment", value = 
		            "https://***yourInstance***.salesforce.com/services/oauth2/token")  }
		 
		HttpClient httpclient = new HttpClient();
		PostMethod post = new PostMethod(environment);
		post.addParameter("code",code);
		post.addParameter("grant_type","authorization_code");
		
		   /** For session ID instead of OAuth 2.0, use "grant_type", "password" **/
		post.addParameter("client_id",clientId);
		post.addParameter("client_secret",clientSecret);
		post.addParameter("redirect_uri",redirectUri);
	}
	
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
}
