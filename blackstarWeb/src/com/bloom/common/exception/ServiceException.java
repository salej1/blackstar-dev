package com.bloom.common.exception;

/**
 * Clase que representa una excepción en la capa de service
 *
 * @author Cesar Perez(1.0.0)
 * @version 1.0.0, 20/09/2013
 */
public class ServiceException extends Exception {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String severidad;

    public ServiceException(String message) {
        super(message);
    }

    public ServiceException(String message, String severidad) {
        super(message);
        this.severidad = severidad;
    }

    public ServiceException(final String message, final Throwable e) {
        super(message, e);
    }

    /**
     * @return the severidad
     */
    public String getSeveridad() {
        return severidad;
    }

    /**
     * @param severidad the severidad to set
     */
    public void setSeveridad(String severidad) {
        this.severidad = severidad;
    }
}
