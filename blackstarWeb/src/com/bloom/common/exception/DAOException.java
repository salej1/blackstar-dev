/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.bloom.common.exception;

/**
 * Excepci&oacute;n de Acceso a Datos.
 * @author oscar.martinez
 */
public class DAOException extends RuntimeException {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public DAOException() {
        super();
    }

    public DAOException(String message) {
        super(message);
    }

    public DAOException(String message, Throwable cause) {
        super(message, cause);
    }

    public DAOException(Throwable cause) {
        super(cause);
    }
}
