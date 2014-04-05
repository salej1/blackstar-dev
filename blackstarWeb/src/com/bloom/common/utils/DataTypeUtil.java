/**
 * 
 */
package com.bloom.common.utils;

import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.DateUtils;

/**
 * @author Oscar.Martinez
 *
 */
public class DataTypeUtil {
	
	
    public static String MIN_TIME = " 00:00:00";
    public static String MAX_TIME = " 23:59:59";

    /**
     * Método que regresa la fecha dada el parametro
     *
     * @param fecha a formatear
     * @return la fecha con el formato
     */
    public static String formatearFecha(Date fecha, String patron) {
        if (fecha == null) {
            return null;
        }
        try {
            SimpleDateFormat sdf = new SimpleDateFormat(patron);
            return sdf.format(fecha);
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Método que regresa la fecha dada como parámetro con el formato DD-MM-AAAA
     * HH:MM:ss
     *
     * @param fecha a formatear
     * @return la fecha con el formato DD-MM-AAAA
     */
    public static String formatearFechaDD_MM_AAAA_HH_MM_SS(Date fecha) {

        if (fecha == null) {
            return null;
        }
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
        try {
            return sdf.format(fecha);
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Método que regresa la fecha dada como parámetro con el formato DD-MM-AAAA
     *
     * @param fecha a formatear
     * @return la fecha con el formato DD-MM-AAAA
     */
    public static String formatearFechaDD_MM_AAAA(Date fecha) {
        if (fecha == null) {
            return null;
        }
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
        try {
            return sdf.format(fecha);
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Método que regresa la fecha dada como parámetro con el formato AAAA/MM/DD
     *
     * @param fecha a formatear
     * @return la fecha con el formato AAAA/MM/DD
     */
    public static String formatearFechaAAAA_MM_DD(Date fecha) {
        if (fecha == null) {
            return null;
        }
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
            return sdf.format(fecha);
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Método que convierte una fecha de tipo java.sql.Date al tipo
     * java.util.Date
     *
     * @param fechaSQL de tipo java.sql.Date
     * @return fecha de tipo java.util.Date
     */
    public static java.util.Date deFechaSQLaFechaUtil(java.sql.Date fechaSQL) {
        if (fechaSQL == null) {
            return null;
        }
        return new java.util.Date(fechaSQL.getTime());
    }

    /**
     * Método que convierte una fecha de tipo java.sql.Timestamp al tipo
     * java.util.Date
     *
     * @param fechaSQL de tipo java.sql.Date
     * @return fecha de tipo java.util.Date
     */
    public static java.util.Date deFechaSQLaFechaUtil(java.sql.Timestamp fechaSQL) {
        if (fechaSQL == null) {
            return null;
        }
        return new java.util.Date(fechaSQL.getTime());
    }

    /**
     * Método que cambia del formato de fecha DD-MM-AAAA al formato AAAA-MM-DD
     *
     * @param fecha a formatear
     * @return la fecha con el formato AAAA-MM-DD
     */
    public static String cambiarFormatoFecha_de_DD_MM_AAAA_a_AAAA_MM_DD(String fechaDDMMAAAA) {
        if (fechaDDMMAAAA == null) {
            return "";
        }
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
        try {
            sdf.parse(fechaDDMMAAAA);
            return fechaDDMMAAAA.substring(6, 10) + "-" + fechaDDMMAAAA.substring(3, 5)
                    + "-" + fechaDDMMAAAA.substring(0, 2);
        } catch (Exception e) {
            return fechaDDMMAAAA;
        }
    }

    
    /**
     * Método que obtiene un objeto fecha de una cadena con formato DD/MM/AAAA ó
     * DD-MM-AAAA
     *
     * @param fecha a formatear
     * @return fecha
     */
    public static Date obtenerFecha(String cadena,String patron) {
        if (cadena == null || cadena.trim().equals("")) {
            return null;
        }
        Date fecha;
        try {
            fecha = DateUtils.parseDate(cadena.trim(), patron);
            return fecha;
        } catch (Exception e) {
            return null;
        }
    }
    
    
    /**
     * Método que obtiene un objeto fecha de una cadena con formato DD/MM/AAAA ó
     * DD-MM-AAAA
     *
     * @param fecha a formatear
     * @return fecha
     */
    public static Date obtenerFechaDDMMAAAA(String cadena) {
        if (cadena == null || cadena.trim().equals("")) {
            return null;
        }
        Date fecha;
        try {
            fecha = DateUtils.parseDate(cadena.trim(), new String[]{"dd/MM/yyyy", "d/M/yyyy", "dd-MM-yyyy", "d-M-yyyy"});
            return fecha;
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Método que obtiene un objeto fecha de una cadena con formato DD/MM/AAAA ó
     * DD-MM-AAAA
     *
     * @param fecha a formatear
     * @return fecha
     */
    public static Date obtenerFechaAAAAMMDD(String cadena) {
        if (cadena == null || cadena.trim().equals("")) {
            return null;
        }
        Date fecha;
        try {
            fecha = DateUtils.parseDate(cadena.trim(), new String[]{"yyyy/MM/dd", "yyyy/M/d", "yyyy-MM-dd", "yyyy-MM-dd"});
            return fecha;
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Método que obtiene un objeto fecha de una cadena con formato DD/MM/AAAA
     * HH:MM:SS ó DD-MM-AAAA
     *
     * @param fecha a formatear
     * @return fecha
     */
    public static Date obtenerFechaAAAAMMDDHHMMSS(String cadena) {
        if (cadena == null || cadena.trim().equals("")) {
            return null;
        }
        Date fecha;
        try {
            fecha = DateUtils.parseDate(cadena.trim(), new String[]{"yyyy/MM/dd HH:mm:ss", "yyyy/M/d HH:mm:ss", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss"});
            return fecha;
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Método para formatear un número entero
     *
     * @param numero número a formatear
     * @return número formateado
     */
    public static String formatearNumEntero(long numero) {
        try {
            Locale loc = new Locale("es", "MX");
            NumberFormat nf = NumberFormat.getInstance(loc);
            return nf.format(numero);
        } catch (Exception e) {
            return String.valueOf(numero);
        }
    }

    /**
     * Agrega a la fecha el limite inferior de horas {@code 00:00:00}
     *
     * @param fecha la fecha a la que se ha de agregar el limite inferior.
     * @return la fecha con limite inferior.
     */
    public static final String agregarLimiteInferiorHoras(String fecha) {
        return agregarLimiteHoras(fecha, "00:00:00");
    }

    /**
     * Agrega a la fecha el limite superior de horas {@code 23:59:59}
     *
     * @param fecha la fecha a la que se ha de agregar el limite superior.
     * @return la fecha con limite superior.
     */
    public static final String agregarLimiteSuperiorHoras(String fecha) {
        return agregarLimiteHoras(fecha, "23:59:59");
    }

    /**
     * Agrega a la fecha el limite de horas indicado
     *
     * @param fecha la fecha a la que se ha de agregar el limite de horas.
     * @param limiteHoras el limite de horas que se ha de agregar.
     * @return la fecha con limite inferior.
     */
    public static final String agregarLimiteHoras(String fecha,
            String limiteHoras) {
        if (StringUtils.isBlank(limiteHoras)) {
            throw new IllegalArgumentException("Indicar el limite de horas");
        }
        if (StringUtils.isBlank(fecha)) {
            return StringUtils.EMPTY;
        }
        return String.format("%s %s", fecha.trim(), limiteHoras);
    }

    public static int getDiasCalculados(String fecha1, String fecha2) {
        int diasCita = 0;
        SimpleDateFormat formatoFecha = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        if (fecha1 == null) {
            Date hoy = new Date();
            fecha1 = formatoFecha.format(hoy);
        }
        diasCita = (int) getDiferenciaDias(fecha1, fecha2);
        return diasCita;
    }

    public static int getDiasCalculados(Date fecha1, Date fecha2) {
        int diasCita = 0;
        if (fecha1 == null) {
            Date hoy = new Date();
            fecha1 = hoy;
        }
        diasCita = (int) getDiferenciaDias(fecha1, fecha2);
        return diasCita;
    }

    public static long getDiferenciaDias(String fecha1, String fecha2) {
        SimpleDateFormat formatoFecha = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date f1 = null;
        Date f2 = null;
        try {
            if (fecha1 != null) {
                f1 = formatoFecha.parse(fecha1);
            }
            if (fecha2 != null) {
                f2 = formatoFecha.parse(fecha2);
            }
        } catch (Exception e) {
            throw new IllegalArgumentException("Error al convertir fechas", e);
        }
        return getDiferenciaDias(f1, f2);
    }

    /**
     * Retorna un Date a partir de un String.
     *
     * @param fecha
     * @param formatoFechaStr dd/MM/yyyy HH:mm:ss
     * @return
     */
    public static Date getFecha(String fecha, String formatoFechaStr) {
        SimpleDateFormat formatoFecha = new SimpleDateFormat(formatoFechaStr);
        Date fech = null;
        try {
            if (fecha != null) {
                fech = formatoFecha.parse(fecha);
            }
        } catch (Exception e) {
            throw new IllegalArgumentException("Error al convertir fechas", e);
        }
        return fech;
    }

    public static long getDiferenciaDias(Date f1, Date f2) {

        final long diff =
                Math.abs(DateUtils.truncate(f2.clone(), Calendar.DAY_OF_MONTH).
                getTime()
                - DateUtils.truncate(f1.clone(), Calendar.DAY_OF_MONTH).
                getTime());

        return diff / DateUtils.MILLIS_PER_DAY;
    }

    /**
     * Método para regresar el último día del mes en curso de la fecha enviada
     *
     * @param fecha fecha de la cual se desea obtener el ultimo dia del mes
     * @return fecha con el ultimo dia del mes
     */
    public static String getUltimoDiaDelMes(String fecha) {
        int anio = Integer.parseInt(fecha.substring(0, 4));
        int mes = (Integer.parseInt(fecha.substring(5, 7))) - 1;
        Calendar calendario = GregorianCalendar.getInstance();
        calendario.set(anio, mes, 1);
        fecha = fecha.substring(0, 8) + calendario.getActualMaximum(GregorianCalendar.DAY_OF_MONTH);
        return fecha;
    }

    /**
     * Método para restar un año a la fecha enviada
     *
     * @param fecha fecha a la cual se le requiere restar un año
     * @return año anterior de la fecha ingresada
     */
    public static String getFechaAnioAnterior(String fecha) {
        int anio = Integer.parseInt(fecha.substring(0, 4)) - 1;
        String fechaAnterior = Integer.toString(anio) + fecha.substring(4, 10);
        return fechaAnterior;
    }
	

}
