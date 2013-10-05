package com.blackstar.services;

import com.blackstar.interfaces.IUserService;
import com.google.apphosting.api.UserServicePb.UserService;

public class GoogleUserService implements IUserService {

	@Override
	public String getCurrentUserId() {
		// TODO Auto-generated method stub
		return null;
		
	}

	@Override
	public String getCurrentUserName() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String[] getCurrentUsetGroups() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String[] getEmployeeList(){
		String[] emp = new String[11];
		emp[ 0 ] = "Alberto Lopez Gomez";
		emp[ 1 ] = "Alejandra Diaz";
		emp[ 2 ] = "Alejandro Monroy";
		emp[ 3 ] = "Angeles Avila";
		emp[ 4 ] = "Armando Perez Pinto";
		emp[ 5 ] = "Gonzalo Ramirez";
		emp[ 6 ] = "Jose Alberto Jonguitud Gallardo";
		emp[ 7 ] = "Marlem Samano";
		emp[ 8 ] = "Martin Vazquez";
		emp[ 9 ] = "Reynaldo Garcia";
		emp[ 10 ] = "Sergio  Gallegos";
		
		return emp;
	}
}
