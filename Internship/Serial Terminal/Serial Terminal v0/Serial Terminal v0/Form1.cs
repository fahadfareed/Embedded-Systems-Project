using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO.Ports;
using System.Threading;
using System.IO;

namespace Serial_Terminal_v0
{
    public partial class Form1 : Form
    {
        private string dataReceived = string.Empty;
        private delegate void SetTextDeleg(string text);

        private bool folderSelected = false;
        private bool fileNameSelected = false;
        private string folderName, fileName;
        private bool logData = false;

        StreamWriter o_streamWriter_aWriter;

        public Form1()
        {
            InitializeComponent();
            this.Text = "Serial Data logger 9000";

            this.textBox1.AppendText("Available ports:\n");
            //Adding the available COM ports
            this.comboBox1.Items.Clear();
            string[] thePortNames = System.IO.Ports.SerialPort.GetPortNames();
            foreach (string item in thePortNames)
            {
                this.comboBox1.Items.Add(item);
                this.textBox1.AppendText(item);
            }
            this.textBox1.AppendText("\n");
            this.textBox1.AppendText("-------------------------\n");


            //Adding the common baud rates
            this.comboBox2.Items.Clear();
            this.comboBox2.Items.Add("2400");
            this.comboBox2.Items.Add("4800");
            this.comboBox2.Items.Add("9600");
            this.comboBox2.Items.Add("14400");
            this.comboBox2.Items.Add("19200");
            this.comboBox2.Items.Add("28800");
            this.comboBox2.Items.Add("38400");
            this.comboBox2.Items.Add("56000");
            this.comboBox2.Items.Add("57600");
            this.comboBox2.Items.Add("115200");
            string portS;
            if (thePortNames.Length > 0)
            {
                portS = thePortNames[0];
            }
            else
            {
                portS = "COM7";
            }

            mySerialPort = new SerialPort(portS, 9600, Parity.None, 8, StopBits.One);
            this.mySerialPort.DataReceived += new SerialDataReceivedEventHandler(sp_DataReceived);
            //sp.Open();


        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (!mySerialPort.IsOpen)
            {
                try
                {
                    mySerialPort.Open();
                    this.textBox1.AppendText("Opening port\n");
                }
                catch (System.IO.IOException ex)
                {
                    this.textBox1.AppendText("Error opening the port:\n");
                    this.textBox1.AppendText(ex.Message + "\n");
                }
                finally
                {
                    if(mySerialPort.IsOpen)
                    this.textBox1.AppendText("Connected\n");
                    this.textBox1.AppendText("-------------------------\n");
                }
            }
            else
            {
                this.textBox1.AppendText("port already open\n");
            }
        }


        //COM PORT COMBO BOX
        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

            this.mySerialPort.PortName = this.comboBox1.Text;
            this.textBox1.AppendText("port selected: ");
            this.textBox1.AppendText(this.mySerialPort.PortName);
            this.textBox1.AppendText("\n");

        }

        //BAUD RATE COMBO BOX
        private void comboBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (comboBox2.SelectedItem != null)
            {
                this.mySerialPort.BaudRate = int.Parse(comboBox2.SelectedItem.ToString());
                this.textBox1.AppendText("Baud rate changed: " + this.mySerialPort.BaudRate + "\n");
            }
        }


        void sp_DataReceived(object sender, SerialDataReceivedEventArgs e)
        {
            try
            {
                //Thread.Sleep(500);
                string x = mySerialPort.ReadLine(); // will read to the first carriage return
                this.BeginInvoke(new SetTextDeleg(si_DataReceived), new object[] { x });
            }
            catch
            { }
        }

        private void si_DataReceived(string data)
        {
            dataReceived = data.Trim();
            this.textBox1.AppendText(dataReceived + "\n");
            if(logData)
                o_streamWriter_aWriter.WriteLine(dataReceived);
            
        }

        private void button1_Click(object sender, EventArgs e)
        {
            this.textBox1.Clear();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            FolderBrowserDialog fbd = new FolderBrowserDialog();
            DialogResult result = fbd.ShowDialog();
            folderSelected = true;
            folderName = fbd.SelectedPath;
            //this.textBox1.AppendText(folderName + "\\" + fileName);
        }

        private void button4_Click(object sender, EventArgs e)
        {
            if (!folderSelected)
            {
                button3_Click(this, null);
            }
            if (!fileNameSelected)
            {
                this.textBox1.AppendText("No filename entered\n");
                return;
            }

            //Start streaming to file
            FileStream o_fs_aFileStream = new FileStream(folderName + "\\" + fileName, FileMode.Create);
            o_streamWriter_aWriter = new StreamWriter(o_fs_aFileStream); 
            logData = true;
        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {
        }
        
        private void textBox2_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                fileNameSelected = true;
                fileName = this.textBox2.Text;
                //this.textBox1.AppendText(fileName+"\n");
            }
        }

        private void button5_Click(object sender, EventArgs e)
        {
            if (o_streamWriter_aWriter != null && logData == true)
                o_streamWriter_aWriter.Close();
            logData = false;
        }


    }
}
