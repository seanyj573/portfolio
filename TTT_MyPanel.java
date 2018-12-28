import java.awt.Color;
import java.awt.Graphics;

import javax.swing.JPanel;

@SuppressWarnings("serial")
public class MyPanel extends JPanel{

	HandlerClass mouseHandler = new HandlerClass();

	public MyPanel() {
		setLayout(null);
		setBackground(Color.white);

		addMouseListener(mouseHandler);
	}

	public void paintComponent(Graphics g) {
		super.paintComponent(g);

		GridConstructor gc = new GridConstructor();

		g.setColor(Color.white);
		g.fillRect(gc.s1.x, gc.s1.y, gc.s1.width, gc.s1.height);
		g.fillRect(gc.s2.x, gc.s2.y, gc.s2.width, gc.s2.height);
		g.fillRect(gc.s3.x, gc.s3.y, gc.s3.width, gc.s3.height);
		g.fillRect(gc.s4.x, gc.s4.y, gc.s4.width, gc.s4.height);
		g.fillRect(gc.s5.x, gc.s5.y, gc.s5.width, gc.s5.height);
		g.fillRect(gc.s6.x, gc.s6.y, gc.s6.width, gc.s6.height);
		g.fillRect(gc.s7.x, gc.s7.y, gc.s7.width, gc.s7.height);
		g.fillRect(gc.s8.x, gc.s8.y, gc.s8.width, gc.s8.height);
		g.fillRect(gc.s9.x, gc.s9.y, gc.s9.width, gc.s9.height);

		g.setColor(Color.black);
		g.drawRect(gc.s1.x, gc.s1.y, gc.s1.width, gc.s1.height);
		g.drawRect(gc.s2.x, gc.s2.y, gc.s2.width, gc.s2.height);
		g.drawRect(gc.s3.x, gc.s3.y, gc.s3.width, gc.s3.height);
		g.drawRect(gc.s4.x, gc.s4.y, gc.s4.width, gc.s4.height);
		g.drawRect(gc.s5.x, gc.s5.y, gc.s5.width, gc.s5.height);
		g.drawRect(gc.s6.x, gc.s6.y, gc.s6.width, gc.s6.height);
		g.drawRect(gc.s7.x, gc.s7.y, gc.s7.width, gc.s7.height);
		g.drawRect(gc.s8.x, gc.s8.y, gc.s8.width, gc.s8.height);
		g.drawRect(gc.s9.x, gc.s9.y, gc.s9.width, gc.s9.height);
		g.setColor(Color.white);
	}
}
