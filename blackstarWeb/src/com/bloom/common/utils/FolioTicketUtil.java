/**
 * 
 */
package com.bloom.common.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * @author Oscar.Martinez
 *
 */
public class FolioTicketUtil {
	

    /**
     *
     * @param usuario
     * @return
     */
    public static String generarNumeroTickets(String prefijo,Date tiempoActual) {

        StringBuilder folio = new StringBuilder();

        SimpleDateFormat sdf = new SimpleDateFormat("ddMMyyHHmmss");

        folio.append(prefijo);

        String sdfTiempo = sdf.format(tiempoActual);

        folio.append(sdfTiempo);

        return folio.toString();
    }	
	

}
