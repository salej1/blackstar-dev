package com.blackstar.web;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.blackstar.model.Followup;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.User;

/**
 * Servlet implementation class osDetail
 */
public class osDetail extends HttpServlet {

	private static final long serialVersionUID = 1L;
    
    /**
     * @see HttpServlet#HttpServlet()
     */
    public osDetail() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 
		if(request.getParameter("datosComentario").toString().equals("")== false){
			  
			String[] datosComentario=request.getParameter("datosComentario").toString().split("&&");
			  String comentario = datosComentario[0];
			  String asignadoA = datosComentario[1];
			  String folioOS = datosComentario[2];
			  
			  //TODO: Guardar followup
			  Followup followup =  new Followup();
			  followup.setModified(new Date());
			  followup.setCreated(new Date());
		}		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		/// obtener el id de la orden de servicio
		String idOS = request.getAttribute("osID").toString();
		
		List<User> UsuariosAsignados = null; // TODO: Obtener los usuarios posibles a asignar una orden de servicio
		request.setAttribute("UsuariosAsignados", UsuariosAsignados);
		
		List<Followup> Comentarios = null; // TODO: Obtener por el id, los comentarios de la orden de servicio
		request.setAttribute("ComentariosOS", Comentarios);
		
		Serviceorder ordenServicio = null; // TODO: Obtener por el id de la orden de servicio
		request.setAttribute("servicioOrderDetail", ordenServicio);
		
		request.getRequestDispatcher("/osDetail.jsp").forward(request, response);
	}
	
	
}
