package com.blackstar.logging;

public enum LogLevel {
	EMERGENCY, 	// El sistema entero es inoperable 
	CRITICAL,	// Un componente del sistema no es operable
	FATAL,		// No se puede entregar al usuario su solicitud
	ERROR,		// Error o Excepcion cachada
	WARNING, 	// Situacion inesperada
	INFO,		// Informacion de rastreo
	DEBUG		// Informacion muy detallada (solo para desarrollo)
}
