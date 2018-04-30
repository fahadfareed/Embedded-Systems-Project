using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO.Ports;

namespace ConsoleApplication1
{
  class SerialPortProgram
  {
	// Create the serial port with basic settings
	private SerialPort port = new SerialPort("COM7", 9600, Parity.None, 8, StopBits.One);

	[STAThread]
	static void Main(string[] args)
	{ 
	  // Instatiate this class
	  new SerialPortProgram();
      Console.ReadLine();
	}

	private SerialPortProgram()
	{
		Console.WriteLine("Incoming Data:");
			  
		// Begin communications 
		if (port.IsOpen)
		{
			port.Close();
		}
		port.Open();
        port.DtrEnable = true;

		port.NewLine = "\n";
		Console.WriteLine(port.ToString());
		Console.WriteLine(port.PortName);
		Console.WriteLine(port.NewLine.ToString());
		Console.WriteLine(port.IsOpen.ToString());
		Console.WriteLine(port.ReadExisting());				
		
		//Enter an application loop to keep this thread alive
		//Application.Run();
		int i = 0;
		while (i < 1000)
		{
			// Attach a method to be called when there	  // is data waiting in the port's buffer
			port.DataReceived += new SerialDataReceivedEventHandler(port_DataReceived);
			Console.WriteLine(port.ReadExisting());
			i++;
		}
		port.Close();
	}

	private void port_DataReceived(object sender,	  SerialDataReceivedEventArgs e)
	{
	  // Show all the incoming data in the port's buffer
	  Console.WriteLine(port.ReadExisting());
	}
  }
}

