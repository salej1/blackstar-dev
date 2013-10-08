package com.blackstar.logging;

public enum LogLevel {
	DEBUG,		// Informacion muy detallada (solo para desarrollo)
	INFO,		// Informacion de rastreo
	WARNING, 	// Situacion inesperada
	ERROR,		// Error o Excepcion cachada
	FATAL,		// No se puede entregar al usuario su solicitud
	CRITICAL,	// Un componente del sistema no es operable
	EMERGENCY 	// El sistema entero es inoperable 
}
