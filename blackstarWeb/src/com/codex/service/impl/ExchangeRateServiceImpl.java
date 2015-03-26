package com.codex.service.impl;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;

import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.services.AbstractService;
import com.codex.service.ExchangeRateService;

public class ExchangeRateServiceImpl extends AbstractService implements ExchangeRateService{
	private String exchangeProviderUrl;
	private String exchangeProviderKey;

	public void setExchangeProviderUrl(String exchangeProviderUrl) {
		this.exchangeProviderUrl = exchangeProviderUrl;
	}
	
	public void setExchangeProviderKey(String exchangeProviderKey) {
		this.exchangeProviderKey = exchangeProviderKey;
	}

	/* El servicio de exchange rate regresa un objeto json como el siguiente:
	 * 
			{
			  "disclaimer": "Exchange rates are provided for informational purposes only, and do not constitute financial advice of any kind. Although every attempt is made to ensure quality, NO guarantees are given whatsoever of accuracy, validity, availability, or fitness for any purpose - please use at your own risk. All usage is subject to your acceptance of the Terms and Conditions of Service, available at: https://openexchangerates.org/terms/",
			  "license": "Data sourced from various providers with public-facing APIs; copyright may apply; resale is prohibited; no warranties given of any kind. Bitcoin data provided by http://coindesk.com. All usage is subject to your acceptance of the License Agreement available at: https://openexchangerates.org/license/",
			  "timestamp": 1407963655,
			  "base": "USD",
			  "rates": {
			    "AED": 3.673134,
			    "AFN": 56.19725,
			    ...
			    "MXN": 13.13683,
			    ...
			  }
			}
	 * 
	 * */
	
	@Override
	public Float getExchangeRate() {
		URL url;
		Float retval = 0f;
		
		try {
			url = new URL(exchangeProviderUrl + "?" + exchangeProviderKey);

			BufferedReader reader = new BufferedReader(new InputStreamReader(url.openStream()));
			String line;

			while ((line = reader.readLine()) != null) {
				if(line.indexOf("MXN") > 0){
					String rawXr;
					int start = line.indexOf(':') + 2;
					if(start > 0){
						rawXr = line.substring(start, start + 5);
						try{
							retval = Float.parseFloat(rawXr);
						}
						catch(Exception e){
							Logger.Log(LogLevel.ERROR,
									e.getStackTrace()[0].toString(), e);
						}
					}
					break;
				}
				else{
					continue;
				}
			}

			reader.close();
			
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
		}
		
		return retval;
	}
}
