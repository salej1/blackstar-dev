package com.blackstar.services;

import com.blackstar.interfaces.*;

public class UserServiceFactory {
	public static IUserService getUserService(){
		// TODO: usar dependency injection para regresar ya sea el servicio de usuarios de google o un mock
		return new GoogleUserService();
	}
}
