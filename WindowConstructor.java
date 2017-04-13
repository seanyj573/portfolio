import java.awt.Color;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;

import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JPanel;
import javax.swing.KeyStroke;

@SuppressWarnings("serial")
public class WindowConstructor extends JPanel {
	
	static JFrame window;
	static JLabel tick;
	static JLabel toe;
	static JLabel winLine;
	static JPanel panel = new MyPanel();
	
	public WindowConstructor() {

		window = new JFrame();
		//Creates menu bar and sub-menus
		JMenuBar menuBar = new JMenuBar();
		JMenu menuGame = new JMenu("Game");
		JMenuItem itemReset = new JMenuItem("Reset");
		JMenuItem itemExit = new JMenuItem("Exit");

		itemReset.setToolTipText("Resets game");
		itemReset.setMnemonic(KeyEvent.VK_R);
		itemReset.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_R, ActionEvent.CTRL_MASK));
		itemReset.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent reset) {
				Reset();
			}
		});

		itemExit.setToolTipText("Exit Ticks and Toes");
		itemExit.setMnemonic(KeyEvent.VK_E);
		itemExit.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_E, ActionEvent.CTRL_MASK));
		itemExit.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent close) {
				System.exit(0);
			}
		});

		//Adds menu bar and sub-menus
		menuBar.setBackground(Color.lightGray);
		menuBar.add(menuGame);
		menuGame.add(itemReset);
		menuGame.add(itemExit);

		window.setJMenuBar(menuBar);
		window.add(panel);

		window.setTitle("Tic Tac Toe");
		window.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		window.setSize(473, 530);
		window.setLocationRelativeTo(null);
		window.setVisible(true);
	}
	
	public static void TickSet(int x, int y) {
		
		ImageIcon icon = new ImageIcon("Images/Tick.png");
		tick = new JLabel(icon);
		tick.setBounds(x+1, y+1, 149, 149);
		panel.add(tick, 0);
		panel.repaint();
	}
	
	public static void ToeSet(int x, int y) {
		ImageIcon icon = new ImageIcon("Images/Toe.png");
		toe = new JLabel(icon);
		toe.setBounds(x+1, y+1, 149, 149);
		panel.add(toe, 0);
		panel.repaint();
	}

	public static void WinLine(int x, int y, String str) {
		if(str.equals("h")){
			ImageIcon icon = new ImageIcon("Images/RedLineH.png");
			winLine = new JLabel(icon);
			winLine.setBounds(x, y, 450, 150);
			panel.add(winLine, 0);
			panel.repaint();
		}
		if(str.equals("v")){
			ImageIcon icon = new ImageIcon("Images/RedLineV.png");
			winLine = new JLabel(icon);
			winLine.setBounds(x, y, 150, 450);
			panel.add(winLine, 0);
			panel.repaint();
		}
		if(str.equals("dd")){
			ImageIcon icon = new ImageIcon("Images/RedLineDD.png");
			winLine = new JLabel(icon);
			winLine.setBounds(x, y, 450, 450);
			panel.add(winLine, 0);
			panel.repaint();
		}
		if(str.equals("du")){
			ImageIcon icon = new ImageIcon("Images/RedLineDU.png");
			winLine = new JLabel(icon);
			winLine.setBounds(x, y, 450, 450);
			panel.add(winLine, 0);
			panel.repaint();
		}
	}

	public void Reset() {
		HandlerClass.clickCount = 0;
		HandlerClass.listenerOn = true;
		HandlerClass.noValue1 = true;
		HandlerClass.noValue2 = true;
		HandlerClass.noValue3 = true;
		HandlerClass.noValue4 = true;
		HandlerClass.noValue5 = true;
		HandlerClass.noValue6 = true;
		HandlerClass.noValue7 = true;
		HandlerClass.noValue8 = true;
		HandlerClass.noValue9 = true;
		WinnerClass.s1 = 0;
		WinnerClass.s2 = 0;
		WinnerClass.s3 = 0;
		WinnerClass.s4 = 0;
		WinnerClass.s5 = 0;
		WinnerClass.s6 = 0;
		WinnerClass.s7 = 0;
		WinnerClass.s8 = 0;
		WinnerClass.s9 = 0;
		panel.removeAll();
		panel.repaint();
	}
}
