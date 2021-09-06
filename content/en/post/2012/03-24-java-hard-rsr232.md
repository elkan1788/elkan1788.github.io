---
title: Java program and RSR232 serial communication skills
url: 2012/03/24/java-hard-rsr232.html
date: "2012-03-24 22:21:20"
tags: 
  - Java
  - RSR232
categories:
  - Java
---


I've been learning about J2EE application development and never thought about writing hardware interactions with JAVA, but I just like to try something new that I haven't come into contact with. Searched some resources on the Internet, learned that JAVA write serial communication is quite a lot, then began to prepare for the development of debugging environment. Software program development environment is not a problem, but this hardware environment is a bit difficult. Not to mention their own use of notebook where to string ah, and if you really take this string of hardware to their own will not make, then thought of the virtual machine, think this thing should also have a virtual bar, really with their own guesses as there is really this thing, by the way also downloaded a string of small assistant for debugging. 

<!--more-->

Here's a look at how the software environment is built:

 
:: Download 'comm.jar', 'win32com.dll' and 'javax.comm.properties'. (Accessories are available for download)
Description: 'comm.jar' provides the java API for communication, 'win32com.dll' provides a local driver interface for 'comm.jar' calls, 'javax.comm.properties' is the class profile for this driver
Copy 'javacomm.jar' to 'X:\jre\lib\ext' directory below;
:: Copy 'javax.comm.properties' to 'X:\jre.lib' directory below;
Copy 'win32com.dll' to 'X:\jre'bin' directory below;
:: Update the JDK environment inside the IDE, as shown below:

![java-hard-rsr232-1](//lisenhui.gitee.io/imgs/blog/2012/03-24-java-hard-rsr232-1.png)

Then there is the hardware virtual environment installation virtual serial port, here I use VSPD6.0 (attachment provides download), after installation to start VSPD to add the ports we need, note that here is the way to add by group, such as COM1 and COM2 is a set of simultaneous additions, and so on. 
 
Once all environments are ready, let's take a quick look at what comm .jar content. From the javadoc of the comm API alone, SUM provides us with only the following 13 classes or interfaces, as follows:

```java

javax.comm.CommDriver
javax.comm.CommPort javax.comm.ParallelPort
javax.comm.SerialPort javax.comm.CommPortIdentifier
javax.comm.CommPortOwnershipListener
javax.comm.ParallelPortEvent javax.comm.SerialPortEvent
javax.comm.ParallelPortEventListener (extends java.util.EventListener)
javax.comm.SerialPortEventListener (extends java.util.EventListener)
javax.comm.NoSuchPortException javax.comm.PortInUseException
javax.comm.UnsupportedCommOperationException
  
```

These classes and interfaces named at a glance to know its meaning, do not do a one-to-one introduction, you can go to the official website or the Internet to find more detailed information. Here's a test of whether the built environment is available, with the following main code:

```java

Enumeration<?> en = CommPortIdentifier.getPortIdentifiers();
CommPortIdentifier portId;
while (en.hasMoreElements()) {
  portId (CommPortIdentifier) in.nextElement();
  If the port type is serial, its port information is printed
  if (portId.getPortType() == CommPortIdentifier.PORT_SERIAL) {
    System.out.println(portId.getName());
  }
}

```

After running the code, the console has the correct port to output (see figure below), indicating that all environments are ok to go down, otherwise check. 

![java-hard-rsr232-2](//lisenhui.gitee.io/imgs/blog/2012/03-24-java-hard-rsr232-2.png)

Finally, the problem of interaction with serial data is to be solved. The main difficulty with this is data reading, because we don't know when the port will have data coming or how long it will be. Typically, serial communication applications have two modes, one is to implement the SerialPortEventListener interface, to listen for and handle various serial events, and the other is to establish a separate receiving thread dedicated to receiving data. After referring to the code of many older generations, the following is the first way to write a simple assistant program, the specific implementation of the detailed code, as follows:

```java

package com.elkan1788.view;

import java.awt.BorderLayout;
import java.awt.Button;
import java.awt.Color;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.Image;
import java.awt.TextArea;
import java.awt.TextField;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.TooManyListenersException;

import javax.comm.CommPortIdentifier;
import javax.comm.NoSuchPortException;
import javax.comm.PortInUseException;
import javax.comm.SerialPort;
import javax.comm.SerialPortEvent;
import javax.comm.SerialPortEventListener;
import javax.comm.UnsupportedCommOperationException;
import javax.imageio.ImageIO;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.SwingConstants;
import javax.swing.border.EmptyBorder;

public class JavaRs232 extends JFrame implements ActionListener, SerialPortEventListener {

  /**
   * JDK Serial Version UID
   */
  private static final long serialVersionUID = -7270865686330790103L;

  protected int WIN_WIDTH = 380;
  
  protected int WIN_HEIGHT = 300;
  
  private JComboBox<?> portCombox, rateCombox, dataCombox, stopCombox, parityCombox; 
  
  private Button openPortBtn, closePortBtn, sendMsgBtn;
  
  private TextField sendTf;
  
  private TextArea readTa;
  
  private JLabel statusLb;
  
  private String portname, rate, data, stop, parity;
  
  protected CommPortIdentifier portId;
  
  protected Enumeration<?> ports;
  
  protected List<String> portList;

  protected SerialPort serialPort;

  protected OutputStream outputStream = null; 

  protected InputStream inputStream = null; 
    
  protected String mesg;
    
  protected int sendCount, reciveCount;
  
    /**
     The default constructor
     */
  public JavaRs232() {    
    super ("Java RS-232 serial communication test program Van Dream Stardust");
    setSize(WIN_WIDTH, WIN_HEIGHT);
    setLocationRelativeTo(null);
    Image icon = null;
    try {
      icon = ImageIO.read(JavaRs232.class.getResourceAsStream("/res/rs232.png"));
    } catch (IOException e) {
      showErrMesgbox(e.getMessage());
    }
    setIconImage(icon);
    setResizable(false);
    scanPorts();
    initComponents();
    setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    setVisible(true);
  }
  
  /**
   Initialize each UI component
   :: @since March 22, 2012 11:56:39 PM
   */
  public void initComponents() {    
    Shared constants
    Font lbFont - new Font ("Microsoft Ya black," Font.TRUETYPE_FONT, 14);

    Create the left panel
    JPanel northPane = new JPanel();
    northPane.setLayout(new GridLayout(1, 1));
    Set the components of the left panel
    JPanel leftPane = new JPanel();   
    leftPane.setOpaque(false);
    leftPane.setLayout(new GridLayout(3,2));
    JLabel portnameLb - new JLabel ("Serial slogan:"
    portnameLb.setFont(lbFont);
    portnameLb.setHorizontalAlignment(SwingConstants.RIGHT);
    portCombox = new JComboBox<String>((String [])portList.toArray(new String[0]));
    portCombox.addActionListener(this);
    JLabel databitsLb - new JLabel ("data bit:");
    databitsLb.setFont(lbFont);
    databitsLb.setHorizontalAlignment(SwingConstants.RIGHT);
    dataCombox = new JComboBox<Integer>(new Integer[]{5, 6, 7, 8});
    dataCombox.setSelectedIndex(3);
    dataCombox.addActionListener(this);
    JLabel ParityLb - new JLabel ("Check bit:");
    parityLb.setFont(lbFont);
    parityLb.setHorizontalAlignment(SwingConstants.RIGHT);
    parityCombox = new JComboBox<String>(new String[]{"NONE","ODD","EVEN","MARK","SPACE"});
    parityCombox.addActionListener(this);
    Add components to the panel
    leftPane.add(portnameLb);
    leftPane.add(portCombox);
    leftPane.add(databitsLb);
    leftPane.add(dataCombox);
    leftPane.add(parityLb);
    leftPane.add(parityCombox);

    Create the right panel
    JPanel rightPane = new JPanel();
    rightPane.setLayout(new GridLayout(3,2));
    Set the components of the right panel
    JLabel BaudrateLb - new JLabel ("Porter rate:");
    baudrateLb.setFont(lbFont);
    baudrateLb.setHorizontalAlignment(SwingConstants.RIGHT);
    rateCombox = new JComboBox<Integer>(new Integer[]{2400,4800,9600,14400,19200,38400,56000});
    rateCombox.setSelectedIndex(2);
    rateCombox.addActionListener(this);
    JLabel stopbitsLb s new JLabel ("stop bit:");
    stopbitsLb.setFont(lbFont);
    stopbitsLb.setHorizontalAlignment(SwingConstants.RIGHT);
    stopCombox = new JComboBox<String>(new String[]{"1","2","1.5"});
    stopCombox.addActionListener(this);
    openPortBtn - new Button ("Open Port");
    openPortBtn.addActionListener(this);
    closePortBtn - new Button ("close port"); 
    closePortBtn.addActionListener(this);
    Add components to the panel
    rightPane.add(baudrateLb);
    rightPane.add(rateCombox);
    rightPane.add(stopbitsLb);
    rightPane.add(stopCombox);
    rightPane.add(openPortBtn);
    rightPane.add(closePortBtn);
    Add the left and right panel combinations to the north panel
    northPane.add(leftPane);
    northPane.add(rightPane);

    Create an intermediate panel
    JPanel centerPane = new JPanel();
    Set up the components of the middle panel
    sendTf = new TextField(42);
    readTa = new TextArea(8,50);
    readTa.setEditable(false);
    readTa.setBackground(new Color(225,242,250));
    centerPane.add(sendTf);
    sendMsgBtn - new Button ("Send");
    sendMsgBtn.addActionListener(this);
    Add components to the panel
    centerPane.add(sendTf);
    centerPane.add(sendMsgBtn);
    centerPane.add(readTa);
    
    Set up the south component
    statusLb = new JLabel();
    statusLb.setText(initStatus());
    statusLb.setOpaque(true);
    
    Gets the container for the main form and consolidates the layout north, middle, and south of the three panels above
    JPanel contentPane = (JPanel)getContentPane();
    contentPane.setLayout(new BorderLayout());
    contentPane.setBorder(new EmptyBorder(0, 0, 0, 0));
    contentPane.setOpaque(false);
    contentPane.add(northPane, BorderLayout.NORTH);
    contentPane.add(centerPane, BorderLayout.CENTER);
    contentPane.add(statusLb, BorderLayout.SOUTH);
  }
  
  /**
   The initialization status label displays text
   * @return String
   :: @since March 23, 2012 12:01:53 AM
   */
  public String initStatus() {
    portname = portCombox.getSelectedItem().toString();
    rate = rateCombox.getSelectedItem().toString();
    data = dataCombox.getSelectedItem().toString();
    stop = stopCombox.getSelectedItem().toString();
    parity = parityCombox.getSelectedItem().toString();
    
    StringBuffer str - new String Buffer ("Current string slogan:"
    str.append (portname).append ("porter rate:");
    str.append (rate).append ("data bit:");
    str.append (data.append ("stop bit");
    str.append (stop.append("check bit:");
    str.append(parity);
    return str.toString();
  }
  
  /**
   :: Scan all COM ports on this machine
   :: @since March 23, 2012 12:02:42 AM
   */
  public void scanPorts() {
    portList = new ArrayList<String>();
    Enumeration<?> en = CommPortIdentifier.getPortIdentifiers();
    CommPortIdentifier portId;
    while(en.hasMoreElements()){
      portId (CommPortIdentifier) in.nextElement();
      if(portId.getPortType() == CommPortIdentifier.PORT_SERIAL){
        String name = portId.getName();
        if(!portList.contains(name)) {
          portList.add(name);
        }
      }
    }
    if(null == portList 
        || portList.isEmpty()) {
      ShowErrMesgbox ("No available serial port number found, program cannot start!");
      System.exit(0);
    }
  }
  
  /**
   Open the serial port
   :: @since 2012-3-23 at 12:03:07 AM
   */
  public void openSerialPort() { 
    Gets the port you want to open
    try {
      portId = CommPortIdentifier.getPortIdentifier(portname);
    } catch (NoSuchPortException e) {
      showErrMesgbox ("Sorry, I didn't find the serial port number");
      setComponentsEnabled(true);
      return ;
    }
    Open the port
    try {
      serialPort = (SerialPort) portId.open("JavaRs232", 2000);
      statusLb.setText (portname plus "serial port is open!");
    } catch (PortInUseException e) {
      ShowErrMesgbox (portname plus "ports are occupied, please check!");
      setComponentsEnabled(true);
      return ;
    }
    
    Set the port parameters
    try {
      int rate = Integer.parseInt(this.rate);
      int data = Integer.parseInt(this.data);
      int stop = stopCombox.getSelectedIndex()+1;
      int parity = parityCombox.getSelectedIndex();
      serialPort.setSerialPortParams(rate,data,stop,parity);
    } catch (UnsupportedCommOperationException e) {
      showErrMesgbox(e.getMessage());
    }

    Open the port's IO flow pipeline 
    try { 
      outputStream = serialPort.getOutputStream(); 
      inputStream = serialPort.getInputStream(); 
    } catch (IOException e) {
      showErrMesgbox(e.getMessage());
    } 

    Add a listener to the port
    try { 
      serialPort.addEventListener(this); 
    } catch (TooManyListenersException e) {
      showErrMesgbox(e.getMessage());
    } 

    serialPort.notifyOnDataAvailable(true); 
  } 
  
  /**
   Send data to the serial port
   :: @since 2012-3-23 at 12:05:00 AM
   */
  public void sendDataToSeriaPort() { 
    try { 
      sendCount++;
      outputStream.write(mesg.getBytes()); 
      outputStream.flush(); 

    } catch (IOException e) { 
      showErrMesgbox(e.getMessage());
    } 
    
    statusLb.setText ("Send: "sendCount plus" receive: ""-reciveCount");
  } 
  
  /**
   :: Close the serial port
   :: @since 2012-3-23 at 12:05:28 AM
   */
  public void closeSerialPort() { 
    try { 
      if(outputStream != null)
        outputStream.close();
      if(serialPort != null)
        serialPort.close(); 
      serialPort = null;
      statusLb.setText (portname plus "serial port is closed!");
      sendCount = 0;
      reciveCount = 0;
      sendTf.setText("");
      readTa.setText("");
    } catch (Exception e) { 
      showErrMesgbox(e.getMessage());
    } 
  }   
  
  /**
   :: Display an error or warning message
   :: @param msg information
   :: @since March 23, 2012 12:05:47 AM
   */
  public void showErrMesgbox(String msg) {
    JOptionPane.showMessageDialog(this, msg);
  }

  /**
   :: Each component behavior event listens
   */
  public void actionPerformed(ActionEvent e) {
    if(e.getSource() == portCombox
        || e.getSource() == rateCombox
        || e.getSource() == dataCombox
        || e.getSource() == stopCombox
        || e.getSource() == parityCombox){
      statusLb.setText(initStatus());
    }
    if(e.getSource() == openPortBtn){
      setComponentsEnabled(false);      
      openSerialPort();
    }
    if(e.getSource() == closePortBtn){
      if(serialPort != null){
        closeSerialPort();
      }
      setComponentsEnabled(true);
    }
    
    if(e.getSource() == sendMsgBtn){
      if(serialPort == null){
        ShowErrMesgbox ("Please open the serial port first!");
        return ;
      }
      mesg = sendTf.getText();
      if(null == mesg || mesg.isEmpty()){
        ShowErrMesgbox ("Please enter what you want to send!");
        return ;
      }
      sendDataToSeriaPort();
    }
  }

  /**
   :: Port event monitoring
   */
  public void serialEvent(SerialPortEvent event) {
    switch (event.getEventType()) {
      case SerialPortEvent.BI:
      case SerialPortEvent.OE:
      case SerialPortEvent.FE:
      case SerialPortEvent.PE:
      case SerialPortEvent.CD:
      case SerialPortEvent.CTS:
      case SerialPortEvent.DSR:
      case SerialPortEvent.RI:
      case SerialPortEvent.OUTPUT_BUFFER_EMPTY:
        break;
      case SerialPortEvent.DATA_AVAILABLE:
        byte[] readBuffer = new byte[50];

      try {
        while (inputStream.available() > 0) {
          inputStream.read(readBuffer);
        }
        StringBuilder receivedMsg = new StringBuilder("/-- ");
        receivedMsg.append(new String(readBuffer).trim()).append(" --/\n");
        readTa.append(receivedMsg.toString());
        reciveCount++;
        statusLb.setText ("Send: "sendCount plus" receive: ""-reciveCount");
      } catch (IOException e) {
        showErrMesgbox(e.getMessage());
      }
    }
  }
  
  /**
   Set the switch status of each component
   :: @param the enabled status
   :: @since March 23, 2012 12:06:24 AM
   */
  public void setComponentsEnabled(boolean enabled) {
    openPortBtn.setEnabled(enabled);
    openPortBtn.setEnabled(enabled);
    portCombox.setEnabled(enabled);
    rateCombox.setEnabled(enabled);
    dataCombox.setEnabled(enabled);
    stopCombox.setEnabled(enabled);
    parityCombox.setEnabled(enabled);
  }
  
  /**
   Run the main function
   * @param args
   :: @since 2012-3-23 at 12:06:45 AM
   */
  public static void main(String[] args) {
    new JavaRs232();    
  }
}

```

The code is written, press the F11 key to enter the debugging state, everything is working well, please see figure:

:: Start the interface

![java-hard-rsr232-3](//lisenhui.gitee.io/imgs/blog/2012/03-24-java-hard-rsr232-3.png)

Port detection

![java-hard-rsr232-4](//lisenhui.gitee.io/imgs/blog/2012/03-24-java-hard-rsr232-4.png)

:: Communication testing

![java-hard-rsr232-5](//lisenhui.gitee.io/imgs/blog/2012/03-24-java-hard-rsr232-5.png)

Finally take the time to beautify the program, the effect is more beautiful

![java-hard-rsr232-6](//lisenhui.gitee.io/imgs/blog/2012/03-24-java-hard-rsr232-6.png)

![java-hard-rsr232-7](//lisenhui.gitee.io/imgs/blog/2012/03-24-java-hard-rsr232-7.png)

PS: (http://dl.iteye.com/topics/download/80f67e6e-45eb-31ff-8086-da09f8d5762e)
