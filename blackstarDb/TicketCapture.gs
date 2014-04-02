  function CopiarCaptura() {
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var captura = ss.getSheetByName("Captura")
  var urenglon = captura.getLastRow();
  var marcatemp= ss.getSheetByName("Captura").getRange(urenglon,1).getValue();
  var usuario= ss.getSheetByName("Captura").getRange(urenglon,2).getValue();
  var contacto= ss.getSheetByName("Captura").getRange(urenglon,3).getValue();
  var telefono= ss.getSheetByName("Captura").getRange(urenglon,4).getValue();
  var email= ss.getSheetByName("Captura").getRange(urenglon,5).getValue();
  var serie= ss.getSheetByName("Captura").getRange(urenglon,6).getValue();
  var observaciones= ss.getSheetByName("Captura").getRange(urenglon,7).getValue();
  var ano = ss.getSheetByName("Seguimiento").getRange(1,23).getValue();
  var fechaactual = ss.getSheetByName("Seguimiento").getRange(1,26).getValue();
  
  var seguimiento = ss.getSheetByName("Seguimiento");
  urenglon = urenglon + 1;
  var ticket = urenglon - 2;
  seguimiento.getRange(urenglon,1).setValue(marcatemp);
  seguimiento.getRange(urenglon,2).setValue(usuario);
  seguimiento.getRange(urenglon,3).setValue(contacto);
  seguimiento.getRange(urenglon,4).setValue(telefono);
  seguimiento.getRange(urenglon,5).setValue(email);
  seguimiento.getRange(urenglon,6).setValue(serie);
  seguimiento.getRange(urenglon,7).setValue(observaciones);
  seguimiento.getRange(urenglon,23).setValue(ano+"-"+ticket);
  // Escribiendo semilla de transferencia
  seguimiento.getRange(urenglon,45).setValue(1);
  //
  var cliente = ss.getSheetByName("Seguimiento").getRange(urenglon,8).getValue();
  var equipo = ss.getSheetByName("Seguimiento").getRange(urenglon,9).getValue();
  var marca = ss.getSheetByName("Seguimiento").getRange(urenglon,10).getValue();
  var modelo = ss.getSheetByName("Seguimiento").getRange(urenglon,11).getValue();
  var capacidad = ss.getSheetByName("Seguimiento").getRange(urenglon,12).getValue();
  var tr = ss.getSheetByName("Seguimiento").getRange(urenglon,13).getValue();
  var ts = ss.getSheetByName("Seguimiento").getRange(urenglon,14).getValue();
  var direccion = ss.getSheetByName("Seguimiento").getRange(urenglon,15).getValue();
  var ubicacion = ss.getSheetByName("Seguimiento").getRange(urenglon,16).getValue();
  var partes = ss.getSheetByName("Seguimiento").getRange(urenglon,17).getValue();
  var ExPartes = ss.getSheetByName("Seguimiento").getRange(urenglon,18).getValue();
  var oficina = ss.getSheetByName("Seguimiento").getRange(urenglon,20).getValue();
  var Proyecto = ss.getSheetByName("Seguimiento").getRange(urenglon,21).getValue();
  var centroserv= ss.getSheetByName("Seguimiento").getRange(urenglon,19).getValue();
  var correo="";
  var correo2="";
  var correo3="";
  var fechafin = ss.getSheetByName("Seguimiento").getRange(urenglon,22).getValue();
  var vstatus= fechafin - fechaactual;
  var status;
  
  if (vstatus >= 0)
    {
      status = "Activo";
    } 
     else
     {
       status = "VENCIDO";
     }
  
  /*if (oficina == "GDL")
      {
       correo2 = ss.getSheetByName("Correos").getRange(2,2).getValue();
      }
      if (oficina == "MXO")
      {
      //correo2= "mexico@gposac.com.mx";
      correo2 = ss.getSheetByName("Correos").getRange(3,2).getValue();
      }
      if (oficina == "QRO")
      {
       correo2 = ss.getSheetByName("Correos").getRange(4,2).getValue();
      }
  */

if (centroserv == "Altamira SH")
    {
      correo = ss.getSheetByName("Correos").getRange(7,2).getValue();
      correo2 = ss.getSheetByName("Correos").getRange(4,2).getValue();
    }
  
  if (centroserv == "Monterrey SF")
    {
      correo = ss.getSheetByName("Correos").getRange(5,2).getValue();
      correo2 = ss.getSheetByName("Correos").getRange(4,2).getValue();
    }  
  
  if (centroserv == "Villahermosa IS")
    {
      correo = ss.getSheetByName("Correos").getRange(8,2).getValue();
      correo2 = ss.getSheetByName("Correos").getRange(3,2).getValue();
    }
  
  if (centroserv == "Merida AS")
    {
      correo = ss.getSheetByName("Correos").getRange(6,2).getValue();
      correo2 = ss.getSheetByName("Correos").getRange(3,2).getValue();
    }
  
  if (centroserv == "Veracruz SA")
    {
      correo = ss.getSheetByName("Correos").getRange(14,2).getValue();
      correo2 = ss.getSheetByName("Correos").getRange(3,2).getValue();
    }
  
  if (centroserv == "Culiacan ST")
    {
      correo = ss.getSheetByName("Correos").getRange(10,2).getValue();
      correo2 = ss.getSheetByName("Correos").getRange(2,2).getValue();
    }
  
  if (centroserv == "Chihuahua ER")
    {
      correo = ss.getSheetByName("Correos").getRange(11,2).getValue();
      correo2 = ss.getSheetByName("Correos").getRange(2,2).getValue();
    }
  
  if (centroserv == "Monterrey LB")
    {
      correo = ss.getSheetByName("Correos").getRange(9,2).getValue();
      correo2 = ss.getSheetByName("Correos").getRange(4,2).getValue();
    }
    
   if (centroserv == "Carmen SI")
    {
      correo = ss.getSheetByName("Correos").getRange(13,2).getValue();
      correo2 = ss.getSheetByName("Correos").getRange(3,2).getValue();
    }
  
  if (centroserv == "Tijuana BK")
    {
      correo = ss.getSheetByName("Correos").getRange(12,2).getValue();
      correo2 = ss.getSheetByName("Correos").getRange(2,2).getValue();
    }
  
  if (centroserv == "GDL")
      {
       correo = ss.getSheetByName("Correos").getRange(2,2).getValue();
      }
      if (centroserv == "MXO")
      {
      correo = ss.getSheetByName("Correos").getRange(3,2).getValue();
      }
      if (centroserv == "QRO")
      {
      correo = ss.getSheetByName("Correos").getRange(4,2).getValue();
      }
  
/*  if (centroserv == oficina)
    {
      correo = "";
    }
  */
  
  if (Proyecto == "CM150")
    {
      correo3 = "victor.david.portales@pemex.com,angel.manuel.estudillo@pemex.com";
    }
      else
      {
        correo3 = "";
      }
  
  MailApp.sendEmail("call-center@gposac.com.mx,"+correo+","+correo2+","+correo3+","+email,"Reporte de Emergencia "+ano+"-"+ticket,"",                    
                    { htmlBody:
                    "<table widht='100%' border='0'>"
                    +"<tr><td><strong>Usuario:</strong></td><td>" + usuario + "<br /></td></tr>"
                    +"<tr><td><strong>Numero de Ticket:</strong></td><td>" + ano+"-"+ticket + "<br /></td></tr>" 
                    +"<tr><td><strong>Fecha y Hora de recepcion:</strong></td><td>" + marcatemp + "<br /></td></tr>"
                    +"<tr><td><strong>Contacto:</strong></td><td>" + contacto + "<br /></td></tr>"
                    +"<tr><td><strong>Proyecto:</strong></td><td>" + Proyecto + "<br /></td></tr>"
                    +"<tr><td><strong>Empresa:</strong></td><td>"+ cliente + "<br /></td></tr>"
                    +"<tr><td><strong>Ubicacion del servicio:</strong></td><td>" + direccion +" "+ubicacion + "<br /></td></tr>"
                    +"<tr><td><strong>Telefono:</strong></td><td>" + telefono + "<br /></td></tr>"
                    +"<tr><td><strong>Email:</strong></td><td>" + email + "<br /></td></tr>"
                    +"<tr><td><strong>Equipo:</strong></td><td>" + equipo + "<br /></td></tr>"
                    +"<tr><td><strong>Modelo:</strong></td><td>" + modelo + "<br /></td></tr>"
                    +"<tr><td><strong>Capacidad:</strong></td><td>" + capacidad + "<br /></td></tr>"
                    +"<tr><td><strong>Marca:</strong></td><td>" + marca + "<br /></td></tr>"
                    +"<tr><td><strong>Numero de Serie:</strong></td><td>" + serie + "<br /></td></tr>"
                    +"<tr><td><strong>Tiempo  máxima de Respuesta:</strong></td><td>" + tr +" Horas"+ "<br /></td></tr>"
                    +"<tr><td><strong>Tiempo máxima de Solución:</strong></td><td>" + ts +" Horas"+ "<br /></td></tr>"
                    +"<tr><td><strong>Incluye Partes:</strong></td><td>" + partes +" excepto "+ExPartes+ "<br /></td></tr>"
                    +"<tr><td><strong>Observaciones:</strong></td><td>" + observaciones + "<br /></td></tr>"
                    +"<tr><td><strong>Centro de Servicio:</strong></td><td>" + centroserv + "<br /></td></tr>"
                    +"<tr><td><strong>Estado del Contrato:</strong></td><td>" + status + "<br /></td></tr>"
                    +"<tr><td><strong>Fecha de Vencimiento de Contrato:</strong></td><td>" + fechafin + "<br /></td></tr>"
                    /*+"<tr><td><strong>Correo:</strong></td><td>" + correo + "<br /></td></tr>"
                    +"<tr><td><strong>Correo2:</strong></td><td>" + correo2 + "<br /></td></tr>"
                    +"<tr><td><strong>Oficina:</strong></td><td>" + oficina + "<br /></td></tr>"*/
                    +"</table>"
                    , name: 'Call Center Grupo SAC', replyTo: 'call-center@gposac.com.mx'});
             

}




