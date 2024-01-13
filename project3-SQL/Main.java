
import java.util.*;
import java.io.*;
import java.sql.*;


public class Main {	
	public static void main(String[] args) throws Exception {
		//scanner to grab input
		Scanner assertion = new Scanner(System.in);
		
		//ask the user to enter the username and password for sql
		System.out.println("Enter your username: ");
		String user = assertion.next();
		System.out.println("Enter your password: ");
		String password = assertion.next();
		
		//establishes connection
		Connection connector = getConnection(user, password);
		PreparedStatement prepared = null;
		ResultSet end = null;
		
		//main menu 

		System.out.println("Welcome to the library, what do you want to do? ");
		System.out.println("Press 1 to print all book information ");
		System.out.println("Press 2 to print all authors ");
		System.out.println("Press 3 for book copies ");
		System.out.println("Press 4 for member information ");           
		System.out.println("Press 5 for unfinalized loans ");
		System.out.println("Press 6 for borrowed book info ");
		System.out.println("press 7 borrow book ");
		System.out.println("Press 8 renewed book copies ");
		System.out.println("Press 9 owed money ");
		System.out.println("Press 10 member information on owed money ");
		System.out.println("Press 0 to exit program ");
		int choice = inspect.nextInt(); 
		switch(choice)	{
		
		case 1: assertion = connector.prepared("SELECT * from BOOK");	// connects to sql and reads in query //
				end = assertion.executeQuery();
				while(end.next()) {
				                                 // book information //
					System.out.print(end.getString("title"));
					System.out.print("|");
					System.out.print(end.getString("genre"));
					System.out.print("|");
					System.out.print(end.getString("ISBN"));
					System.out.print("|");
					System.out.print(end.getString("date_published"));
					System.out.print("|");
					System.out.print(end.getString("publisher"));
					System.out.print("|");
					System.out.print(end.getString("edition"));
					System.out.print("|");
					System.out.print(end.getString("description"));
					System.out.println("    ");
					
					
				}
				System.out.println("Where do you want to go next?" );    // asks user if they want to continue //
				choice = scan.nextInt();7yu6
			
		case 2: 
				assertion = connector.prepared("Select first_name, middle_name, last_name from author");
				end = assertion.executeQuery();
				while(end.next())   {                        // author information //
				
					System.out.print(end.getString("first_name"));
					System.out.print("|");
					System.out.print(end.getString("middle_name"));       // prints through java // 
					System.out.print("|");
					System.out.print(end.getString("last_name"));
					System.out.println("    ");
				}
				
				System.out.println("Where do you want to go next?" ); // asks to continue //
				choice = scan.nextInt();

		case 3: 
				assertion = connector.prepared("Select copy.ISBN, copy.barcode, book.title from copy join book");
				end = assertion.executeQuery();      // book copies information //
				while(end.next())	{
				
					System.out.print(end.getString("ISBN"));
					System.out.print("|");
					System.out.print(end.getString("barcode"));
					System.out.print("|");               // prints query // 
					System.out.print(end.getString("title"));
					System.out.println("    ");
				}
				
				System.out.println("Where do you want to go next?" );   // asks if want to continue //
				choice = scan.nextInt();
				
		case 4: 
				assertion = connector.prepared("Select card_no, first_name, middle_name, last_name from member");
				end = assertion.executeQuery();
				while(end.next())  {             // member information // 
				
					System.out.print(end.getString("card_no"));
					System.out.print("|");
					System.out.print(end.getString("first_name"));
					System.out.print("|");                // prints query //
					System.out.print(end.getString("middle_name"));
					System.out.print("|");
					System.out.print(end.getString("last_name"));
					System.out.println("    ");
				
				}
			
				System.out.println("Where do you want to go next?" );       // asks user if want to continue //				
				choice = scan.nextInt();
		
		case 5: 
				assertion = connector.prepared("Select * from member natural join borrow" + "where paid IS NOT null");
				end = assertion.executeQuery();
				while(end.next())   {                       // sql query where books were paid //
					
					System.out.print(end.getString("first_name"));
					System.out.print("|");
					System.out.print(end.getString("last_name"));      // print query //
					System.out.print("|");
					System.out.print("paid");
					System.out.println("   ");
				}
				
			
				System.out.println("Where do you want to go next?" );    // asks user if want to continue
				choice = scan.nextInt();
			
		case 6:
				// shows when every borrowed book was returned // 
				assertion = connector.prepared("Select card_no, date_returned from borrow");
				end = assertion.executeQuery();
				while(end.next())	{
				
					System.out.print(end.getString("card_no"));
					System.out.print("|");
					System.out.print(end.getString("date_returned"));
					System.out.println("   ");
				}
				
				System.out.println("Where do you want to go next?" );
				choice = scan.nextInt();
		
		 case 7:
				// date book was borrowed, card no, first and last name of people with borrowed books //
				assertion = connector.prepared("select distinct date_borrowed, member.card_no, borrow.card_no, first_name, last_name"
					+ "from borrow join member "
					+ "where member.card_no = borrow.card_no");
				end = assertion.executeQuery();
				while(end.next())	{
				
					System.out.print(end.getString("date_borrowed"));
					System.out.print("|");
					System.out.print(end.getString("card_no"));
					System.out.print("|");
					System.out.print(end.getstring("first_name"));
					System.out.print("|");
					System.out.print(end.getString("last_name"));
					System.out.print("   ");
				}
				
				System.out.println("Where do you want to go next?" );
				choice = scan.nextInt();
			
		case 8:
				// card number of members with renewals printed //
				assertion = connector.prepared("select card_no ,renewals_no"
						+ "from borrow");
				end = assertion.executeQuery();
				while(end.next())	{
				
					System.out.print(end.getString("card_no"));
					System.out.print("|");
					System.out.print(end.getString("renewals_no"));
					System.out.println("    ");
				}
				
				System.out.println("Where do you want to go next?" );
				choice = scan.nextInt();
		
		case 9:
				// gets the amount of money each member owes to library //
				assertion = connector.prepared("WITH late_days AS \r\n"
						+ "(SELECT card_no, datediff(now(), date_add(date_borrowed, INTERVAL renewals_no * 14 DAY)) * .25 as fees"
						+ "FROM borrow"
						+ "WHERE date_returned IS NULL AND renewals_no <= 2 AND datediff(now(), date_add(date_borrowed, INTERVAL renewals_no * 14 DAY)) > 14"
						+ "ORDER BY card_no)"
						+ "SELECT member.card_no, first_name, middle_name, last_name, sum(late_days.fees) AS fees"
						+ "FROM member RIGHT JOIN late_days ON member.card_no = late_days.card_no"
						+ "GROUP BY card_no;");
				end = assertion.executeQuery();
				while(end.next())	{
				// prints query //
					System.out.print(end.getString("card_no"));
					System.out.print("|");
					System.out.print(end.getString("first_name"));
					System.out.print("|");
					System.out.print(end.getString("middle_name"));
					System.out.print("|");
					System.out.print(end.getString("last_name"));
					System.out.print("|");
					System.out.print(end.getString("fees"));
					System.out.println("   ")
				}
				
				System.out.println("Where do you want to go next?" );
				choice = scan.nextInt();
			
		case 10:
				assertion = connector.prepared("select card_no, date_borrowed, date_returned"    // query return unreturned books //
						+ "from borrow"
						+ "where date_returned = null");
				end = assertion.executeQuery();
				while(end.next())	{
				
					System.out.print(end.getString("card_no"));			// prints books//
					System.out.print(end.getString("date_borrowed"));
					System.out.print(end.getString(""));
				}	
				
				System.out.println("Where do you want to go next?" );
				choice = scan.nextInt();
		
			
		case 0:
			System.out.println("Exiting program");
			break;
		}
		//close connection 
		connect.close();
		System.out.println("Connection closed");
	}
	
	
	//how it conencted earlier through mysql
	public static Connection getConnection(String usr, String pwd) throws Exception{
		try {
			String driver = "com.mysql.cj.jdbc.Driver";
			String url = "jdbc:mysql://localhost:3306/library";
			String username = usr;
			String password = pwd;
			Class.forName(driver);
			
			Connection conn = DriverManager.getConnection(url,username,password);
			System.out.println("Connected!");
			return conn;
		} catch(Exception e) {System.out.println(e);}
		return null;
	}
}
