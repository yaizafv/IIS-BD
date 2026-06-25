package db.jdbc1;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public class Program {

	private static String USERNAME = "uo";
	private static String PASSWORD = "uo";
	private static String CONNECTION_STRING = "jdbc:oracle:thin:@156.35.94.98:1521:DESA19";

	public static void main(String[] args) {
		// Examples to read by keyboard
//		System.out.println("Read an integer by keyboard");	
//		int integ = ReadInt();
//		
//		System.out.println("Read a string by keyboard");	
//		String str = ReadString();
		try {
			// exercise1_1();
			// exercise1_2();
			// exercise2();
			// exercise3();
			// exercise4();
			// exercise5_1();
			// exercise5_2();
			// exercise5_3();
			// exercise6_1();
			// exercise6_2();
			// exercise7_1();
			// exercise7_2();
			//exercise8_1();
			// exercise8_2();
			// ejemploNext();
			practica1();
		} catch (SQLException e) {
			System.err.println("SQL Exception " + e.getMessage());
			e.printStackTrace();
		}
	}

	/*
	 * 1. Develop a Java method that shows the results of queries 21 and 33 from lab
	 * session SQL2. 1.1. (21) Name and surname of customers that have bought a car
	 * in a 'madrid' dealer that has 'gti' cars.
	 * 
	 * 1. Crear un método en Java que muestre por pantalla los resultados de las
	 * consultas 21 y 33 de la Práctica SQL2.
	 * 
	 * 1.1 (21) Obtener el nombre y el apellido de los clientes que han adquirido un
	 * coche en un concesionario de Madrid, el cual dispone de coches del modelo
	 * gti.
	 */
	public static void exercise1_1() throws SQLException {
		Connection con = getConnection();
		String query = "select distinct name,surname\r\n" + "from customer c inner join sale s ON c.nif = s.nif\r\n"
				+ "                inner join dealer d ON s.cifd = d.cifd \r\n"
				+ "                inner join distribution dt ON dt.cifd = d.cifd\r\n"
				+ "                inner join car c ON dt.codecar = c.codecar\r\n"
				+ "where model='gti' and cityD='madrid'";
		Statement st = con.createStatement();
		ResultSet rs = st.executeQuery(query); // recoge el resultado de una consulta (es como un cursor)
		while (rs.next()) {
			System.out.println("Customer: " + rs.getString("name") + " " + rs.getString("surname"));
			// tambien se puede poner como rs.getString(0) y rs.getString(1),
			// respectivamente
		}
		rs.close();
		st.close();
		con.close();
	}

	/*
	 * 1.2. (33) Dealers having an average stockage greater than the average
	 * stockage of all other dealers.
	 * 
	 * 1.2 (33) Obtener un listado de los concesionarios cuyo promedio de coches
	 * supera al promedio de coches de cada uno del resto de concesionarios
	 */
	public static void exercise1_2() throws SQLException {
		Connection con = getConnection();
		String query = "select db.cifd, named,cityd\r\n"
				+ "from distribution db inner join dealer d ON db.cifd=d.cifd\r\n" + "group by db.cifd,named, cityd\r\n"
				+ "HAVING AVG(stock) >=  ALL(SELECT AVG(stock) FROM distribution GROUP BY cifd) ";
		Statement st = con.createStatement();
		ResultSet rs = st.executeQuery(query);
		while (rs.next()) {
			System.out.println(
					"Dealer: " + rs.getString("cifd") + " " + rs.getString("named") + " " + rs.getString("cityd"));
		}
		rs.close();
		st.close();
		con.close();
	}

	/*
	 * 2. Develop a Java method that shows the results of query 7 from lab session
	 * SQL2, so that the search color is entered by the user. (7) Names of car
	 * makers that have sold cars with a color that is entered by the user.
	 * 
	 * 2. Crear un método en Java que muestre por pantalla el resultado de la
	 * consulta 7 de la Práctica SQL2 de forma el color de la búsqueda sea
	 * introducido por el usuario. (7)Obtener el nombre de las marcas de las que se
	 * han vendido coches de un color introducido por el usuario.
	 */
	public static void exercise2() throws SQLException {
		Connection con = getConnection();
		String query = "select nameCM\r\n" + "from carmaker c inner join manufacture m ON c.cifcm = m.cifcm\r\n"
				+ "                inner join sale s ON s.codecar = m.codecar\r\n" + "where color=?"; // ? cuando es
																										// parametro
		PreparedStatement ps = con.prepareStatement(query);
		System.out.println("Introduce un color: ");
		String vColor = ReadString();
		ps.setString(1, vColor); // 1 ya que va en funcion de la posicion de las ?. es decir, si hubiera otra
									// despues esa tendria el valor 2
		ResultSet rs = ps.executeQuery(); // aqui no lleva parametro porque se lo das antes
		while (rs.next()) {
			System.out.println("Marca: " + rs.getString("nameCM"));
		}
		rs.close();
		ps.close();
		con.close();
	}

	/*
	 * 3. Develop a Java method to run query 27 from lab session SQL2, so that the
	 * limits for the number of cars are entered by the user. (27) CIFD of dealers
	 * with a stock between two values entered by the user, inclusive.
	 * 
	 * 3. Crear un método en Java para ejecutar la consulta 27 de la Práctica SQL2
	 * de forma que los límites la cantidad de coches sean introducidos por el
	 * usuario. (27) Obtener el CIFD de los concesionarios que disponen de una
	 * cantidad de coches comprendida entre dos cantidades introducidas por el
	 * usuario, ambas inclusive.
	 * 
	 */
	public static void exercise3() throws SQLException {
		Connection con = getConnection();
		String query = "select cifD\r\n" + "from distribution\r\n" + "group by cifd\r\n"
				+ "having sum(stock) between ? and ?";
		PreparedStatement ps = con.prepareStatement(query);
		System.out.println("Por favor, introduzca la cantidad minima: ");
		int minimum = ReadInt();
		System.out.println("Por favor, introduzca la cantidad maxima: ");
		int maximun = ReadInt();
		ps.setInt(1, minimum);
		ps.setInt(2, maximun);
		ResultSet rs = ps.executeQuery();
		while (rs.next()) {
			System.out.println("Dealer: " + rs.getString("cifD"));
		}
		rs.close();
		ps.close();
		con.close();
	}

	/*
	 * 4. Develop a Java method to run query 24 from lab session SQL2, so that the
	 * city of the dealer and the color are entered by the user. (24) Names of the
	 * customers that have NOT bought cars at dealers located in a city and with a
	 * color both entered by user.
	 * 
	 * 4. Crear un método en Java para ejecutar la consulta 24 de la Práctica SQL2
	 * de forma que tanto la ciudad del concesionario como el color sean
	 * introducidos por el usuario. (24) Obtener los nombres de los clientes que no
	 * han comprado coches de un color introducido por el usuario en concesionarios
	 * de una ciudad introducida por el usuario.
	 * 
	 */
	public static void exercise4() {

	}

	/*
	 * 5. Develop a Java method that, using the suitable SQL sentence: 5.1 Creates
	 * cars into the CAR table, taking the data from the user.
	 * 
	 * 5. Crear un método en Java que haciendo uso de la instrucción SQL adecuada:
	 * 5.1 Introduzca datos en la tabla Car cuyos datos son introducidos por el
	 * usuario
	 * 
	 */
	public static void exercise5_1() throws SQLException {
		Connection con = getConnection();
		String query = "INSERT INTO car (codecar,namecar,model) VALUES (?,?,?)";

		// asignar valor a todos los parametros
		System.out.println("Please, enter car code: ");
		int vcodecar = ReadInt();
		System.out.println("Please, enter car name: ");
		String vnamecar = ReadString();
		System.out.println("Please, enter car model: ");
		String vmodel = ReadString();

		PreparedStatement ps = con.prepareStatement(query);
		ps.setInt(1, vcodecar);
		ps.setString(2, vnamecar);
		ps.setString(3, vmodel);
		if (ps.executeUpdate() == 1) // executeUpdate devuelve el número de filas afectadas por la instrucción
			System.out.println("Datos introducidos correctamente");
		else
			System.out.println("Se ha producido algún error. No se ha podido insertar");
		ps.close();
		con.close();
	}

	/*
	 * 5.2. Deletes a specific car. The code for the car to delete is entered by the
	 * user.
	 * 
	 * 5.2. Borre un determinado coche cuyo código es introducido por el usuario.
	 */
	public static void exercise5_2() throws SQLException {
		Connection con = getConnection();
		System.out.println("Please, enter car code: ");
		int vcodecar = ReadInt();
		String query = "DELETE FROM CAR WHERE CODECAR = ?";
		PreparedStatement ps = con.prepareStatement(query);
		ps.setInt(1, vcodecar);
		if (ps.executeUpdate() == 1)
			System.out.println("Datos borrados correctamente");
		else
			System.out.println("Se ha producido algún error. No se ha podido borrar");
		ps.close();
		con.close();
		// fijarse que no hacemos commit; Se hace por defecto para la conexión.
		// AutoCommit->true
		// si quiesieramos hacerlo a meno habria que poner al principio:
		// conn.setAutoCommit(false);
		// y al final conn.commit();
	}

	/*
	 * 5.3. Updates the name and model for a specific car. The code for the car to
	 * update is entered by the user
	 * 
	 * 5.3 Actualice el nombre y el modelo para un determinado coche cuyo código es
	 * introducido por el usuario.
	 * 
	 */
	public static void exercise5_3() throws SQLException {
		Connection con = getConnection();
		String query = "UPDATE Car SET namecar = ?, model = ? WHERE codecar = ?";

		System.out.println("Please, enter car name: ");
		String vnamecar = ReadString();
		System.out.println("Please, enter car model: ");
		String vmodel = ReadString();
		System.out.println("Please, enter car code: ");
		int vcodecar = ReadInt();

		PreparedStatement ps = con.prepareStatement(query);
		ps.setString(1, vnamecar);
		ps.setString(2, vmodel);
		ps.setInt(3, vcodecar);
		if (ps.executeUpdate() == 1) // executeUpdate devuelve el número de filas afectadas por la instrucción
			System.out.println("Datos introducidos correctamente");
		else
			System.out.println("Se ha producido algún error. No se ha podido insertar");
		ps.close();
		con.close();
	}

	/*
	 * 6. Invoke the exercise 10 function and procedure from lab session PL1 from a
	 * Java application. (10) Develop a procedure and a function that take a dealer
	 * cif and return the number of sales that were made by that dealer.
	 * 
	 * 6. Invocar desde Java una función y un procedimiento (ya definidos en la base
	 * de datos porque fueron creados en el ejercicio 10 de la PLSQL1) que, dado un
	 * código de concesionario, devuelven el número de ventas que se han realizado
	 * en el mismo.
	 * 
	 * 6.1. Function
	 */
	public static void exercise6_1() {

	}

	/*
	 * 6.2. Procedure
	 */
	public static void exercise6_2() {

	}

	/*
	 * 7. Invoke the exercise 11 function and procedure from lab session PL1 from a
	 * Java application. (11) Develop a PL/SQL function and a procedure that take a
	 * nif that is passed as a parameter and returns 2 values: a) the number of cars
	 * that customer has purchased and b) the number of dealers in which he has
	 * purchased them.
	 * 
	 * 
	 * 7. Invocar desde Java una función y un procedimiento (ya definidos en la base
	 * de datos porque fueron creados en el ejercicio 11 de la PLSQL1) que, dado un
	 * NIF que es pasado como parámetro devuelve 2 valores: a) el número de coches
	 * que se ha comprado dicho cliente y b) el número de concesionarios en los que
	 * lo ha hecho.
	 * 
	 * 
	 * 7.1. Function
	 */
	public static void exercise7_1() throws SQLException {
		Connection con = getConnection();
		CallableStatement cs = con.prepareCall("{?=call function11(?,?)}"); // en minusculas
		// asignar valor a los parametros de entrada
		System.out.println("Please, enter a nif: ");
		String vnif = ReadString();
		cs.setString(2, vnif);

		// asignar valor a los parametros de salida
		cs.registerOutParameter(1, java.sql.Types.INTEGER);
		cs.registerOutParameter(3, java.sql.Types.INTEGER);

		// ejecuto la funcion
		cs.execute();

		// Recojo valor parametros de salida
		int nCars = cs.getInt(1);
		int nDealers = cs.getInt(3);

		System.out.println("El cliente ha comprado " + nCars + " coches en " + nDealers + " concesionarios");

		cs.close();
		con.close();
	}

	/*
	 * 7.2. Procedure
	 */
	public static void exercise7_2() throws SQLException {
		Connection con = getConnection();
		CallableStatement cs = con.prepareCall("{call procedure11(?,?,?)}"); // en minusculas
		// asignar valor a los parametros de entrada
		System.out.println("Please, enter a nif: ");
		String vnif = ReadString();
		cs.setString(1, vnif);

		// asignar valor a los parametros de salida
		cs.registerOutParameter(2, java.sql.Types.INTEGER);
		cs.registerOutParameter(3, java.sql.Types.INTEGER);

		// ejecuto la funcion
		cs.execute();

		// Recojo valor parametros de salida
		int nCars = cs.getInt(2);
		int nDealers = cs.getInt(3);

		System.out.println("El cliente ha comprado " + nCars + " coches en " + nDealers + " concesionarios");

		cs.close();
		con.close();
	}

	/*
	 * 8. Develop a Java method that displays the cars that have been bought by each
	 * customer. Besides, it must display the number of cars that each customer has
	 * bought and the number of dealers where each customer has bought. Customers
	 * that have bought no cars should not be shown in the report.
	 * 
	 * 8. Crear un método en Java que imprima por pantalla los coches que han sido
	 * adquiridos por cada cliente. Además, deberá imprimirse para cada cliente el
	 * número de coches que ha comprado y el número de concesionarios en los que ha
	 * comprado. Aquellos clientes que no han adquirido ningún coche no deben
	 * aparecer en el listado. La impresión debe responder al siguiente formato:
	 * 
	 * - Customer: name1 surname1 numcars1 numdeal1 ---> Car: codecar1 namec1 model1
	 * color1 ---> Car: codecar2 namec2 model2 color2 ---> . . . - Customer: name2
	 * surname2 numcars2 numdeal2 ---> Car: codecar1 namec1 model1 color1 ---> Car:
	 * codecar2 namec2 model2 color2 ---> . . .
	 */
	public static void exercise8_1() throws SQLException {
		Connection con = getConnection();
		// Primer nivel. Caso peor -> no ser capaces de hacerlo todo en una select
		String queryCustomers = "SELECT DISTINCT C.nif, C.name, C.surname, COUNT(*) AS numCars, COUNT(DISTINCT cifd) AS numDealers "
				+ " FROM Customer C INNER JOIN Sale S ON C.nif = S.nif " + " GROUP BY C.nif, C.name, C.surname";
		Statement pstCustomers = con.createStatement();
		ResultSet rsCustomers = pstCustomers.executeQuery(queryCustomers);

		String queryCars = "SELECT Car.codecar, Car.namecar, Car.model, S.color "
				+ " FROM Sale S JOIN Car ON S.codecar = Car.codecar " + " WHERE S.nif = ?";
		PreparedStatement pstCars = con.prepareStatement(queryCars);

		while (rsCustomers.next()) {

			String vnif = rsCustomers.getString("nif");

			// Imprimir información del cliente / Print customer info
			System.out.println("- Customer: " + rsCustomers.getString("name") + " " + rsCustomers.getString("surname")
					+ " " + " numCars=" + rsCustomers.getInt("numCars") + " " + " numDealers="
					+ rsCustomers.getInt("numDealers"));

			// Obtener los coches para el cliente vnif /Get cars for this customer
			pstCars.setString(1, vnif);
			ResultSet rsCars = pstCars.executeQuery();

			while (rsCars.next()) {
				System.out.println("  ---> Car: " + rsCars.getInt("codecar") + " " + rsCars.getString("namecar") + " "
						+ rsCars.getString("model") + " " + rsCars.getString("color"));
			}

			rsCars.close();
		}

		rsCustomers.close();
		pstCars.close();
		pstCustomers.close();
		con.close();

	}

	/*
	 * 8. Develop a Java method that displays the cars that have been bought by each
	 * customer. Besides, it must display the number of cars that each customer has
	 * bought and the number of dealers where each customer has bought. Customers
	 * that have bought no cars should not be shown in the report.
	 * 
	 * 8. Crear un método en Java que imprima por pantalla los coches que han sido
	 * adquiridos por cada cliente. Además, deberá imprimirse para cada cliente el
	 * número de coches que ha comprado y el número de concesionarios en los que ha
	 * comprado. Aquellos clientes que no han adquirido ningún coche no deben
	 * aparecer en el listado. La impresión debe responder al siguiente formato:
	 * 
	 * - Customer: name1 surname1 numcars1 numdeal1 ---> Car: codecar1 namec1 model1
	 * color1 ---> Car: codecar2 namec2 model2 color2 ---> . . . - Customer: name2
	 * surname2 numcars2 numdeal2 ---> Car: codecar1 namec1 model1 color1 ---> Car:
	 * codecar2 namec2 model2 color2 ---> . . .
	 */
	public static void exercise8_2() throws SQLException {
		// solución con una consulta únicamente para el primer nivel
		System.out.println("################### EXERCISE 8 ###################");
		Connection con = getConnection();

		String queryClientes = "select c.nif, name, surname,count(*) numCars, "
				+ "    count(distinct cifd) numDealers\r\n" + "from customer c inner join sale s ON c.nif=s.nif\r\n"
				+ "group by c.nif,name,surname";
		Statement st = con.createStatement();
		ResultSet rsclientes = st.executeQuery(queryClientes);

		String queryCoches = " select c.codecar, namecar, model, color\r\n"
				+ "from car c inner join sale s ON c.codecar= s.codecar\r\n" + "where nif=?";
		PreparedStatement pscoches = con.prepareStatement(queryCoches);

		while (rsclientes.next()) {

			System.out.println("- Customer: " + rsclientes.getString("name") + " " + rsclientes.getString("surname")
					+ " " + rsclientes.getInt("numcars") + " " + rsclientes.getInt("numdealers"));

			pscoches.setString(1, rsclientes.getString("nif"));
			ResultSet rs = pscoches.executeQuery();

			while (rs.next()) {
				System.out.println("---> Car: " + rs.getInt("codecar") + " " + rs.getString("namecar") + " "
						+ rs.getString("model") + " " + rs.getString("color"));
			}
			rs.close();
		}
		pscoches.close();
		rsclientes.close();
		st.close();
		con.close();
	}

	public static void ejemploNext() throws SQLException {
		System.out.println("################### EXERCISE 3 ###################");

		System.out.println("Por favor, introduzca un código de coche");
		int vcodcoche = ReadInt();

		Connection con = getConnection();

		PreparedStatement pst = con.prepareStatement("SELECT nameCar FROM car WHERE codecar= ? "); // si metes un
																									// codecar que no
																									// existe el
																									// resultado es
																									// vacio
		pst.setInt(1, vcodcoche);
		ResultSet rs = pst.executeQuery();
		// rs.next(); //sin el while al ser el resultado vacio dara excepcion
		while (rs.next()) {
			System.out.println(" Namecar = " + rs.getString("nameCar"));
		}

		rs.close();
		pst.close();
		con.close();
	}

	public static void practica1() throws SQLException {
		Connection con = getConnection();
		String judgeQuery = "select j.judge_id, judge_name, Count(*) numFinishedTrials, judge_salary\r\n"
				+ "from judge j, trial t\r\n" + "where judge_experience_years > 15\r\n"
				+ "and j.judge_id = t.judge_id\r\n" + "and status = 'finished'\r\n"
				+ "and judge_salary > (select Avg(judge_salary) from judge)\r\n"
				+ "group by j.judge_id, judge_name, judge_salary\r\n" + "order by judge_name asc";
		String convictedQuery = "select i.accused_id, verdict, trial_type, Count(evidence_number) numEvidences\r\n"
				+ "from involves i, trial t, evidence e, accused a\r\n" + "where verdict = 'convicted'\r\n"
				+ "and trial_type = 'Criminal'\r\n" + "and criminal_record is not null\r\n"
				+ "and a.accused_id = i.accused_id\r\n" + "and i.trial_id = t.trial_id\r\n"
				+ "and t.trial_id = e.trial_id\r\n" + "and t.judge_id = ? \r\n"
				+ "group by i.accused_id, verdict, trial_type\r\n" + "order by trial_type desc";
		Statement st = con.createStatement();
		PreparedStatement ps = con.prepareStatement(convictedQuery);
		ResultSet rsJudge = st.executeQuery(judgeQuery);
		while (rsJudge.next()) {
			System.out.println("JUDGE: " + rsJudge.getString("judge_id") + " " + rsJudge.getString("judge_name") + " "
					+ rsJudge.getInt("numFinishedTrials") + " " + rsJudge.getInt("judge_salary"));
			
			ps.setString(1, rsJudge.getString("judge_id"));
			ResultSet rs = ps.executeQuery();
			
			while(rs.next()) {
				System.out.println("CONVICTED: " + rs.getString("accused_id") + " " + rs.getString("verdict") + " "
						+ rs.getString("trial_type") + " " + rs.getInt("numEvidences"));
			}
			rs.close();
		}
		rsJudge.close();
		ps.close();
		st.close();
		con.close();
	}

	@SuppressWarnings("resource")
	private static String ReadString() {
		return new Scanner(System.in).nextLine();
	}

	@SuppressWarnings("resource")
	private static int ReadInt() {
		return new Scanner(System.in).nextInt();
	}

	private static Connection getConnection() throws SQLException {
		// DriverManager.registerDriver(new oracle.jdbc.OracleDriver()); // 1. Registrar
		// el driver. Imprescindible en
		// versiones antiguas. En las actuales no suele
		// ser necesario. Se puede comentar
		return DriverManager.getConnection(CONNECTION_STRING, USERNAME, PASSWORD); // 2. Crear la conexión. Devuelve un
																					// objeto de tipo Connection
	}
}
