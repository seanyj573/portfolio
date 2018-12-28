import java.applet.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import javax.swing.Timer;

public class Pong extends Applet implements ActionListener, KeyListener {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	Ball ball;
	PaddleLeft paddleLeft;
	PaddleRight paddleRight;
	//PaddleRightAI paddleRightAI;
	final int HEIGHT = 600, WIDTH = 1000;
	Graphics bufferGraphics;
	Image offscreen;
	boolean leftUp, leftDown, rightUp, rightDown, gameStart, hasSpedUp = false;
	int isFirstGame, hitRally, leftScore, rightScore = 0;
	Timer time;
//	AudioClip leftBlip, rightBlip;
	
	public void init() {
		this.setSize(WIDTH, HEIGHT);
		ball = new Ball();
		paddleLeft = new PaddleLeft();
		paddleRight = new PaddleRight();
		//paddleRightAI = new PaddleRightAI(ball.getY() - 70);
//		leftBlip = getAudioClip(getCodeBase(), "sounds/pongBlipF4.au");
//		rightBlip = getAudioClip(getCodeBase(), "sounds/pongBlipF5.au");
		this.setFocusable(true);
		addKeyListener(this);
		setBackground(Color.black);
		offscreen = createImage(WIDTH, HEIGHT);
		bufferGraphics = offscreen.getGraphics();
	}
	
	public void start() {
			time = new Timer(3, this);
			time.start();
			repaint();
	}
	
	public void stop() {
	}
	
	public void paint (Graphics g) {
		bufferGraphics.clearRect(0, 0, WIDTH, HEIGHT);
		
		bufferGraphics.setColor(Color.green);
		bufferGraphics.fillRoundRect(paddleLeft.xPos, paddleLeft.getPos(), 20, 140, 20, 20);
		bufferGraphics.fillRoundRect(paddleRight.xPos, paddleRight.getPos(), 20, 140, 20, 20);
		//bufferGraphics.fillRoundRect(paddleRightAI.xPos, paddleRightAI.getPos(), 20, 140, 10, 10);
		bufferGraphics.fillRoundRect(ball.getX(), ball.getY(), 20, 20, 20, 20);
		
		bufferGraphics.setColor(Color.white);
		bufferGraphics.setFont(new Font(null, Font.PLAIN, 25));
		bufferGraphics.drawString("Score: " + leftScore, 20, 40);
		bufferGraphics.setFont(new Font(null, Font.PLAIN, 25));
		bufferGraphics.drawString("Score: " + rightScore, 880, 40);
		
		if(!gameStart) {
			bufferGraphics.setColor(Color.white);
			bufferGraphics.setFont(new Font(null, Font.PLAIN, 25));
			if(isFirstGame == 0) {
				bufferGraphics.drawString("Press enter to play", 395, (int)HEIGHT/4);
			} else {
				bufferGraphics.drawString("Press enter to play again", 370, (int)HEIGHT/4);
			}
		}
		
		g.drawImage(offscreen, 0, 0, this);
	}
	
	public void update(Graphics g) {
		paint(g);
		if(hitRally == 2 && !hasSpedUp) {
			if(ball.getX() > 0 && ball.getY() > 0) {
				ball.setPos(getX() + ball.dx + 1, getY() + ball.dy + 1);
			} else if(ball.getX() < 0 && ball.getY() < 0) {
				ball.setPos(getX() + ball.dx - 1, getY() - ball.dy + 1);
			} else if(ball.getX() > 0 && ball.getY() < 0) {
				ball.setPos(getX() + ball.dx + 1, getY() + ball.dy - 1);
			} else if(ball.getX() < 0 && ball.getY() > 0) {
				ball.setPos(getX() + ball.dx - 1, getY() + ball.dy + 1);
			}
			hasSpedUp = true;
		}
		if(leftUp) {
			paddleLeft.setPos(paddleLeft.getPos()-2);
		} else if(leftDown) {
			paddleLeft.setPos(paddleLeft.getPos()+2);
		}
		if(rightUp) {
			paddleRight.setPos(paddleRight.getPos()-2);
		} else if(rightDown) {
			paddleRight.setPos(paddleRight.getPos()+2);
		}
	}

	public void checkCollision() {
		if(ball.getY() == 0 || ball.getY() == 580) {
			ball.dy = (ball.dy * -1);
		}
		
		if(ball.getX() == 80 && hitPaddleLeft()) {
			ball.dx = (ball.dx * -1);
		} else if(ball.getX() == 0) {
			gameStart = false;
			paddleLeft.setPos(230);
			paddleRight.setPos(230);
			rightScore++;
			ball.reset();
		}
		
		if(ball.getX() == 900 && hitPaddleRight()) {
			ball.dx = (ball.dx * -1);
		} else if(ball.getX() == 980) {
			gameStart = false;
			paddleLeft.setPos(230);
			paddleRight.setPos(230);
			leftScore++;
			ball.reset();
		}
	}
	
	public boolean hitPaddleLeft() {
		boolean hit = false;
		if(paddleLeft.getPos() - 20 < ball.getY() && paddleLeft.getPos() + 140 >= ball.getY()) {
			hitRally++;
			hit = true;
//			leftBlip.play();
		}
		return hit;
	}
	
	public boolean hitPaddleRight() {
		boolean hit = false;
		if(paddleRight.getPos() - 20 < ball.getY() && paddleRight.getPos() + 140 >= ball.getY()){
			hitRally++;
			hit = true;
//			rightBlip.play();
		}
		return hit;
	}
	
	@Override
	public void actionPerformed(ActionEvent e) {
		if(gameStart) {
			ball.move();
			//paddleRightAI.setPos(ball.getY() - 60);
			checkCollision();

			repaint();
		}
	}

	@Override
	public void keyTyped(KeyEvent e) {
	}

	@Override
	public void keyPressed(KeyEvent e) {
		if(e.getKeyCode() == KeyEvent.VK_W) {
			leftUp = true;
		} else if(e.getKeyCode() == KeyEvent.VK_S) {
			leftDown = true;
		}
		if(e.getKeyCode() == KeyEvent.VK_UP) {
			rightUp = true;
		} else if(e.getKeyCode() == KeyEvent.VK_DOWN) {
			rightDown = true;
		}
		if(e.getKeyCode() == KeyEvent.VK_ENTER) {
			isFirstGame++;
			gameStart = true;
		}
	}
	
	@Override
	public void keyReleased(KeyEvent e) {
		if(e.getKeyCode() == KeyEvent.VK_W) {
			leftUp = false;
		} else if(e.getKeyCode() == KeyEvent.VK_S) {
			leftDown = false;
		}
		if(e.getKeyCode() == KeyEvent.VK_UP) {
			rightUp = false;
		} else if(e.getKeyCode() == KeyEvent.VK_DOWN) {
			rightDown = false;
		}
	}
}
