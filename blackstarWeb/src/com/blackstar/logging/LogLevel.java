package com.blackstar.logging;

public enum LogLevel {
	Emergency, 	// El sistema entero es inoperable 
	Critical,	// Un componente del sistema no es operable
	Fatal,		// No se puede entregar al usuario su solicitud
	Error,		// Error o situacion inesperada
	Info,		// Informacion de rastreo
	Debug		// Informacion muy detallada (solo para desarrollo)
}
