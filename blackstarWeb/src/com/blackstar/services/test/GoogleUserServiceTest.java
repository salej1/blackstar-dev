package com.blackstar.services.test;

import static org.junit.Assert.*;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javassist.bytecode.Descriptor.Iterator;

import org.junit.Test;

import com.blackstar.services.GoogleUserService;

public class GoogleUserServiceTest {

	@Test
	public final void testGetCurrentUserGroups() {
		GoogleUserService target = new GoogleUserService();
		
		List<String> groups = target.getCurrentUserGroups();
		
		java.util.Iterator<String> it = groups.iterator();
		
		int counter = 0;
		while(it.hasNext()){
			counter++;
			String group = it.next();
			
			assertTrue(group.contains("sys"));
		}
		
		assertEquals(2, counter);
	}

	@Test
	public final void testGetEmployeeList() {
		GoogleUserService target = new GoogleUserService();
		
		Map<String, String> employees = target.getEmployeeList();
		
		// Verificando emails
		Set<String> keys = employees.keySet();
		java.util.Iterator<String> kit = keys.iterator();
		
		while(kit.hasNext()){
			String key = kit.next();
			assertTrue(key.contains("@"));
			assertTrue(key.contains(".com"));
		}
		
		assertTrue(keys.size() > 5);	
		
		// Verificando nombres
		Collection<String> names = employees.values();
		java.util.Iterator<String> nit = names.iterator();
		
		while(nit.hasNext()){
			String name = nit.next();
			assertTrue(name.contains(" "));
		}
		
		assertTrue(names.size() > 5);
	}

}
